import Foundation
import SwiftUI

@MainActor
class ChatManager: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    
    private let ollamaService = OllamaService()
    
    init() {
        addWelcomeMessage()
    }
    
    private func addWelcomeMessage() {
        let welcomeMessage = ChatMessage(
            id: UUID(),
            content: "🌸 ChirAIへようこそ！美しい日本風デザインのローカルAIチャットアプリです。プライバシーを保護しながら、Ollamaと連携してAIと会話できます。",
            isUser: false,
            timestamp: Date()
        )
        messages.append(welcomeMessage)
    }
    
    func sendMessage() async {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(
            id: UUID(),
            content: inputText,
            isUser: true,
            timestamp: Date()
        )
        
        messages.append(userMessage)
        let userInput = inputText
        inputText = ""
        isLoading = true
        
        do {
            let aiResponse = try await ollamaService.sendMessage(userInput)
            let aiMessage = ChatMessage(
                id: UUID(),
                content: aiResponse,
                isUser: false,
                timestamp: Date()
            )
            messages.append(aiMessage)
        } catch {
            let errorMessage = ChatMessage(
                id: UUID(),
                content: "申し訳ありません。エラーが発生しました: \(error.localizedDescription)",
                isUser: false,
                timestamp: Date()
            )
            messages.append(errorMessage)
        }
        
        isLoading = false
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
}
