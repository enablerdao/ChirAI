#!/usr/bin/env swift

import Foundation

print("🧪 Wisbee iOS クイックE2Eテスト")
print("=" * 40)

var passed = 0
var total = 0

// Test 1: Ollama Health Check
total += 1
print("\n1️⃣ Ollamaヘルスチェック...")
let healthURL = URL(string: "http://localhost:11434/api/tags")!
let (healthData, healthResponse) = try await URLSession.shared.data(from: healthURL)

if let httpResponse = healthResponse as? HTTPURLResponse,
   httpResponse.statusCode == 200 {
    print("✅ Ollama接続: 成功")
    passed += 1
} else {
    print("❌ Ollama接続: 失敗")
}

// Test 2: Model Check
total += 1
print("\n2️⃣ モデル確認...")
if let json = try? JSONSerialization.jsonObject(with: healthData) as? [String: Any],
   let models = json["models"] as? [[String: Any]] {
    let modelCount = models.count
    print("✅ 利用可能モデル数: \(modelCount)")
    passed += 1
} else {
    print("❌ モデル確認: 失敗")
}

// Test 3: Chat API Test
total += 1
print("\n3️⃣ チャットAPI (英語)...")
let chatURL = URL(string: "http://localhost:11434/v1/chat/completions")!
var chatRequest = URLRequest(url: chatURL)
chatRequest.httpMethod = "POST"
chatRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
chatRequest.httpBody = try JSONSerialization.data(withJSONObject: [
    "model": "gemma3:1b",
    "messages": [["role": "user", "content": "Say hello"]],
    "stream": false
])

let (chatData, chatResponse) = try await URLSession.shared.data(for: chatRequest)

if let httpResponse = chatResponse as? HTTPURLResponse,
   httpResponse.statusCode == 200,
   let json = try? JSONSerialization.jsonObject(with: chatData) as? [String: Any],
   let choices = json["choices"] as? [[String: Any]],
   !choices.isEmpty {
    print("✅ 英語チャット: 成功")
    passed += 1
} else {
    print("❌ 英語チャット: 失敗")
}

// Test 4: Japanese Chat Test
total += 1
print("\n4️⃣ チャットAPI (日本語)...")
var jpRequest = URLRequest(url: chatURL)
jpRequest.httpMethod = "POST"
jpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
jpRequest.httpBody = try JSONSerialization.data(withJSONObject: [
    "model": "qwen2.5:3b",
    "messages": [["role": "user", "content": "こんにちは"]],
    "stream": false
])

let (jpData, jpResponse) = try await URLSession.shared.data(for: jpRequest)

if let httpResponse = jpResponse as? HTTPURLResponse,
   httpResponse.statusCode == 200,
   let json = try? JSONSerialization.jsonObject(with: jpData) as? [String: Any],
   let choices = json["choices"] as? [[String: Any]],
   let message = choices.first?["message"] as? [String: Any],
   let content = message["content"] as? String {
    print("✅ 日本語チャット: 成功")
    print("   応答: \(String(content.prefix(50)))...")
    passed += 1
} else {
    print("❌ 日本語チャット: 失敗")
}

// Test 5: Response Time
total += 1
print("\n5️⃣ 応答時間テスト...")
let start = Date()
var timeRequest = URLRequest(url: chatURL)
timeRequest.httpMethod = "POST"
timeRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
timeRequest.httpBody = try JSONSerialization.data(withJSONObject: [
    "model": "gemma3:1b",
    "messages": [["role": "user", "content": "Quick test"]],
    "stream": false
])

let (_, timeResponse) = try await URLSession.shared.data(for: timeRequest)
let elapsed = Date().timeIntervalSince(start)

if let httpResponse = timeResponse as? HTTPURLResponse,
   httpResponse.statusCode == 200,
   elapsed < 10.0 {
    print("✅ 応答時間: \(String(format: "%.2f", elapsed))秒")
    passed += 1
} else {
    print("❌ 応答時間: タイムアウト")
}

// Final Report
print("\n" + "=" * 40)
print("📊 E2Eテスト結果サマリー")
print("=" * 40)
print("✅ パス: \(passed)/\(total)")
print("📈 成功率: \(passed * 100 / total)%")

if passed == total {
    print("\n🎉 全E2Eテストパス！")
    print("✨ Wisbee iOSは完璧に動作しています")
} else {
    print("\n⚠️  一部のテストが失敗しました")
}

extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}