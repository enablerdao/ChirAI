import Foundation
import SwiftUI

// MARK: - Data Manager for Chat History and Preferences

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var chatHistory: [ChatSession] = []
    @Published var userPreferences = UserPreferences()
    
    private let chatHistoryKey = "chatHistory"
    private let userPreferencesKey = "userPreferences"
    
    private init() {
        loadData()
    }
    
    // MARK: - Chat History Management
    
    func saveChatSession(_ session: ChatSession) {
        if let index = chatHistory.firstIndex(where: { $0.id == session.id }) {
            chatHistory[index] = session
        } else {
            chatHistory.append(session)
        }
        saveChatHistory()
    }
    
    func deleteChatSession(_ session: ChatSession) {
        chatHistory.removeAll { $0.id == session.id }
        saveChatHistory()
    }
    
    func searchChatHistory(_ query: String) -> [ChatSession] {
        guard !query.isEmpty else { return chatHistory }
        
        return chatHistory.filter { session in
            session.messages.contains { message in
                message.content.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    // MARK: - User Preferences
    
    func updatePreferences(_ preferences: UserPreferences) {
        userPreferences = preferences
        saveUserPreferences()
    }
    
    // MARK: - Private Methods
    
    private func loadData() {
        loadChatHistory()
        loadUserPreferences()
    }
    
    private func loadChatHistory() {
        guard let data = UserDefaults.standard.data(forKey: chatHistoryKey),
              let sessions = try? JSONDecoder().decode([ChatSession].self, from: data) else {
            return
        }
        chatHistory = sessions
    }
    
    private func saveChatHistory() {
        guard let data = try? JSONEncoder().encode(chatHistory) else { return }
        UserDefaults.standard.set(data, forKey: chatHistoryKey)
    }
    
    private func loadUserPreferences() {
        guard let data = UserDefaults.standard.data(forKey: userPreferencesKey),
              let preferences = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
            return
        }
        userPreferences = preferences
    }
    
    private func saveUserPreferences() {
        guard let data = try? JSONEncoder().encode(userPreferences) else { return }
        UserDefaults.standard.set(data, forKey: userPreferencesKey)
    }
    
    // MARK: - Export/Import
    
    func exportChatHistory() -> Data? {
        return try? JSONEncoder().encode(chatHistory)
    }
    
    func importChatHistory(from data: Data) -> Bool {
        guard let sessions = try? JSONDecoder().decode([ChatSession].self, from: data) else {
            return false
        }
        chatHistory = sessions
        saveChatHistory()
        return true
    }
}

// MARK: - Chat Session Model
struct ChatSession: Identifiable, Codable {
    let id = UUID()
    var title: String
    var messages: [ChatMessage]
    var model: String
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String = "新しいチャット", model: String = "gemma3:1b") {
        self.title = title
        self.messages = []
        self.model = model
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func addMessage(_ message: ChatMessage) {
        messages.append(message)
        updatedAt = Date()
        
        // Auto-generate title from first user message
        if title == "新しいチャット" && message.isUser && !message.content.isEmpty {
            title = String(message.content.prefix(30))
        }
    }
}

// MARK: - Enhanced Chat Message
struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    let model: String?
    var metadata: MessageMetadata?
    
    init(content: String, isUser: Bool, model: String? = nil) {
        self.content = content
        self.isUser = isUser
        self.timestamp = Date()
        self.model = model
        self.metadata = nil
    }
}

// MARK: - Message Metadata
struct MessageMetadata: Codable {
    var responseTime: TimeInterval?
    var tokenCount: Int?
    var language: String?
    var sentiment: String?
    var topics: [String]?
}

// MARK: - User Preferences
struct UserPreferences: Codable {
    var preferredModel: String = "gemma3:1b"
    var theme: AppTheme = .dark
    var fontSize: FontSize = .medium
    var enableHaptics: Bool = true
    var enableAnimations: Bool = true
    var autoSave: Bool = true
    var maxHistoryDays: Int = 30
    
    enum AppTheme: String, Codable, CaseIterable {
        case light = "light"
        case dark = "dark"
        case auto = "auto"
        
        var displayName: String {
            switch self {
            case .light: return "ライト"
            case .dark: return "ダーク"
            case .auto: return "自動"
            }
        }
    }
    
    enum FontSize: String, Codable, CaseIterable {
        case small = "small"
        case medium = "medium"
        case large = "large"
        case extraLarge = "extraLarge"
        
        var displayName: String {
            switch self {
            case .small: return "小"
            case .medium: return "中"
            case .large: return "大"
            case .extraLarge: return "特大"
            }
        }
        
        var scale: CGFloat {
            switch self {
            case .small: return 0.85
            case .medium: return 1.0
            case .large: return 1.15
            case .extraLarge: return 1.3
            }
        }
    }
}

// MARK: - Cache Manager
class CacheManager: ObservableObject {
    static let shared = CacheManager()
    
    private let cache = NSCache<NSString, NSData>()
    private let maxCacheSize = 50 * 1024 * 1024 // 50MB
    
    private init() {
        cache.totalCostLimit = maxCacheSize
    }
    
    func cacheResponse(_ response: String, for key: String) {
        let data = response.data(using: .utf8) ?? Data()
        cache.setObject(NSData(data: data), forKey: NSString(string: key))
    }
    
    func getCachedResponse(for key: String) -> String? {
        guard let data = cache.object(forKey: NSString(string: key)) as Data? else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

// MARK: - Analytics Manager
class AnalyticsManager: ObservableObject {
    static let shared = AnalyticsManager()
    
    @Published var metrics = AppMetrics()
    
    private init() {
        loadMetrics()
    }
    
    func trackEvent(_ event: AnalyticsEvent) {
        switch event {
        case .messagesSent:
            metrics.totalMessages += 1
        case .modelSwitch(let model):
            metrics.modelUsage[model, default: 0] += 1
        case .sessionStart:
            metrics.totalSessions += 1
        case .error(let error):
            metrics.errorCount += 1
            metrics.lastError = error
        }
        
        saveMetrics()
    }
    
    private func loadMetrics() {
        guard let data = UserDefaults.standard.data(forKey: "appMetrics"),
              let loadedMetrics = try? JSONDecoder().decode(AppMetrics.self, from: data) else {
            return
        }
        metrics = loadedMetrics
    }
    
    private func saveMetrics() {
        guard let data = try? JSONEncoder().encode(metrics) else { return }
        UserDefaults.standard.set(data, forKey: "appMetrics")
    }
}

// MARK: - App Metrics
struct AppMetrics: Codable {
    var totalMessages: Int = 0
    var totalSessions: Int = 0
    var modelUsage: [String: Int] = [:]
    var errorCount: Int = 0
    var lastError: String = ""
    var firstLaunch: Date = Date()
    var lastLaunch: Date = Date()
}

// MARK: - Analytics Events
enum AnalyticsEvent {
    case messagesSent
    case modelSwitch(String)
    case sessionStart
    case error(String)
}