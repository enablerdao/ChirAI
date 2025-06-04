import Foundation
import Combine

// MARK: - Models
struct OllamaMessage: Codable {
    let role: String
    let content: String
}

struct OllamaChatRequest: Codable {
    let model: String
    let messages: [OllamaMessage]
    let stream: Bool = false
}

struct OllamaChatResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let system_fingerprint: String
    let choices: [Choice]
    let usage: Usage
    
    struct Choice: Codable {
        let index: Int
        let message: OllamaMessage
        let finish_reason: String
    }
    
    struct Usage: Codable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
}

// MARK: - Service
class OllamaService: ObservableObject {
    static let shared = OllamaService()
    
    private var baseURL: String {
        return "\(AppConfig.shared.ollamaBaseURL)/v1"
    }
    private let session = URLSession.shared
    
    @Published var isLoading = false
    @Published var error: Error?
    
    private init() {}
    
    func sendMessage(_ message: String, model: String = "gemma3:1b") async throws -> String {
        let endpoint = URL(string: "\(baseURL)/chat/completions")!
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let chatRequest = OllamaChatRequest(
            model: model,
            messages: [
                OllamaMessage(role: "user", content: message)
            ]
        )
        
        request.httpBody = try JSONEncoder().encode(chatRequest)
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw OllamaError.invalidResponse
            }
            
            let chatResponse = try JSONDecoder().decode(OllamaChatResponse.self, from: data)
            
            guard let firstChoice = chatResponse.choices.first else {
                throw OllamaError.noResponse
            }
            
            return firstChoice.message.content
        } catch {
            self.error = error
            throw error
        }
    }
    
    func sendChatHistory(_ messages: [OllamaMessage], model: String = "gemma3:1b") async throws -> String {
        let endpoint = URL(string: "\(baseURL)/chat/completions")!
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let chatRequest = OllamaChatRequest(
            model: model,
            messages: messages
        )
        
        request.httpBody = try JSONEncoder().encode(chatRequest)
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw OllamaError.invalidResponse
            }
            
            let chatResponse = try JSONDecoder().decode(OllamaChatResponse.self, from: data)
            
            guard let firstChoice = chatResponse.choices.first else {
                throw OllamaError.noResponse
            }
            
            return firstChoice.message.content
        } catch {
            self.error = error
            throw error
        }
    }
}

// MARK: - Errors
enum OllamaError: LocalizedError {
    case invalidResponse
    case noResponse
    case connectionFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from Ollama service"
        case .noResponse:
            return "No response received from the model"
        case .connectionFailed:
            return "Failed to connect to Ollama service"
        }
    }
}