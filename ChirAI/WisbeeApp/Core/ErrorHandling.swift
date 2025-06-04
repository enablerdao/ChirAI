import Foundation
import SwiftUI

// MARK: - Comprehensive Error Handling System

enum WisbeeError: Error, LocalizedError {
    case networkError(String)
    case apiError(String)
    case modelNotFound(String)
    case invalidResponse
    case authenticationFailed
    case rateLimitExceeded
    case serverTimeout
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "ネットワークエラー: \(message)"
        case .apiError(let message):
            return "APIエラー: \(message)"
        case .modelNotFound(let model):
            return "モデル '\(model)' が見つかりません"
        case .invalidResponse:
            return "無効な応答を受信しました"
        case .authenticationFailed:
            return "認証に失敗しました"
        case .rateLimitExceeded:
            return "レート制限に達しました。しばらく待ってから再試行してください"
        case .serverTimeout:
            return "サーバーがタイムアウトしました"
        case .unknownError(let message):
            return "予期しないエラー: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "インターネット接続を確認してください"
        case .apiError:
            return "しばらく待ってから再試行してください"
        case .modelNotFound:
            return "利用可能なモデルから選択してください"
        case .invalidResponse:
            return "アプリを再起動してください"
        case .authenticationFailed:
            return "設定を確認してください"
        case .rateLimitExceeded:
            return "数分待ってから再試行してください"
        case .serverTimeout:
            return "ネットワーク接続を確認してください"
        case .unknownError:
            return "アプリを再起動してください"
        }
    }
}

// MARK: - Error Handler
class ErrorHandler: ObservableObject {
    @Published var currentError: WisbeeError?
    @Published var showError = false
    
    func handle(_ error: Error) {
        DispatchQueue.main.async {
            if let wisbeeError = error as? WisbeeError {
                self.currentError = wisbeeError
            } else {
                self.currentError = WisbeeError.unknownError(error.localizedDescription)
            }
            self.showError = true
            
            // Log error for debugging
            self.logError(self.currentError!)
        }
    }
    
    private func logError(_ error: WisbeeError) {
        let timestamp = Date().formatted()
        print("🚨 Error at \(timestamp): \(error.localizedDescription)")
        
        // In production, this would send to analytics service
        #if DEBUG
        print("Debug info: \(error)")
        #endif
    }
    
    func clearError() {
        currentError = nil
        showError = false
    }
}

// MARK: - Error Alert View
struct ErrorAlertView: View {
    @ObservedObject var errorHandler: ErrorHandler
    
    var body: some View {
        EmptyView()
            .alert("エラーが発生しました", isPresented: $errorHandler.showError) {
                Button("再試行") {
                    // Retry logic would go here
                    errorHandler.clearError()
                }
                Button("キャンセル", role: .cancel) {
                    errorHandler.clearError()
                }
            } message: {
                VStack(alignment: .leading, spacing: 8) {
                    if let error = errorHandler.currentError {
                        Text(error.localizedDescription)
                        if let suggestion = error.recoverySuggestion {
                            Text(suggestion)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
    }
}

// MARK: - Network Monitor
class NetworkMonitor: ObservableObject {
    @Published var isConnected = true
    @Published var connectionType: ConnectionType = .wifi
    
    enum ConnectionType {
        case wifi
        case cellular
        case none
    }
    
    init() {
        // Simplified network monitoring
        // In production, would use Network framework
        checkConnection()
    }
    
    private func checkConnection() {
        // Simplified check
        DispatchQueue.global().async {
            let url = URL(string: "http://localhost:11434/api/tags")!
            let request = URLRequest(url: url)
            request.timeoutInterval = 2.0
            
            URLSession.shared.dataTask(with: request) { _, response, _ in
                DispatchQueue.main.async {
                    self.isConnected = response != nil
                }
            }.resume()
        }
    }
}

// MARK: - Retry Mechanism
struct RetryManager {
    static func withRetry<T>(
        maxAttempts: Int = 3,
        delay: TimeInterval = 1.0,
        operation: @escaping () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        
        for attempt in 1...maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                
                if attempt < maxAttempts {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? WisbeeError.unknownError("Retry failed")
    }
}