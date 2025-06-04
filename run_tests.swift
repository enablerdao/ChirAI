#!/usr/bin/env swift

import Foundation

// Simple test runner for Wisbee iOS app
print("🧪 Running Wisbee iOS Tests")
print(String(repeating: "=", count: 50))

// Test 1: Check if Ollama is running
func testOllamaConnection() -> Bool {
    print("\n📍 Test 1: Ollama Connection")
    let url = URL(string: "http://localhost:11434/api/tags")!
    let semaphore = DispatchSemaphore(value: 0)
    var success = false
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("✅ Ollama is running")
            success = true
        } else {
            print("❌ Ollama is not running or not accessible")
        }
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    return success
}

// Test 2: Check available models
func testAvailableModels() {
    print("\n📍 Test 2: Available Models")
    let models = [
        "gemma3:1b",
        "gemma3:4b", 
        "qwen2.5:3b",
        "jaahas/qwen3-abliterated:0.6b"
    ]
    
    let url = URL(string: "http://localhost:11434/api/tags")!
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let modelList = json["models"] as? [[String: Any]] {
            
            let availableModels = modelList.compactMap { $0["name"] as? String }
            
            for model in models {
                if availableModels.contains(model) {
                    print("✅ Model \(model) is available")
                } else {
                    print("⚠️  Model \(model) is not available")
                }
            }
        }
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
}

// Test 3: Test model response
func testModelResponse(model: String, prompt: String) {
    print("\n📍 Test 3: Model Response Test - \(model)")
    print("Prompt: \(prompt)")
    
    let url = URL(string: "http://localhost:11434/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = [
        "model": model,
        "messages": [["role": "user", "content": prompt]],
        "stream": false
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    let semaphore = DispatchSemaphore(value: 0)
    let startTime = Date()
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        let responseTime = Date().timeIntervalSince(startTime)
        
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let choices = json["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let content = message["content"] as? String {
            
            print("✅ Response received in \(String(format: "%.2f", responseTime))s")
            print("Response: \(String(content.prefix(100)))...")
        } else {
            print("❌ Failed to get response")
        }
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
}

// Run all tests
print("\n🚀 Starting Tests...")

if testOllamaConnection() {
    testAvailableModels()
    testModelResponse(model: "gemma3:1b", prompt: "Hello, how are you?")
    testModelResponse(model: "qwen2.5:3b", prompt: "こんにちは、元気ですか？")
} else {
    print("\n⚠️  Please start Ollama first: ollama serve")
}

print("\n✨ Tests completed!")
print("\n📱 To launch the app:")
print("1. Open /Users/yuki/wisbee-iOS/WisbeeApp in Xcode")
print("2. Select an iOS Simulator (iPhone 15 recommended)")
print("3. Press Cmd+R to build and run")
print("\nAlternatively, the app has been opened in Xcode for you.")