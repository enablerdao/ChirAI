import Foundation
import SwiftUI

enum ChannelType: String, Codable {
    case publicChannel = "public"
    case privateChannel = "private"
    case directMessage = "direct"
    case agentConversation = "agent"
}

struct Channel: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    var type: ChannelType
    var participants: [Participant]
    var createdAt: Date
    var lastMessageAt: Date?
    var unreadCount: Int
    var isPinned: Bool
    var settings: ChannelSettings
    
    init(id: UUID = UUID(),
         name: String,
         description: String? = nil,
         type: ChannelType,
         participants: [Participant] = [],
         createdAt: Date = Date(),
         lastMessageAt: Date? = nil,
         unreadCount: Int = 0,
         isPinned: Bool = false,
         settings: ChannelSettings = ChannelSettings()) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.participants = participants
        self.createdAt = createdAt
        self.lastMessageAt = lastMessageAt
        self.unreadCount = unreadCount
        self.isPinned = isPinned
        self.settings = settings
    }
}

struct Participant: Codable, Hashable {
    enum ParticipantType: String, Codable {
        case human
        case agent
    }
    
    let id: String
    let type: ParticipantType
    var role: String
    var permissions: Set<String>
    var joinedAt: Date
    var isTyping: Bool
    var lastSeenAt: Date?
    
    init(id: String,
         type: ParticipantType,
         role: String = "member",
         permissions: Set<String> = [],
         joinedAt: Date = Date(),
         isTyping: Bool = false,
         lastSeenAt: Date? = nil) {
        self.id = id
        self.type = type
        self.role = role
        self.permissions = permissions
        self.joinedAt = joinedAt
        self.isTyping = isTyping
        self.lastSeenAt = lastSeenAt
    }
}

struct ChannelSettings: Codable, Hashable {
    var allowedMessageTypes: Set<MessageType> = Set(MessageType.allCases)
    var maxParticipants: Int = 100
    var isArchived: Bool = false
    var notificationLevel: NotificationLevel = .all
    var autoTranslate: Bool = false
    var encryptionEnabled: Bool = true
}

enum NotificationLevel: String, Codable, CaseIterable {
    case all
    case mentions
    case none
}

extension MessageType: CaseIterable {
    static var allCases: [MessageType] {
        return [.text, .code, .image, .file, .thought, .system]
    }
}