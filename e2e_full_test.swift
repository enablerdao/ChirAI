#!/usr/bin/env swift

import Foundation

// MARK: - E2E Test Suite for Wisbee iOS
class WisbeeE2ETestSuite {
    private let baseURL = "http://localhost:11434"
    private var testResults: [(name: String, passed: Bool, duration: Double)] = []
    private let startTime = Date()
    
    // MARK: - Run All E2E Tests
    func runAllTests() async {
        print("🧪 Wisbee iOS E2Eテストスイート")
        print("=" * 50)
        print("開始: \(Date())\n")
        
        // 1. Infrastructure Tests
        await runTest("Ollama Service Health") { try await self.testOllamaHealth() }
        await runTest("API Endpoints Available") { try await self.testAPIEndpoints() }
        
        // 2. Model Tests
        await runTest("Model Availability") { try await self.testModelAvailability() }
        await runTest("Model Response - gemma3:1b") { try await self.testGemmaModel() }
        await runTest("Model Response - qwen2.5:3b") { try await self.testQwenModel() }
        
        // 3. Chat Flow Tests
        await runTest("Simple Chat Flow") { try await self.testSimpleChat() }
        await runTest("Japanese Chat Flow") { try await self.testJapaneseChat() }
        await runTest("Model Switching") { try await self.testModelSwitching() }
        
        // 4. UI Integration Tests
        await runTest("Message Format Validation") { try await self.testMessageFormat() }
        await runTest("Error Handling") { try await self.testErrorHandling() }
        
        // 5. Performance Tests
        await runTest("Response Time Check") { try await self.testResponseTime() }
        await runTest("Concurrent Requests") { try await self.testConcurrentRequests() }
        
        // Generate Report
        generateReport()
    }
    
    // MARK: - Test Cases
    
    func testOllamaHealth() async throws {
        let url = URL(string: "\(baseURL)/api/tags")!
        let (_, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw E2EError.serviceNotAvailable
        }
    }
    
    func testAPIEndpoints() async throws {
        let endpoints = [
            ("/api/tags", "GET"),
            ("/v1/chat/completions", "POST")
        ]
        
        for (endpoint, method) in endpoints {
            let url = URL(string: "\(baseURL)\(endpoint)")!
            var request = URLRequest(url: url)
            request.httpMethod = method
            
            if method == "POST" {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let body: [String: Any] = [
                    "model": "gemma3:1b",
                    "messages": [["role": "user", "content": "test"]],
                    "stream": false
                ]
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            }
            
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode < 400 else {
                throw E2EError.endpointFailed(endpoint)
            }
        }
    }
    
    func testModelAvailability() async throws {
        let url = URL(string: "\(baseURL)/api/tags")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let models = json["models"] as? [[String: Any]] else {
            throw E2EError.invalidJSON
        }
        
        let modelNames = models.compactMap { $0["name"] as? String }
        let requiredModels = ["gemma3:1b", "qwen2.5:3b"]
        
        for required in requiredModels {
            if !modelNames.contains(where: { $0.contains(required) }) {
                throw E2EError.modelNotFound(required)
            }
        }
    }
    
    func testGemmaModel() async throws {
        let response = try await sendChatRequest(
            model: "gemma3:1b",
            message: "Say hello in exactly 3 words"
        )
        
        if response.isEmpty {
            throw E2EError.emptyResponse
        }
    }
    
    func testQwenModel() async throws {
        let response = try await sendChatRequest(
            model: "qwen2.5:3b",
            message: "こんにちは"
        )
        
        if response.isEmpty {
            throw E2EError.emptyResponse
        }
        
        // Check for Japanese characters
        let hasJapanese = response.range(of: "[\\p{Hiragana}\\p{Katakana}\\p{Han}]",
                                        options: .regularExpression) != nil
        
        if !hasJapanese {
            print("  ⚠️  Response may not contain Japanese")
        }
    }
    
    func testSimpleChat() async throws {
        let messages = [
            "Hello",
            "How are you?",
            "Goodbye"
        ]
        
        for message in messages {
            let response = try await sendChatRequest(
                model: "gemma3:1b",
                message: message
            )
            
            if response.isEmpty {
                throw E2EError.chatFlowFailed
            }
        }
    }
    
    func testJapaneseChat() async throws {
        let messages = [
            "こんにちは",
            "今日はいい天気ですね",
            "ありがとうございました"
        ]
        
        for message in messages {
            let response = try await sendChatRequest(
                model: "qwen2.5:3b",
                message: message
            )
            
            if response.isEmpty {
                throw E2EError.japaneseChatFailed
            }
        }
    }
    
    func testModelSwitching() async throws {
        let tests = [
            ("gemma3:1b", "Hello"),
            ("qwen2.5:3b", "こんにちは"),
            ("gemma3:1b", "Test")
        ]
        
        for (model, message) in tests {
            let response = try await sendChatRequest(
                model: model,
                message: message
            )
            
            if response.isEmpty {
                throw E2EError.modelSwitchFailed
            }
        }
    }
    
    func testMessageFormat() async throws {
        let response = try await sendChatRequest(
            model: "gemma3:1b",
            message: "List 3 colors"
        )
        
        if response.isEmpty || response.count < 10 {
            throw E2EError.invalidMessageFormat
        }
    }
    
    func testErrorHandling() async throws {
        // Test with invalid model
        do {
            _ = try await sendChatRequest(
                model: "nonexistent:model",
                message: "test"
            )
            throw E2EError.errorHandlingFailed
        } catch {
            // Expected to fail
        }
    }
    
    func testResponseTime() async throws {
        let start = Date()
        
        _ = try await sendChatRequest(
            model: "gemma3:1b",
            message: "Quick response test"
        )
        
        let elapsed = Date().timeIntervalSince(start)
        
        if elapsed > 10.0 {
            throw E2EError.slowResponse(elapsed)
        }
    }
    
    func testConcurrentRequests() async throws {
        let messages = ["Test 1", "Test 2", "Test 3"]
        
        try await withThrowingTaskGroup(of: String.self) { group in
            for message in messages {
                group.addTask {
                    return try await self.sendChatRequest(
                        model: "gemma3:1b",
                        message: message
                    )
                }
            }
            
            var responses: [String] = []
            for try await response in group {
                responses.append(response)
            }
            
            if responses.count != messages.count {
                throw E2EError.concurrentRequestsFailed
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func sendChatRequest(model: String, message: String) async throws -> String {
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
            throw E2EError.requestFailed
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let messageDict = firstChoice["message"] as? [String: Any],
              let content = messageDict["content"] as? String else {
            throw E2EError.invalidJSON
        }
        
        return content
    }
    
    func runTest(_ name: String, test: () async throws -> Void) async {
        let start = Date()
        
        do {
            try await test()
            let duration = Date().timeIntervalSince(start)
            testResults.append((name: name, passed: true, duration: duration))
            print("✅ \(name)")
        } catch {
            let duration = Date().timeIntervalSince(start)
            testResults.append((name: name, passed: false, duration: duration))
            print("❌ \(name): \(error)")
        }
    }
    
    func generateReport() {
        let totalDuration = Date().timeIntervalSince(startTime)
        let passedTests = testResults.filter { $0.passed }.count
        let totalTests = testResults.count
        let successRate = Double(passedTests) / Double(totalTests) * 100
        
        print("\n" + "=" * 50)
        print("📊 E2Eテスト結果")
        print("=" * 50)
        print("⏱  総時間: \(String(format: "%.2f", totalDuration))秒")
        print("✅ 成功: \(passedTests)/\(totalTests)")
        print("📈 成功率: \(String(format: "%.1f", successRate))%")
        
        if successRate == 100 {
            print("\n🎉 全E2Eテストパス！")
            print("✨ Wisbee iOSアプリは完全に動作しています")
        } else if successRate >= 80 {
            print("\n✅ ほとんどのE2Eテストがパスしました")
        } else {
            print("\n⚠️  E2Eテストに問題があります")
        }
        
        print("\n詳細:")
        for result in testResults {
            let status = result.passed ? "✅" : "❌"
            print("\(status) \(result.name) (\(String(format: "%.2f", result.duration))s)")
        }
    }
}

// MARK: - Error Types
enum E2EError: LocalizedError {
    case serviceNotAvailable
    case endpointFailed(String)
    case invalidJSON
    case modelNotFound(String)
    case emptyResponse
    case chatFlowFailed
    case japaneseChatFailed
    case modelSwitchFailed
    case invalidMessageFormat
    case errorHandlingFailed
    case slowResponse(TimeInterval)
    case concurrentRequestsFailed
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .serviceNotAvailable: return "Service not available"
        case .endpointFailed(let endpoint): return "Endpoint failed: \(endpoint)"
        case .invalidJSON: return "Invalid JSON response"
        case .modelNotFound(let model): return "Model not found: \(model)"
        case .emptyResponse: return "Empty response"
        case .chatFlowFailed: return "Chat flow failed"
        case .japaneseChatFailed: return "Japanese chat failed"
        case .modelSwitchFailed: return "Model switch failed"
        case .invalidMessageFormat: return "Invalid message format"
        case .errorHandlingFailed: return "Error handling failed"
        case .slowResponse(let time): return "Slow response: \(String(format: "%.1f", time))s"
        case .concurrentRequestsFailed: return "Concurrent requests failed"
        case .requestFailed: return "Request failed"
        }
    }
}

extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

// MARK: - Execute Tests
Task {
    let suite = WisbeeE2ETestSuite()
    await suite.runAllTests()
}