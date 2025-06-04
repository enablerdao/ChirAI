import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var chatManager: ChatManager
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var showNewChannelSheet = false
    
    private var filteredChannels: [Channel] {
        if searchText.isEmpty {
            return chatManager.channels
        } else {
            return chatManager.channels.filter { channel in
                channel.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Pinned channels
                    let pinnedChannels = filteredChannels.filter { $0.isPinned }
                    if !pinnedChannels.isEmpty {
                        Section {
                            ForEach(pinnedChannels) { channel in
                                ChannelRow(channel: channel)
                            }
                        } header: {
                            SectionHeader(title: "Pinned")
                        }
                    }
                    
                    // Recent channels
                    let recentChannels = filteredChannels.filter { !$0.isPinned }
                    if !recentChannels.isEmpty {
                        Section {
                            ForEach(recentChannels) { channel in
                                ChannelRow(channel: channel)
                            }
                        } header: {
                            SectionHeader(title: "Recent")
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search channels")
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showNewChannelSheet = true }) {
                        Image(systemName: "plus.bubble")
                    }
                }
            }
            .sheet(isPresented: $showNewChannelSheet) {
                NewChannelView()
            }
        }
    }
}

struct ChannelRow: View {
    let channel: Channel
    @EnvironmentObject var chatManager: ChatManager
    
    private var lastMessage: Message? {
        chatManager.messages[channel.id]?.last
    }
    
    var body: some View {
        NavigationLink(destination: ChatView(channel: channel)) {
            HStack(spacing: 12) {
                // Channel icon
                channelIcon
                
                // Channel info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(channel.name)
                            .font(.headline)
                            .foregroundColor(.honeycomb.text)
                        
                        Spacer()
                        
                        if let lastMessageAt = channel.lastMessageAt {
                            Text(formatDate(lastMessageAt))
                                .font(.caption)
                                .foregroundColor(.honeycomb.textSecondary)
                        }
                    }
                    
                    if let lastMessage = lastMessage {
                        Text(lastMessagePreview(lastMessage))
                            .font(.subheadline)
                            .foregroundColor(.honeycomb.textSecondary)
                            .lineLimit(1)
                    } else if let description = channel.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.honeycomb.textSecondary)
                            .lineLimit(1)
                    }
                }
                
                // Unread indicator
                if channel.unreadCount > 0 {
                    Text("\(channel.unreadCount)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.honeycomb.primary))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.honeycomb.background)
        }
    }
    
    @ViewBuilder
    private var channelIcon: some View {
        switch channel.type {
        case .publicChannel:
            HexagonView(size: 44, color: .honeycomb.primary, icon: "number")
        case .privateChannel:
            HexagonView(size: 44, color: .honeycomb.secondary, icon: "lock")
        case .directMessage:
            HexagonView(size: 44, color: .honeycomb.accent, icon: "person")
        case .agentConversation:
            HexagonView(size: 44, color: .honeycomb.royal, icon: "cpu")
        }
    }
    
    private func lastMessagePreview(_ message: Message) -> String {
        switch message.sender {
        case .user(let userId):
            let name = userId == UserDefaults.standard.user?.id ? "You" : "User"
            return "\(name): \(message.content)"
        case .agent:
            return "🤖 \(message.content)"
        case .system:
            return "System: \(message.content)"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return date.formatted(date: .omitted, time: .shortened)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.honeycomb.textSecondary)
                .textCase(.uppercase)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.honeycomb.surface)
    }
}

struct NewChannelView: View {
    @EnvironmentObject var chatManager: ChatManager
    @Environment(\.dismiss) var dismiss
    
    @State private var channelName = ""
    @State private var channelDescription = ""
    @State private var channelType: ChannelType = .publicChannel
    @State private var selectedAgents: Set<UUID> = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Channel Information") {
                    TextField("Channel Name", text: $channelName)
                    TextField("Description (optional)", text: $channelDescription, axis: .vertical)
                        .lineLimit(2...4)
                    
                    Picker("Channel Type", selection: $channelType) {
                        Label("Public", systemImage: "number").tag(ChannelType.publicChannel)
                        Label("Private", systemImage: "lock").tag(ChannelType.privateChannel)
                    }
                }
                
                Section("Initial Agents") {
                    ForEach(AgentManager().agents) { agent in
                        HStack {
                            HexagonView(size: 36, color: agent.type.color, icon: agent.type.icon)
                            
                            VStack(alignment: .leading) {
                                Text(agent.name)
                                    .font(.headline)
                                Text(agent.type.displayName)
                                    .font(.caption)
                                    .foregroundColor(.honeycomb.textSecondary)
                            }
                            
                            Spacer()
                            
                            if selectedAgents.contains(agent.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.honeycomb.primary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedAgents.contains(agent.id) {
                                selectedAgents.remove(agent.id)
                            } else {
                                selectedAgents.insert(agent.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Channel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createChannel()
                    }
                    .disabled(channelName.isEmpty)
                }
            }
        }
    }
    
    private func createChannel() {
        let channel = chatManager.createChannel(
            name: channelName,
            type: channelType,
            description: channelDescription.isEmpty ? nil : channelDescription
        )
        
        // Add selected agents
        for agentId in selectedAgents {
            let participant = Participant(
                id: agentId.uuidString,
                type: .agent
            )
            chatManager.joinChannel(channel, participant: participant)
        }
        
        dismiss()
    }
}