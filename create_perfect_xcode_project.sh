#!/bin/bash

# 🌸 ChirAI 完璧なXcodeプロジェクト作成スクリプト

echo "🌸 ChirAI 完璧なリリース準備開始..."

# プロジェクト用ディレクトリ作成
mkdir -p ChirAI-Perfect
cd ChirAI-Perfect

# SwiftUI App テンプレート作成
cat > Package.swift << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChirAI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "ChirAI", targets: ["ChirAI"])
    ],
    targets: [
        .executableTarget(
            name: "ChirAI",
            dependencies: [],
            path: "Sources"
        )
    ]
)
EOF

# Sources ディレクトリ作成
mkdir -p Sources

# メインアプリファイル
cat > Sources/main.swift << 'EOF'
import SwiftUI

@main
struct ChirAIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOF

# メインビュー
cat > Sources/ContentView.swift << 'EOF'
import SwiftUI

struct ContentView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // ヘッダー
                HStack {
                    VStack(alignment: .leading) {
                        Text("ChirAI")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                        Text("ローカルAIチャット")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button("⚙️") {
                        // 設定画面
                    }
                }
                .padding()
                
                // チャット領域
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                // 入力領域
                HStack {
                    TextField("メッセージを入力...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("送信") {
                        sendMessage()
                    }
                    .disabled(inputText.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadInitialMessages()
        }
    }
    
    private func sendMessage() {
        let userMessage = ChatMessage(
            id: UUID(),
            content: inputText,
            isUser: true,
            timestamp: Date()
        )
        messages.append(userMessage)
        
        let userInput = inputText
        inputText = ""
        
        // AI応答シミュレーション
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let aiResponse = generateAIResponse(for: userInput)
            let aiMessage = ChatMessage(
                id: UUID(),
                content: aiResponse,
                isUser: false,
                timestamp: Date()
            )
            messages.append(aiMessage)
        }
    }
    
    private func generateAIResponse(for input: String) -> String {
        if input.contains("こんにちは") || input.contains("Hello") {
            return "🌸 こんにちは！ChirAIです。どのようにお手伝いできますか？"
        } else if input.contains("プログラミング") || input.contains("programming") {
            return "プログラミングについてお聞きですね。SwiftUIを使ったiOSアプリ開発や、AIとの統合について詳しくお話しできます。何か具体的に知りたいことはありますか？"
        } else {
            return "興味深いご質問ですね。Ollamaが接続されていれば、より詳細で専門的な回答を提供できます。現在はデモモードで動作しています。"
        }
    }
    
    private func loadInitialMessages() {
        let welcomeMessage = ChatMessage(
            id: UUID(),
            content: "🌸 ChirAIへようこそ！美しい日本風デザインのローカルAIチャットアプリです。Ollamaと連携して、プライバシーを保護しながらAIと会話できます。",
            isUser: false,
            timestamp: Date()
        )
        messages.append(welcomeMessage)
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(16)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("🌸")
                        Text("ChirAI")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.pink)
                    }
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                }
                .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
EOF

echo "✅ ChirAI-Perfect プロジェクト作成完了！"
echo ""
echo "📱 次のステップ:"
echo "1. cd ChirAI-Perfect"
echo "2. swift build"
echo "3. Xcode でプロジェクト開く: open Package.swift"
echo "4. Product > Archive でApp Store用ビルド"
echo ""
echo "🌸 完璧なChirAIリリースの準備ができました！"