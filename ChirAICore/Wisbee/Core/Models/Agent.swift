import Foundation
import SwiftUI

enum AgentType: String, CaseIterable, Codable {
    case queenBee = "queen_bee"
    case workerBee = "worker_bee"
    case scoutBee = "scout_bee"
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .queenBee: return "Queen Bee"
        case .workerBee: return "Worker Bee"
        case .scoutBee: return "Scout Bee"
        case .custom: return "Custom Agent"
        }
    }
    
    var icon: String {
        switch self {
        case .queenBee: return "crown"
        case .workerBee: return "hammer"
        case .scoutBee: return "magnifyingglass"
        case .custom: return "star"
        }
    }
    
    var color: Color {
        switch self {
        case .queenBee: return .honeycomb.royal
        case .workerBee: return .honeycomb.worker
        case .scoutBee: return .honeycomb.scout
        case .custom: return .honeycomb.custom
        }
    }
}

enum AgentStatus: String, Codable {
    case idle
    case thinking
    case typing
    case processing
    case error
}

struct Agent: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var type: AgentType
    var description: String
    var avatar: String?
    var personality: AgentPersonality
    var capabilities: [String]
    var knowledgeBase: [String]
    var status: AgentStatus
    var modelId: String?
    var createdAt: Date
    var lastActiveAt: Date
    
    init(id: UUID = UUID(),
         name: String,
         type: AgentType,
         description: String,
         avatar: String? = nil,
         personality: AgentPersonality = AgentPersonality(),
         capabilities: [String] = [],
         knowledgeBase: [String] = [],
         status: AgentStatus = .idle,
         modelId: String? = nil,
         createdAt: Date = Date(),
         lastActiveAt: Date = Date()) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.avatar = avatar
        self.personality = personality
        self.capabilities = capabilities
        self.knowledgeBase = knowledgeBase
        self.status = status
        self.modelId = modelId
        self.createdAt = createdAt
        self.lastActiveAt = lastActiveAt
    }
}

struct AgentPersonality: Codable, Hashable {
    var tone: String = "professional"
    var traits: [String] = []
    var expertise: [String] = []
    var responseStyle: String = "concise"
    var creativity: Double = 0.7
    var helpfulness: Double = 0.9
}

extension Agent {
    static let queenBee = Agent(
        name: "Queen",
        type: .queenBee,
        description: "Project coordinator and task distributor",
        personality: AgentPersonality(
            tone: "authoritative",
            traits: ["decisive", "strategic", "organized"],
            expertise: ["project management", "task allocation", "decision making"]
        ),
        capabilities: ["task_management", "coordination", "strategy"]
    )
    
    static let workerBee = Agent(
        name: "Worker",
        type: .workerBee,
        description: "Specialized task executor",
        personality: AgentPersonality(
            tone: "helpful",
            traits: ["diligent", "focused", "reliable"],
            expertise: ["coding", "writing", "analysis"]
        ),
        capabilities: ["code_generation", "content_creation", "data_analysis"]
    )
    
    static let scoutBee = Agent(
        name: "Scout",
        type: .scoutBee,
        description: "Information gatherer and researcher",
        personality: AgentPersonality(
            tone: "curious",
            traits: ["thorough", "analytical", "resourceful"],
            expertise: ["research", "data_collection", "trend_analysis"]
        ),
        capabilities: ["web_search", "data_gathering", "report_generation"]
    )
}