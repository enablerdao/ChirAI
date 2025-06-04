import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText = ""
    @Published var isLoading = false
    @Published var selectedModel = AppConfig.shared.defaultModel
    
    private let ollamaService = OllamaService.shared
    private var cancellables = Set<AnyCancellable>()
    
    var availableModels: [String] {
        return AppConfig.shared.availableModels
    }
    
    init() {
        // Add welcome message
        messages.append(ChatMessage(
            content: "Hello! I'm powered by gemma3:1b running locally on your device. How can I help you today?",
            isUser: false,
            model: selectedModel
        ))
    }
    
    func sendMessage() async {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = inputText
        inputText = ""
        
        // Add user message
        messages.append(ChatMessage(content: userMessage, isUser: true))
        
        isLoading = true
        
        do {
            // Convert messages to Ollama format
            let ollamaMessages = messages.map { message in
                OllamaMessage(
                    role: message.isUser ? "user" : "assistant",
                    content: message.content
                )
            }
            
            // Send to Ollama
            let response = try await ollamaService.sendChatHistory(
                ollamaMessages,
                model: selectedModel
            )
            
            // Add AI response
            messages.append(ChatMessage(
                content: response,
                isUser: false,
                model: selectedModel
            ))
        } catch {
            // Add error message
            messages.append(ChatMessage(
                content: "Error: \(error.localizedDescription)",
                isUser: false,
                model: "error"
            ))
        }
        
        isLoading = false
    }
    
    func clearChat() {
        messages.removeAll()
        messages.append(ChatMessage(
            content: "Chat cleared. How can I help you?",
            isUser: false,
            model: selectedModel
        ))
    }
    
    func changeModel(to model: String) {
        selectedModel = model
        messages.append(ChatMessage(
            content: "Switched to \(model). Ready to chat!",
            isUser: false,
            model: model
        ))
    }
}