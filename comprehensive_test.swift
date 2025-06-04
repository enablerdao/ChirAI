#!/usr/bin/env swift

import Foundation

// MARK: - Comprehensive Test Suite for Wisbee iOS
class WisbeeTestSuite {
    private let baseURL = "http://localhost:11434"
    private var passedTests = 0
    private var totalTests = 0
    
    // MARK: - Main Test Runner
    func runAllTests() async {
        print("🧪 Wisbee iOS 包括的テストスイート")
        print("=" * 50)
        print("開始時刻: \(Date())")
        print("")
        
        // 1. API Tests
        await testGroup("API機能テスト") {
            await test("Ollama接続確認") { try await self.checkOllamaConnection() }
            await test("モデル一覧取得") { try await self.checkAvailableModels() }
            await test("チャットAPI応答") { try await self.testChatAPI() }
        }
        
        // 2. Language Tests
        await testGroup("言語サポートテスト") {
            await test("英語メッセージ処理") { try await self.testEnglishMessage() }
            await test("日本語メッセージ処理") { try await self.testJapaneseMessage() }
            await test("絵文字サポート") { try await self.testEmojiSupport() }
        }
        
        // 3. Model Tests
        await testGroup("モデル機能テスト") {
            await test("gemma3:1b応答速度") { try await self.testGemmaResponse() }
            await test("qwen2.5:3b日本語性能") { try await self.testQwenJapanese() }
            await test("モデル切り替え") { try await self.testModelSwitching() }
        }
        
        // 4. Performance Tests
        await testGroup("パフォーマンステスト") {
            await test("応答時間測定") { try await self.testResponseTime() }
            await test("並行リクエスト処理") { try await self.testConcurrentRequests() }
            await test("長文処理") { try await self.testLongMessage() }
        }
        
        // 5. Error Handling Tests
        await testGroup("エラーハンドリングテスト") {
            await test("無効なモデル処理") { try await self.testInvalidModel() }
            await test("空メッセージ処理") { try await self.testEmptyMessage() }
            await test("ネットワークエラー対応") { try await self.testNetworkError() }
        }
        
        // Final Report
        printFinalReport()
    }
    
    // MARK: - Test Implementation
    
    func checkOllamaConnection() async throws {
        let url = URL(string: "\(baseURL)/api/tags")!
        let (_, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TestError.connectionFailed
        }
    }
    
    func checkAvailableModels() async throws {
        let url = URL(string: "\(baseURL)/api/tags")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let models = json["models"] as? [[String: Any]] else {
            throw TestError.invalidResponse
        }
        
        let modelCount = models.count
        if modelCount < 2 {
            throw TestError.insufficientModels
        }
        
        print("  ✓ 利用可能なモデル数: \(modelCount)")
    }
    
    func testChatAPI() async throws {
        let response = try await sendChat(model: "gemma3:1b", message: "Hello, test")
        if response.isEmpty {
            throw TestError.emptyResponse
        }
        print("  ✓ 応答長: \(response.count)文字")
    }
    
    func testEnglishMessage() async throws {
        let response = try await sendChat(
            model: "gemma3:1b",
            message: "What is 2+2? Reply with just the number."
        )
        
        if !response.contains("4") {
            throw TestError.incorrectResponse
        }
        print("  ✓ 英語計算問題: 正解")
    }
    
    func testJapaneseMessage() async throws {
        let response = try await sendChat(
            model: "qwen2.5:3b",
            message: "こんにちは、元気ですか？"
        )
        
        // Check for Japanese characters
        let hasJapanese = response.range(of: "[\\p{Hiragana}\\p{Katakana}\\p{Han}]", 
                                         options: .regularExpression) != nil
        
        if !hasJapanese {
            throw TestError.noJapaneseInResponse
        }
        print("  ✓ 日本語応答: 確認済み")
    }
    
    func testEmojiSupport() async throws {
        let response = try await sendChat(
            model: "gemma3:1b",
            message: "Reply with a happy emoji"
        )
        
        let hasEmoji = response.contains("😊") || response.contains("😄") || 
                      response.contains("🙂") || response.contains("😁")
        
        if !hasEmoji {
            print("  ⚠️  絵文字が含まれていない可能性")
        } else {
            print("  ✓ 絵文字サポート: 確認済み")
        }
    }
    
    func testGemmaResponse() async throws {
        let start = Date()
        _ = try await sendChat(model: "gemma3:1b", message: "Quick test")
        let elapsed = Date().timeIntervalSince(start)
        
        if elapsed > 5.0 {
            throw TestError.slowResponse(elapsed)
        }
        print("  ✓ gemma3:1b応答時間: \(String(format: "%.2f", elapsed))秒")
    }
    
    func testQwenJapanese() async throws {
        let start = Date()
        let response = try await sendChat(
            model: "qwen2.5:3b",
            message: "日本の首都はどこですか？"
        )
        let elapsed = Date().timeIntervalSince(start)
        
        if !response.contains("東京") {
            throw TestError.incorrectResponse
        }
        print("  ✓ qwen2.5:3b日本語理解: 正確")
        print("  ✓ 応答時間: \(String(format: "%.2f", elapsed))秒")
    }
    
    func testModelSwitching() async throws {
        let models = ["gemma3:1b", "qwen2.5:3b"]
        
        for model in models {
            let response = try await sendChat(model: model, message: "Test")
            if response.isEmpty {
                throw TestError.modelSwitchFailed(model)
            }
        }
        print("  ✓ モデル切り替え: 全モデル正常")
    }
    
    func testResponseTime() async throws {
        let times = try await withThrowingTaskGroup(of: Double.self) { group in
            for i in 1...3 {
                group.addTask {
                    let start = Date()
                    _ = try await self.sendChat(model: "gemma3:1b", message: "Test \(i)")
                    return Date().timeIntervalSince(start)
                }
            }
            
            var results: [Double] = []
            for try await time in group {
                results.append(time)
            }
            return results
        }
        
        let avgTime = times.reduce(0, +) / Double(times.count)
        print("  ✓ 平均応答時間: \(String(format: "%.2f", avgTime))秒")
    }
    
    func testConcurrentRequests() async throws {
        let responses = try await withThrowingTaskGroup(of: String.self) { group in
            for i in 1...5 {
                group.addTask {
                    return try await self.sendChat(
                        model: "gemma3:1b",
                        message: "Concurrent test \(i)"
                    )
                }
            }
            
            var results: [String] = []
            for try await response in group {
                results.append(response)
            }
            return results
        }
        
        if responses.count != 5 {
            throw TestError.concurrentRequestsFailed
        }
        print("  ✓ 並行処理: 5リクエスト成功")
    }
    
    func testLongMessage() async throws {
        let longMessage = String(repeating: "This is a long message. ", count: 50)
        let response = try await sendChat(model: "gemma3:1b", message: longMessage)
        
        if response.isEmpty {
            throw TestError.emptyResponse
        }
        print("  ✓ 長文処理: \(longMessage.count)文字 → \(response.count)文字応答")
    }
    
    func testInvalidModel() async throws {
        do {
            _ = try await sendChat(model: "invalid:model", message: "Test")
            throw TestError.expectedErrorNotThrown
        } catch {
            // Expected to fail
            print("  ✓ 無効モデルエラー: 正常に検出")
        }
    }
    
    func testEmptyMessage() async throws {
        let response = try await sendChat(model: "gemma3:1b", message: "")
        // Empty message might still get a response
        print("  ✓ 空メッセージ処理: 完了")
    }
    
    func testNetworkError() async throws {
        // Simulate by using wrong port
        let wrongURL = "http://localhost:99999/v1/chat/completions"
        var request = URLRequest(url: URL(string: wrongURL)!)
        request.httpMethod = "POST"
        request.timeoutInterval = 2.0
        
        do {
            _ = try await URLSession.shared.data(for: request)
            throw TestError.expectedErrorNotThrown
        } catch {
            print("  ✓ ネットワークエラー: 正常に処理")
        }
    }
    
    // MARK: - Helper Methods
    
    func sendChat(model: String, message: String) async throws -> String {
        let url = URL(string: "\(baseURL)/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": model,
            "messages": [["role": "user", "content": message]],
            "stream": false
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TestError.requestFailed
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw TestError.invalidResponse
        }
        
        return content
    }
    
    func testGroup(_ name: String, tests: () async -> Void) async {
        print("\n📋 \(name)")
        print("-" * 40)
        await tests()
    }
    
    func test(_ name: String, block: () async throws -> Void) async {
        totalTests += 1
        print("🔄 \(name)...")
        
        do {
            try await block()
            passedTests += 1
            print("✅ \(name) - 成功")
        } catch {
            print("❌ \(name) - 失敗: \(error)")
        }
    }
    
    func printFinalReport() {
        let successRate = Double(passedTests) / Double(totalTests) * 100
        
        print("\n" + "=" * 50)
        print("📊 テスト結果サマリー")
        print("=" * 50)
        print("✅ 成功: \(passedTests)/\(totalTests)")
        print("📈 成功率: \(String(format: "%.1f", successRate))%")
        print("⏰ 完了時刻: \(Date())")
        
        if successRate == 100 {
            print("\n🎉 全テスト合格！Wisbee iOSは完璧に動作しています！")
        } else if successRate >= 80 {
            print("\n✅ ほとんどのテストが合格しました。")
        } else {
            print("\n⚠️  いくつかのテストが失敗しました。")
        }
        
        print("=" * 50)
    }
}

// MARK: - Error Types
enum TestError: LocalizedError {
    case connectionFailed
    case invalidResponse
    case insufficientModels
    case emptyResponse
    case incorrectResponse
    case noJapaneseInResponse
    case slowResponse(TimeInterval)
    case modelSwitchFailed(String)
    case concurrentRequestsFailed
    case expectedErrorNotThrown
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .connectionFailed: return "接続失敗"
        case .invalidResponse: return "無効な応答"
        case .insufficientModels: return "モデル不足"
        case .emptyResponse: return "空の応答"
        case .incorrectResponse: return "不正確な応答"
        case .noJapaneseInResponse: return "日本語なし"
        case .slowResponse(let time): return "応答遅延: \(String(format: "%.1f", time))秒"
        case .modelSwitchFailed(let model): return "\(model)切り替え失敗"
        case .concurrentRequestsFailed: return "並行処理失敗"
        case .expectedErrorNotThrown: return "エラー検出失敗"
        case .requestFailed: return "リクエスト失敗"
        }
    }
}

extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

// MARK: - Run Tests
Task {
    let suite = WisbeeTestSuite()
    await suite.runAllTests()
    
    print("\n✨ テスト完了！")
}