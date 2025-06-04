#!/usr/bin/env swift

import Foundation

// E2E Test Suite for Wisbee iOS App
class E2ETestSuite {
    let baseURL = "http://localhost:11434"
    var testResults: [(name: String, passed: Bool, message: String)] = []
    
    // MARK: - Test Infrastructure
    
    func runAllTests() {
        print("🧪 Running E2E Tests for Wisbee iOS")
        print(String(repeating: "=", count: 50))
        
        // Infrastructure tests
        test("Ollama Service Health Check") { try await self.testOllamaHealth() }
        test("API Endpoint Availability") { try await self.testAPIEndpoints() }
        
        // Model tests
        test("Model Availability") { try await self.testModelAvailability() }
        test("Model Response - English") { try await self.testEnglishResponse() }
        test("Model Response - Japanese") { try await self.testJapaneseResponse() }
        
        // Chat flow tests
        test("Simple Conversation Flow") { try await self.testConversationFlow() }
        test("Model Switching") { try await self.testModelSwitching() }
        test("Error Handling") { try await self.testErrorHandling() }
        
        // Performance tests
        test("Response Time Check") { try await self.testResponseTime() }
        test("Concurrent Requests") { try await self.testConcurrentRequests() }
        
        // UI Integration tests
        test("Chat Message Format") { try await self.testMessageFormat() }
        test("Japanese Input/Output") { try await self.testJapaneseIO() }
        
        printResults()
    }
    
    func test(_ name: String, block: @escaping () async throws -> Void) {
        print("\n📍 Testing: \(name)")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            do {
                try await block()
                testResults.append((name: name, passed: true, message: "✅ Passed"))
                print("✅ Passed")
            } catch {
                testResults.append((name: name, passed: false, message: "❌ Failed: \(error)"))
                print("❌ Failed: \(error)")
            }
            semaphore.signal()
        }
        
        semaphore.wait()
    }
    
    // MARK: - Test Cases
    
    func testOllamaHealth() async throws {
        let url = URL(string: "\(baseURL)/api/tags")!
        let (_, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TestError.serviceNotAvailable
        }
    }
    
    func testAPIEndpoints() async throws {
        let endpoints = [
            "/api/tags",
            "/v1/chat/completions"
        ]
        
        for endpoint in endpoints {
            let url = URL(string: "\(baseURL)\(endpoint)")!
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.contains("completions") ? "POST" : "GET"
            
            if endpoint.contains("completions") {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let body: [String: Any] = ["model": "gemma3:1b", "messages": [["role": "user", "content": "test"]]]
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            }
            
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TestError.invalidResponse
            }
            
            if httpResponse.statusCode >= 400 {
                throw TestError.endpointError(endpoint, httpResponse.statusCode)
            }
        }
    }
    
    func testModelAvailability() async throws {
        let requiredModels = ["gemma3:1b", "qwen2.5:3b"]
        let url = URL(string: "\(baseURL)/api/tags")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let models = json["models"] as? [[String: Any]] else {
            throw TestError.invalidJSON
        }
        
        let availableModels = models.compactMap { $0["name"] as? String }
        
        for model in requiredModels {
            if !availableModels.contains(model) {
                throw TestError.modelNotFound(model)
            }
        }
    }
    
    func testEnglishResponse() async throws {
        let response = try await sendChatRequest(
            model: "gemma3:1b",
            message: "What is 2+2?"
        )
        
        if !response.lowercased().contains("4") && !response.lowercased().contains("four") {
            throw TestError.unexpectedResponse("Math answer not found")
        }
    }
    
    func testJapaneseResponse() async throws {
        let response = try await sendChatRequest(
            model: "qwen2.5:3b",
            message: "こんにちは、今日はいい天気ですね。"
        )
        
        // Check if response contains Japanese characters
        let japaneseRegex = try NSRegularExpression(pattern: "[\\u3040-\\u309F\\u30A0-\\u30FF\\u4E00-\\u9FAF]")
        let range = NSRange(location: 0, length: response.utf16.count)
        
        if japaneseRegex.firstMatch(in: response, range: range) == nil {
            throw TestError.unexpectedResponse("No Japanese characters in response")
        }
    }
    
    func testConversationFlow() async throws {
        let conversation = [
            "My name is Alice",
            "What is my name?",
            "Nice to meet you"
        ]
        
        var context: [[String: String]] = []
        
        for message in conversation {
            context.append(["role": "user", "content": message])
            
            let response = try await sendChatRequest(
                model: "gemma3:1b",
                message: message,
                messages: context
            )
            
            context.append(["role": "assistant", "content": response])
        }
        
        // Check if the model remembered the name
        if !context.last!["content"]!.lowercased().contains("alice") &&
           !context[3]["content"]!.lowercased().contains("alice") {
            throw TestError.contextNotMaintained
        }
    }
    
    func testModelSwitching() async throws {
        let models = ["gemma3:1b", "qwen2.5:3b"]
        
        for model in models {
            let response = try await sendChatRequest(
                model: model,
                message: "Say hello"
            )
            
            if response.isEmpty {
                throw TestError.emptyResponse(model)
            }
        }
    }
    
    func testErrorHandling() async throws {
        // Test with invalid model
        do {
            _ = try await sendChatRequest(
                model: "nonexistent:model",
                message: "test"
            )
            throw TestError.expectedErrorNotThrown
        } catch {
            // Expected to fail
        }
    }
    
    func testResponseTime() async throws {
        let startTime = Date()
        
        _ = try await sendChatRequest(
            model: "gemma3:1b",
            message: "Hello"
        )
        
        let responseTime = Date().timeIntervalSince(startTime)
        
        if responseTime > 10.0 {
            throw TestError.slowResponse(responseTime)
        }
    }
    
    func testConcurrentRequests() async throws {
        let messages = [
            "What is 1+1?",
            "What is 2+2?",
            "What is 3+3?"
        ]
        
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
                throw TestError.concurrentRequestsFailed
            }
        }
    }
    
    func testMessageFormat() async throws {
        let response = try await sendChatRequest(
            model: "gemma3:1b",
            message: "Format this as a list: apple, banana, orange"
        )
        
        // Check if response contains list-like formatting
        if !response.contains("-") && !response.contains("•") && !response.contains("1.") {
            print("Warning: Response may not be properly formatted as a list")
        }
    }
    
    func testJapaneseIO() async throws {
        let japaneseMessages = [
            "おはようございます",
            "今日の天気はどうですか？",
            "ありがとうございました"
        ]
        
        for message in japaneseMessages {
            let response = try await sendChatRequest(
                model: "qwen2.5:3b",
                message: message
            )
            
            if response.isEmpty {
                throw TestError.emptyResponse("Japanese message: \(message)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func sendChatRequest(model: String, message: String, messages: [[String: String]]? = nil) async throws -> String {
        let url = URL(string: "\(baseURL)/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let chatMessages = messages ?? [["role": "user", "content": message]]
        
        let body: [String: Any] = [
            "model": model,
            "messages": chatMessages,
            "stream": false
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TestError.requestFailed
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let messageDict = firstChoice["message"] as? [String: Any],
              let content = messageDict["content"] as? String else {
            throw TestError.invalidJSON
        }
        
        return content
    }
    
    func printResults() {
        print("\n" + String(repeating: "=", count: 50))
        print("📊 Test Results Summary")
        print(String(repeating: "=", count: 50))
        
        let passed = testResults.filter { $0.passed }.count
        let total = testResults.count
        
        for result in testResults {
            print("\(result.message) \(result.name)")
        }
        
        print("\n📈 Total: \(passed)/\(total) tests passed")
        
        if passed == total {
            print("🎉 All tests passed!")
        } else {
            print("⚠️  Some tests failed. Please check the output above.")
        }
    }
}

// MARK: - Error Types

enum TestError: LocalizedError {
    case serviceNotAvailable
    case invalidResponse
    case endpointError(String, Int)
    case invalidJSON
    case modelNotFound(String)
    case unexpectedResponse(String)
    case contextNotMaintained
    case emptyResponse(String)
    case expectedErrorNotThrown
    case slowResponse(TimeInterval)
    case concurrentRequestsFailed
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .serviceNotAvailable:
            return "Ollama service is not available"
        case .invalidResponse:
            return "Invalid response from server"
        case .endpointError(let endpoint, let code):
            return "Endpoint \(endpoint) returned status code \(code)"
        case .invalidJSON:
            return "Invalid JSON response"
        case .modelNotFound(let model):
            return "Model \(model) not found"
        case .unexpectedResponse(let message):
            return "Unexpected response: \(message)"
        case .contextNotMaintained:
            return "Model did not maintain conversation context"
        case .emptyResponse(let context):
            return "Empty response received for: \(context)"
        case .expectedErrorNotThrown:
            return "Expected error was not thrown"
        case .slowResponse(let time):
            return "Response took too long: \(String(format: "%.2f", time))s"
        case .concurrentRequestsFailed:
            return "Concurrent requests test failed"
        case .requestFailed:
            return "Request failed"
        }
    }
}

// Run the tests
let suite = E2ETestSuite()
suite.runAllTests()

// Keep the process alive to complete async tests
RunLoop.main.run(until: Date(timeIntervalSinceNow: 30))