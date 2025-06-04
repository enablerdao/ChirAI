import SwiftUI
import Combine

struct ChatView: View {
    let channel: Channel
    @EnvironmentObject var chatManager: ChatManager
    @EnvironmentObject var agentManager: AgentManager
    @EnvironmentObject var appState: AppState
    
    @State private var messageText = ""
    @State private var isTyping = false
    @State private var showAgentPicker = false
    @State private var scrollToBottom = false
    @FocusState private var isMessageFieldFocused: Bool
    
    private var messages: [Message] {
        chatManager.messages[channel.id] ?? []
    }
    
    private var typingAgents: [String] {
        Array(chatManager.typingUsers[channel.id] ?? [])
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            MessageBubble(
                                message: message,
                                agent: agentForMessage(message)
                            )
                            .id(message.id)
                        }
                        
                        if !typingAgents.isEmpty {
                            TypingIndicator(agents: typingAgents)
                        }
                    }
                    .padding(.vertical)
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        scrollProxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            Divider()
            
            // Message input
            messageInputView
        }
        .navigationTitle(channel.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                channelInfoButton
            }
        }
        .sheet(isPresented: $showAgentPicker) {
            AgentPickerView(channel: channel)
        }
        .onAppear {
            chatManager.markChannelAsRead(channel)
        }
    }
    
    private var messageInputView: some View {
        HStack(spacing: 12) {
            // Add agent button
            Button(action: { showAgentPicker = true }) {
                Image(systemName: "cpu")
                    .font(.system(size: 20))
                    .foregroundColor(.honeycomb.primary)
            }
            
            // Message field
            HStack {
                TextField("Type a message...", text: $messageText, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .lineLimit(1...5)
                    .focused($isMessageFieldFocused)
                    .onChange(of: messageText) { newValue in
                        updateTypingStatus(!newValue.isEmpty)
                    }
                    .onSubmit {
                        sendMessage()
                    }
                
                // Attachment button
                Button(action: addAttachment) {
                    Image(systemName: "paperclip")
                        .font(.system(size: 18))
                        .foregroundColor(.honeycomb.textSecondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.honeycomb.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.honeycomb.accent.opacity(0.2), lineWidth: 1)
                    )
            )
            
            // Send button
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(messageText.isEmpty ? .gray : .honeycomb.primary)
            }
            .disabled(messageText.isEmpty)
        }
        .padding()
        .background(Color.honeycomb.background)
    }
    
    private var channelInfoButton: some View {
        Button(action: showChannelInfo) {
            Image(systemName: "info.circle")
        }
    }
    
    private func agentForMessage(_ message: Message) -> Agent? {
        if case .agent(let agentId) = message.sender {
            return agentManager.agents.first { $0.id == agentId }
        }
        return nil
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let sender = MessageSender.user(userId: appState.currentUser?.id ?? "")
        chatManager.sendMessage(
            content: messageText,
            type: .text,
            in: channel,
            from: sender
        )
        
        messageText = ""
        updateTypingStatus(false)
    }
    
    private func updateTypingStatus(_ isTyping: Bool) {
        guard let userId = appState.currentUser?.id else { return }
        chatManager.setTypingStatus(for: userId, in: channel.id, isTyping: isTyping)
    }
    
    private func addAttachment() {
        // TODO: Implement attachment picker
    }
    
    private func showChannelInfo() {
        // TODO: Show channel info sheet
    }
}

struct TypingIndicator: View {
    let agents: [String]
    @State private var animationPhase = 0.0
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.honeycomb.textSecondary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animationScale(for: index))
                        .opacity(animationOpacity(for: index))
                }
            }
            
            Text(typingText)
                .font(.caption)
                .foregroundColor(.honeycomb.textSecondary)
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                animationPhase = 1.0
            }
        }
    }
    
    private var typingText: String {
        if agents.count == 1 {
            return "\(agents[0]) is typing..."
        } else if agents.count == 2 {
            return "\(agents[0]) and \(agents[1]) are typing..."
        } else {
            return "\(agents[0]) and \(agents.count - 1) others are typing..."
        }
    }
    
    private func animationScale(for index: Int) -> CGFloat {
        let phase = (animationPhase + Double(index) * 0.33).truncatingRemainder(dividingBy: 1.0)
        return 0.8 + 0.4 * sin(phase * .pi)
    }
    
    private func animationOpacity(for index: Int) -> Double {
        let phase = (animationPhase + Double(index) * 0.33).truncatingRemainder(dividingBy: 1.0)
        return 0.5 + 0.5 * sin(phase * .pi)
    }
}

struct AgentPickerView: View {
    let channel: Channel
    @EnvironmentObject var agentManager: AgentManager
    @EnvironmentObject var chatManager: ChatManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                    ForEach(agentManager.agents) { agent in
                        AgentCard(
                            agent: agent,
                            isActive: isAgentInChannel(agent),
                            onTap: { toggleAgent(agent) }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Add Agents")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func isAgentInChannel(_ agent: Agent) -> Bool {
        channel.participants.contains { $0.id == agent.id.uuidString && $0.type == .agent }
    }
    
    private func toggleAgent(_ agent: Agent) {
        if isAgentInChannel(agent) {
            chatManager.leaveChannel(channel, participantId: agent.id.uuidString)
        } else {
            let participant = Participant(
                id: agent.id.uuidString,
                type: .agent
            )
            chatManager.joinChannel(channel, participant: participant)
            agentManager.activateAgent(agent)
        }
    }
}