import Foundation
import SwiftUI
import Combine

@MainActor
class ChatManager: ObservableObject {
    @Published var channels: [Channel] = []
    @Published var messages: [UUID: [Message]] = [:]
    @Published var currentChannel: Channel?
    @Published var typingUsers: [UUID: Set<String>] = [:]
    @Published var isConnected: Bool = false
    
    private let messageQueue = DispatchQueue(label: "com.wisbee.messages", qos: .userInitiated)
    private var cancellables = Set<AnyCancellable>()
    private let maxMessagesPerChannel = 1000
    
    init() {
        setupDefaultChannels()
    }
    
    private func setupDefaultChannels() {
        let generalChannel = Channel(
            name: "general",
            description: "General discussion",
            type: .publicChannel,
            participants: []
        )
        
        let aiResearchChannel = Channel(
            name: "ai-research",
            description: "AI research and experiments",
            type: .publicChannel,
            participants: []
        )
        
        channels = [generalChannel, aiResearchChannel]
        
        // Initialize empty message arrays
        messages[generalChannel.id] = []
        messages[aiResearchChannel.id] = []
    }
    
    func sendMessage(content: String, type: MessageType = .text, in channel: Channel, from sender: MessageSender) {
        let message = Message(
            sender: sender,
            content: content,
            type: type,
            channelId: channel.id
        )
        
        messageQueue.async { [weak self] in
            DispatchQueue.main.async {
                self?.addMessage(message, to: channel)
            }
        }
        
        // Trigger agent responses if needed
        if case .user = sender {
            Task {
                await processAgentResponses(for: message, in: channel)
            }
        }
    }
    
    private func addMessage(_ message: Message, to channel: Channel) {
        if messages[channel.id] == nil {
            messages[channel.id] = []
        }
        
        messages[channel.id]?.append(message)
        
        // Limit message history
        if let count = messages[channel.id]?.count, count > maxMessagesPerChannel {
            messages[channel.id]?.removeFirst(count - maxMessagesPerChannel)
        }
        
        // Update channel's last message time
        if let index = channels.firstIndex(where: { $0.id == channel.id }) {
            channels[index].lastMessageAt = message.timestamp
        }
    }
    
    private func processAgentResponses(for message: Message, in channel: Channel) async {
        // Check if any agents should respond
        let activeAgents = channel.participants.filter { $0.type == .agent }
        
        for participant in activeAgents {
            if shouldAgentRespond(agentId: participant.id, to: message) {
                await generateAgentResponse(agentId: participant.id, to: message, in: channel)
            }
        }
    }
    
    private func shouldAgentRespond(agentId: String, to message: Message) -> Bool {
        // Simple logic: agents respond to questions or mentions
        let content = message.content.lowercased()
        return content.contains("?") || content.contains("@\(agentId)")
    }
    
    private func generateAgentResponse(agentId: String, to message: Message, in channel: Channel) async {
        // Show typing indicator
        setTypingStatus(for: agentId, in: channel.id, isTyping: true)
        
        // Simulate thinking time
        try? await Task.sleep(nanoseconds: UInt64.random(in: 1_000_000_000...3_000_000_000))
        
        // Generate response
        let response = generateResponse(for: message.content)
        
        // Remove typing indicator
        setTypingStatus(for: agentId, in: channel.id, isTyping: false)
        
        // Send response
        if let agentUUID = UUID(uuidString: agentId) {
            sendMessage(
                content: response,
                type: .text,
                in: channel,
                from: .agent(agentId: agentUUID)
            )
        }
    }
    
    private func generateResponse(for input: String) -> String {
        // Simplified response generation
        let responses = [
            "I understand your question. Let me analyze this for you.",
            "That's an interesting point. Here's my perspective:",
            "Based on my analysis, I would suggest the following approach:",
            "I've processed your request. Here are my findings:",
            "Let me help you with that. I'll break it down step by step."
        ]
        return responses.randomElement() ?? "I'm processing your request."
    }
    
    func setTypingStatus(for userId: String, in channelId: UUID, isTyping: Bool) {
        if typingUsers[channelId] == nil {
            typingUsers[channelId] = Set<String>()
        }
        
        if isTyping {
            typingUsers[channelId]?.insert(userId)
        } else {
            typingUsers[channelId]?.remove(userId)
        }
    }
    
    func createChannel(name: String, type: ChannelType, description: String? = nil) -> Channel {
        let channel = Channel(
            name: name,
            description: description,
            type: type,
            participants: []
        )
        
        channels.append(channel)
        messages[channel.id] = []
        
        return channel
    }
    
    func deleteChannel(_ channel: Channel) {
        channels.removeAll { $0.id == channel.id }
        messages[channel.id] = nil
        typingUsers[channel.id] = nil
        
        if currentChannel?.id == channel.id {
            currentChannel = nil
        }
    }
    
    func joinChannel(_ channel: Channel, participant: Participant) {
        if let index = channels.firstIndex(where: { $0.id == channel.id }) {
            if !channels[index].participants.contains(where: { $0.id == participant.id }) {
                channels[index].participants.append(participant)
            }
        }
    }
    
    func leaveChannel(_ channel: Channel, participantId: String) {
        if let index = channels.firstIndex(where: { $0.id == channel.id }) {
            channels[index].participants.removeAll { $0.id == participantId }
        }
    }
    
    func markChannelAsRead(_ channel: Channel) {
        if let index = channels.firstIndex(where: { $0.id == channel.id }) {
            channels[index].unreadCount = 0
        }
    }
    
    func searchMessages(query: String) -> [Message] {
        let lowercaseQuery = query.lowercased()
        var results: [Message] = []
        
        for (_, channelMessages) in messages {
            let matches = channelMessages.filter { message in
                message.content.lowercased().contains(lowercaseQuery)
            }
            results.append(contentsOf: matches)
        }
        
        return results.sorted { $0.timestamp > $1.timestamp }
    }
}