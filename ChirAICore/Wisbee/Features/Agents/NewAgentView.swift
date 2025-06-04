import SwiftUI

struct NewAgentView: View {
    @EnvironmentObject var agentManager: AgentManager
    @Environment(\.dismiss) var dismiss
    
    @State private var agentName = ""
    @State private var agentDescription = ""
    @State private var selectedType: AgentType = .custom
    @State private var selectedTone = "professional"
    @State private var selectedTraits: Set<String> = []
    @State private var selectedCapabilities: Set<String> = []
    @State private var creativity: Double = 0.7
    @State private var helpfulness: Double = 0.9
    
    private let availableTraits = [
        "analytical", "creative", "methodical", "friendly",
        "precise", "patient", "enthusiastic", "thorough",
        "innovative", "collaborative", "decisive", "adaptable"
    ]
    
    private let availableCapabilities = [
        "code_generation", "content_creation", "data_analysis",
        "research", "translation", "summarization",
        "problem_solving", "debugging", "planning",
        "documentation", "testing", "optimization"
    ]
    
    private let tones = [
        "professional", "casual", "formal", "friendly",
        "technical", "educational", "conversational"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Agent Name", text: $agentName)
                    TextField("Description", text: $agentDescription, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section("Personality") {
                    Picker("Tone", selection: $selectedTone) {
                        ForEach(tones, id: \.self) { tone in
                            Text(tone.capitalized).tag(tone)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Creativity")
                            .font(.subheadline)
                        HStack {
                            Text("Conservative")
                                .font(.caption)
                                .foregroundColor(.honeycomb.textSecondary)
                            Slider(value: $creativity, in: 0...1)
                                .tint(.honeycomb.primary)
                            Text("Creative")
                                .font(.caption)
                                .foregroundColor(.honeycomb.textSecondary)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Helpfulness")
                            .font(.subheadline)
                        HStack {
                            Text("Minimal")
                                .font(.caption)
                                .foregroundColor(.honeycomb.textSecondary)
                            Slider(value: $helpfulness, in: 0...1)
                                .tint(.honeycomb.primary)
                            Text("Maximum")
                                .font(.caption)
                                .foregroundColor(.honeycomb.textSecondary)
                        }
                    }
                }
                
                Section("Traits") {
                    FlowLayout(spacing: 8) {
                        ForEach(availableTraits, id: \.self) { trait in
                            SelectableChip(
                                text: trait,
                                isSelected: selectedTraits.contains(trait),
                                action: {
                                    if selectedTraits.contains(trait) {
                                        selectedTraits.remove(trait)
                                    } else {
                                        selectedTraits.insert(trait)
                                    }
                                }
                            )
                        }
                    }
                }
                
                Section("Capabilities") {
                    FlowLayout(spacing: 8) {
                        ForEach(availableCapabilities, id: \.self) { capability in
                            SelectableChip(
                                text: capability.replacingOccurrences(of: "_", with: " "),
                                isSelected: selectedCapabilities.contains(capability),
                                action: {
                                    if selectedCapabilities.contains(capability) {
                                        selectedCapabilities.remove(capability)
                                    } else {
                                        selectedCapabilities.insert(capability)
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("New Agent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createAgent()
                    }
                    .disabled(agentName.isEmpty || agentDescription.isEmpty)
                }
            }
        }
    }
    
    private func createAgent() {
        let personality = AgentPersonality(
            tone: selectedTone,
            traits: Array(selectedTraits),
            expertise: [],
            responseStyle: "adaptive",
            creativity: creativity,
            helpfulness: helpfulness
        )
        
        let agent = agentManager.createCustomAgent(
            name: agentName,
            type: .custom,
            description: agentDescription,
            personality: personality
        )
        
        dismiss()
    }
}

struct SelectableChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text.capitalized)
                .font(.caption)
                .foregroundColor(isSelected ? .white : .honeycomb.text)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.honeycomb.primary : Color.honeycomb.surface)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.honeycomb.accent.opacity(0.2), lineWidth: 1)
                )
        }
    }
}