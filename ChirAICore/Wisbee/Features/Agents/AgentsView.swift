import SwiftUI

struct AgentsView: View {
    @EnvironmentObject var agentManager: AgentManager
    @State private var selectedCategory: AgentCategory = .all
    @State private var showNewAgentSheet = false
    @State private var selectedAgent: Agent?
    
    private var filteredAgents: [Agent] {
        switch selectedCategory {
        case .all:
            return agentManager.agents
        case .active:
            return agentManager.activeAgents
        case .custom:
            return agentManager.agents.filter { $0.type == .custom }
        case .builtin:
            return agentManager.agents.filter { $0.type != .custom }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category picker
                categoryPicker
                
                // Agents grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(filteredAgents) { agent in
                            AgentCard(
                                agent: agent,
                                isActive: agentManager.activeAgents.contains { $0.id == agent.id },
                                onTap: {
                                    selectedAgent = agent
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Agents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showNewAgentSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewAgentSheet) {
                NewAgentView()
            }
            .sheet(item: $selectedAgent) { agent in
                AgentDetailView(agent: agent)
            }
        }
    }
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(AgentCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.displayName,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.honeycomb.surface)
    }
}

enum AgentCategory: CaseIterable {
    case all
    case active
    case builtin
    case custom
    
    var displayName: String {
        switch self {
        case .all: return "All Agents"
        case .active: return "Active"
        case .builtin: return "Built-in"
        case .custom: return "Custom"
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(isSelected ? .white : .honeycomb.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.honeycomb.primary : Color.honeycomb.background)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.honeycomb.accent.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct AgentDetailView: View {
    let agent: Agent
    @EnvironmentObject var agentManager: AgentManager
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Agent header
                    VStack(spacing: 16) {
                        HexagonView(
                            size: 120,
                            color: agent.type.color,
                            icon: agent.type.icon
                        )
                        
                        VStack(spacing: 8) {
                            Text(agent.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text(agent.type.displayName)
                                .font(.headline)
                                .foregroundColor(.honeycomb.textSecondary)
                            
                            Text(agent.description)
                                .font(.body)
                                .foregroundColor(.honeycomb.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    
                    // Status
                    HStack {
                        Label("Status", systemImage: "circle.fill")
                            .foregroundColor(statusColor)
                        Spacer()
                        Text(agent.status.rawValue.capitalized)
                            .foregroundColor(.honeycomb.textSecondary)
                    }
                    .padding(.horizontal)
                    
                    // Personality traits
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Personality")
                            .font(.headline)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(agent.personality.traits, id: \.self) { trait in
                                TraitChip(text: trait)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Capabilities
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Capabilities")
                            .font(.headline)
                        
                        ForEach(agent.capabilities, id: \.self) { capability in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.honeycomb.success)
                                Text(capability.replacingOccurrences(of: "_", with: " ").capitalized)
                                    .font(.body)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Actions
                    VStack(spacing: 12) {
                        if agentManager.activeAgents.contains(where: { $0.id == agent.id }) {
                            Button(action: { agentManager.deactivateAgent(agent) }) {
                                Label("Deactivate", systemImage: "pause.circle")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        } else {
                            Button(action: { agentManager.activateAgent(agent) }) {
                                Label("Activate", systemImage: "play.circle")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        
                        if agent.type == .custom {
                            Button(action: { isEditing = true }) {
                                Label("Edit Agent", systemImage: "pencil")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Agent Details")
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
    
    private var statusColor: Color {
        switch agent.status {
        case .idle: return .gray
        case .thinking: return .orange
        case .typing: return .blue
        case .processing: return .green
        case .error: return .red
        }
    }
}

struct TraitChip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.honeycomb.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.honeycomb.primary.opacity(0.1))
            )
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.width ?? 0,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: result.positions[index].x + bounds.minX,
                                     y: result.positions[index].y + bounds.minY),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var maxHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth, x > 0 {
                    x = 0
                    y += maxHeight + spacing
                    maxHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                maxHeight = max(maxHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + maxHeight)
        }
    }
}