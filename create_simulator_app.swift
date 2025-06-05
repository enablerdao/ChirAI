#!/usr/bin/env xcrun swift

import SwiftUI
import Foundation

// ChirAI Simulator App for Screenshots
@available(iOS 17.0, macOS 14.0, *)
struct ChirAIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ContentView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var currentView = "chat"
    
    init() {
        // Initialize with sample messages
        _messages = State(initialValue: [
            ChatMessage(
                id: UUID(),
                content: "🌸 ChirAIへようこそ！美しい日本風デザインのローカルAIチャットアプリです。プライバシーを保護しながら、Ollamaと連携してAIと会話できます。",
                isUser: false,
                timestamp: Date()
            ),
            ChatMessage(
                id: UUID(),
                content: "プログラミングについて教えてください。SwiftUIの基本的な使い方を知りたいです。",
                isUser: true,
                timestamp: Date()
            ),
            ChatMessage(
                id: UUID(),
                content: "SwiftUIは素晴らしい選択ですね！宣言的UIフレームワークで、iOSアプリ開発を大幅に簡素化できます。\n\n基本的な構造:\n• View プロトコルを実装\n• body プロパティでUIを定義\n• @State で状態管理\n• プレビュー機能で即座確認\n\n何か具体的に知りたい部分はありますか？",
                isUser: false,
                timestamp: Date()
            )
        ])
    }
    
    var body: some View {
        ZStack {
            Color(red: 248/255, green: 249/255, blue: 250/255) // Pearl background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if currentView == "chat" {
                    chatView
                } else if currentView == "agents" {
                    agentsView
                } else if currentView == "settings" {
                    settingsView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("🌸")
                        .font(.title2)
                    Text("ChirAI")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 255/255, green: 107/255, blue: 157/255)) // Sakura Pink
                }
                Text("ローカルAIチャット")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { currentView = "agents" }) {
                    Image(systemName: "cpu")
                        .font(.title2)
                        .foregroundColor(Color(red: 78/255, green: 205/255, blue: 196/255)) // Teal
                }
                
                Button(action: { currentView = "settings" }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 78/255, green: 205/255, blue: 196/255)) // Teal
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .shadow(radius: 1)
    }
    
    private var chatView: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(messages) { message in
                        MessageBubbleView(message: message)
                    }
                }
                .padding()
            }
            
            inputView
        }
    }
    
    private var agentsView: some View {
        VStack {
            HStack {
                Text("🤖 AI エージェント")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 255/255, green: 107/255, blue: 157/255))
                Spacer()
                Button("閉じる") {
                    currentView = "chat"
                }
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 12) {
                    AgentCard(name: "qwen2.5:3b", description: "日本語に最適化されたモデル", status: "推奨", isSelected: true)
                    AgentCard(name: "gemma3:1b", description: "高速英語処理モデル", status: "推奨", isSelected: false)
                    AgentCard(name: "llama3:8b", description: "バランス型汎用モデル", status: "良い", isSelected: false)
                    AgentCard(name: "codellama:7b", description: "プログラミング特化", status: "実験的", isSelected: false)
                    AgentCard(name: "mistral:7b", description: "多言語対応モデル", status: "良い", isSelected: false)
                }
                .padding()
            }
        }
        .background(Color.white)
    }
    
    private var settingsView: some View {
        VStack {
            HStack {
                Text("⚙️ 設定")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 255/255, green: 107/255, blue: 157/255))
                Spacer()
                Button("完了") {
                    currentView = "chat"
                }
            }
            .padding()
            
            VStack(spacing: 20) {
                Text("ChirAI v1.4.0")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 16) {
                    SettingRow(icon: "🎨", title: "テーマ", value: "桜ピンク")
                    SettingRow(icon: "🌐", title: "言語", value: "日本語")
                    SettingRow(icon: "⚡", title: "応答速度", value: "高速")
                    SettingRow(icon: "🔒", title: "プライバシー", value: "最大保護")
                }
                .padding()
                
                Spacer()
                
                Text("© 2025 enablerdao")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .background(Color.white)
    }
    
    private var inputView: some View {
        HStack(spacing: 12) {
            TextField("メッセージを入力...", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                if !inputText.isEmpty {
                    messages.append(ChatMessage(
                        id: UUID(),
                        content: inputText,
                        isUser: true,
                        timestamp: Date()
                    ))
                    
                    // Simulate AI response
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        messages.append(ChatMessage(
                            id: UUID(),
                            content: "ご質問ありがとうございます。Ollamaと接続して、より詳細な回答を提供できます。",
                            isUser: false,
                            timestamp: Date()
                        ))
                    }
                    
                    inputText = ""
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color(red: 255/255, green: 107/255, blue: 157/255))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding()
                        .background(Color(red: 255/255, green: 107/255, blue: 157/255))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("🌸")
                        Text("ChirAI")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 255/255, green: 107/255, blue: 157/255))
                    }
                    
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 50)
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct AgentCard: View {
    let name: String
    let description: String
    let status: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text("🤖")
                .font(.title)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.2))
                .foregroundColor(statusColor)
                .clipShape(Capsule())
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(red: 255/255, green: 107/255, blue: 157/255))
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
    
    private var statusColor: Color {
        switch status {
        case "推奨":
            return Color(red: 255/255, green: 107/255, blue: 157/255)
        case "良い":
            return Color(red: 78/255, green: 205/255, blue: 196/255)
        default:
            return Color(red: 69/255, green: 183/255, blue: 209/255)
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct SettingRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title2)
            Text(title)
                .font(.body)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
}

// Main execution
if #available(iOS 17.0, macOS 14.0, *) {
    // This creates a preview that we can screenshot
    print("🌸 ChirAI Simulator App Ready")
    print("Use Xcode Previews or SwiftUI Playgrounds to view and screenshot")
} else {
    print("❌ Requires iOS 17.0 or macOS 14.0")
}