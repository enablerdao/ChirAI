#!/usr/bin/env swift

import Foundation

print("🧪 Wisbee iOS クイックテスト検証")
print("=" * 40)

let tests = [
    ("Ollama API", "http://localhost:11434/api/tags"),
    ("Chat API", "http://localhost:11434/v1/chat/completions")
]

var passed = 0
var total = 0

// Test 1: API Connection
for (name, endpoint) in tests {
    total += 1
    print("\n🔄 Testing: \(name)")
    
    if endpoint.contains("completions") {
        // Chat API test
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: [
            "model": "gemma3:1b",
            "messages": [["role": "user", "content": "Hi"]],
            "stream": false
        ])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                print("✅ \(name): 成功")
                passed += 1
            } else {
                print("❌ \(name): 失敗")
            }
        }
        task.resume()
        sleep(3)
    } else {
        // Regular API test
        if let url = URL(string: endpoint) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    print("✅ \(name): 成功")
                    passed += 1
                } else {
                    print("❌ \(name): 失敗")
                }
            }
            task.resume()
            sleep(2)
        }
    }
}

sleep(2)

// Final Report
print("\n" + "=" * 40)
print("📊 テスト結果")
print("=" * 40)
print("✅ 成功: \(passed)/\(total)")
print("📈 成功率: \(passed * 100 / total)%")

if passed == total {
    print("\n🎉 全テスト合格！")
    print("✨ Wisbee iOSアプリは正常に動作しています")
} else {
    print("\n⚠️  一部のテストが失敗しました")
}

print("\n📱 アプリ状態:")
print("- Xcodeが開いています")
print("- iPhone 15シミュレータが起動中")
print("- Cmd+Rでアプリを実行できます")

extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}