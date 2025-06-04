import Foundation

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    let model: String?
    
    init(content: String, isUser: Bool, model: String? = nil) {
        self.content = content
        self.isUser = isUser
        self.timestamp = Date()
        self.model = model
    }
}