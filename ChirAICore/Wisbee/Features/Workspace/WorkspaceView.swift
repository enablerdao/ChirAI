import SwiftUI

struct WorkspaceView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var agentManager: AgentManager
    @EnvironmentObject var chatManager: ChatManager
    @State private var showTaskComposer = false
    @State private var currentTask: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Workspace overview
                    workspaceOverview
                    
                    // Active agents section
                    activeAgentsSection
                    
                    // Recent activity
                    recentActivitySection
                    
                    // Quick actions
                    quickActionsSection
                }
                .padding()
            }
            .navigationTitle(appState.activeWorkspace?.name ?? "Workspace")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showTaskComposer = true }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showTaskComposer) {
                TaskComposerView()
            }
        }
    }
    
    private var workspaceOverview: some View {
        VStack(spacing: 16) {
            // Honeycomb visualization
            HexagonGrid(items: 7, columns: 3, hexSize: 50)
                .frame(height: 150)
            
            // Stats
            HStack(spacing: 32) {
                StatItem(value: "\(agentManager.activeAgents.count)", label: "Active Agents")
                StatItem(value: "\(chatManager.channels.count)", label: "Channels")
                StatItem(value: "0", label: "Tasks Today")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: HoneycombStyle.cornerRadius)
                .fill(Color.honeycomb.surface)
        )
    }
    
    private var activeAgentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Agents")
                .font(.headline)
            
            if agentManager.activeAgents.isEmpty {
                Text("No active agents. Activate agents to start collaborating.")
                    .font(.subheadline)
                    .foregroundColor(.honeycomb.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 32)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(agentManager.activeAgents) { agent in
                            ActiveAgentCard(agent: agent)
                        }
                    }
                }
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(0..<3) { index in
                    ActivityRow(
                        icon: "message",
                        title: "New message in #general",
                        time: Date().addingTimeInterval(-Double(index * 3600))
                    )
                }
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickActionButton(
                    icon: "plus.message",
                    title: "New Chat",
                    color: .honeycomb.primary,
                    action: createNewChat
                )
                
                QuickActionButton(
                    icon: "cpu",
                    title: "Add Agent",
                    color: .honeycomb.secondary,
                    action: addAgent
                )
                
                QuickActionButton(
                    icon: "doc.text",
                    title: "New Task",
                    color: .honeycomb.accent,
                    action: { showTaskComposer = true }
                )
                
                QuickActionButton(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Analytics",
                    color: .honeycomb.info,
                    action: showAnalytics
                )
            }
        }
    }
    
    private func createNewChat() {
        // Navigate to new chat creation
    }
    
    private func addAgent() {
        // Navigate to agent picker
    }
    
    private func showAnalytics() {
        // Show analytics view
    }
}

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.honeycomb.primary)
            Text(label)
                .font(.caption)
                .foregroundColor(.honeycomb.textSecondary)
        }
    }
}

struct ActiveAgentCard: View {
    let agent: Agent
    
    var body: some View {
        VStack(spacing: 8) {
            HexagonView(size: 60, color: agent.type.color, icon: agent.type.icon)
            
            Text(agent.name)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(agent.status.rawValue)
                .font(.caption2)
                .foregroundColor(.honeycomb.textSecondary)
        }
        .padding()
        .frame(width: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.honeycomb.background)
        )
    }
}

struct ActivityRow: View {
    let icon: String
    let title: String
    let time: Date
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.honeycomb.secondary)
                .frame(width: 32)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.honeycomb.text)
            
            Spacer()
            
            Text(time.formatted(date: .omitted, time: .shortened))
                .font(.caption)
                .foregroundColor(.honeycomb.textSecondary)
        }
        .padding(.vertical, 8)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.honeycomb.text)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct TaskComposerView: View {
    @EnvironmentObject var agentManager: AgentManager
    @Environment(\.dismiss) var dismiss
    
    @State private var taskDescription = ""
    @State private var selectedAgents: Set<UUID> = []
    @State private var priority: TaskPriority = .medium
    @State private var isProcessing = false
    
    enum TaskPriority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case urgent = "Urgent"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Task Description") {
                    TextEditor(text: $taskDescription)
                        .frame(minHeight: 100)
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("Assign Agents") {
                    ForEach(agentManager.agents) { agent in
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
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start") {
                        startTask()
                    }
                    .disabled(taskDescription.isEmpty || selectedAgents.isEmpty || isProcessing)
                }
            }
            .overlay {
                if isProcessing {
                    ProcessingOverlay()
                }
            }
        }
    }
    
    private func startTask() {
        isProcessing = true
        
        Task {
            let agents = agentManager.agents.filter { selectedAgents.contains($0.id) }
            do {
                let result = try await agentManager.processTask(task: taskDescription, with: agents)
                // Handle task result
                dismiss()
            } catch {
                // Handle error
                isProcessing = false
            }
        }
    }
}

struct ProcessingOverlay: View {
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HexagonView(size: 80, color: .honeycomb.primary, isAnimating: true)
                
                Text("Processing Task...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Agents are collaborating")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.honeycomb.surface)
            )
        }
    }
}