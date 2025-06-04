import Foundation
import SwiftUI

enum MessageType: String, Codable {
    case text
    case code
    case image
    case file
    case thought
    case system
}

enum MessageSender: Codable, Hashable {
    case user(userId: String)
    case agent(agentId: UUID)
    case system
    
    var isUser: Bool {
        if case .user = self { return true }
        return false
    }
    
    var isAgent: Bool {
        if case .agent = self { return true }
        return false
    }
}

struct Message: Identifiable, Codable, Hashable {
    let id: UUID
    let sender: MessageSender
    let content: String
    let type: MessageType
    let timestamp: Date
    let channelId: UUID
    var attachments: [Attachment]
    var reactions: [Reaction]
    var metadata: MessageMetadata?
    var isEdited: Bool
    var editedAt: Date?
    
    init(id: UUID = UUID(),
         sender: MessageSender,
         content: String,
         type: MessageType = .text,
         channelId: UUID,
         attachments: [Attachment] = [],
         reactions: [Reaction] = [],
         metadata: MessageMetadata? = nil,
         timestamp: Date = Date()) {
        self.id = id
        self.sender = sender
        self.content = content
        self.type = type
        self.channelId = channelId
        self.attachments = attachments
        self.reactions = reactions
        self.metadata = metadata
        self.timestamp = timestamp
        self.isEdited = false
        self.editedAt = nil
    }
}

struct Attachment: Codable, Hashable {
    let id: UUID
    let fileName: String
    let fileType: String
    let fileSize: Int64
    let url: URL?
    let thumbnailUrl: URL?
    
    init(id: UUID = UUID(),
         fileName: String,
         fileType: String,
         fileSize: Int64,
         url: URL? = nil,
         thumbnailUrl: URL? = nil) {
        self.id = id
        self.fileName = fileName
        self.fileType = fileType
        self.fileSize = fileSize
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}

struct Reaction: Codable, Hashable {
    let id: UUID
    let emoji: String
    let userId: String
    let timestamp: Date
    
    init(id: UUID = UUID(),
         emoji: String,
         userId: String,
         timestamp: Date = Date()) {
        self.id = id
        self.emoji = emoji
        self.userId = userId
        self.timestamp = timestamp
    }
}

struct MessageMetadata: Codable, Hashable {
    var tokenCount: Int?
    var processingTime: TimeInterval?
    var modelUsed: String?
    var confidence: Double?
    var codeLanguage: String?
    var thoughtProcess: String?
}