import Foundation
import SwiftUI
import Combine

@MainActor
class AgentManager: ObservableObject {
    @Published var agents: [Agent] = []
    @Published var activeAgents: [Agent] = []
    @Published var isProcessing: Bool = false
    @Published var selectedAgent: Agent?
    
    private let queue = DispatchQueue(label: "com.wisbee.agent", qos: .userInitiated)
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadBuiltInAgents()
    }
    
    private func loadBuiltInAgents() {
        agents = [
            Agent.queenBee,
            Agent.workerBee,
            Agent.scoutBee
        ]
    }
    
    func createCustomAgent(name: String, type: AgentType, description: String, personality: AgentPersonality) -> Agent {
        let agent = Agent(
            name: name,
            type: type,
            description: description,
            personality: personality
        )
        agents.append(agent)
        return agent
    }
    
    func activateAgent(_ agent: Agent) {
        guard !activeAgents.contains(where: { $0.id == agent.id }) else { return }
        
        var updatedAgent = agent
        updatedAgent.status = .idle
        updatedAgent.lastActiveAt = Date()
        
        activeAgents.append(updatedAgent)
        updateAgent(updatedAgent)
    }
    
    func deactivateAgent(_ agent: Agent) {
        activeAgents.removeAll { $0.id == agent.id }
        
        var updatedAgent = agent
        updatedAgent.status = .idle
        updateAgent(updatedAgent)
    }
    
    func updateAgentStatus(_ agentId: UUID, status: AgentStatus) {
        if let index = agents.firstIndex(where: { $0.id == agentId }) {
            agents[index].status = status
        }
        if let index = activeAgents.firstIndex(where: { $0.id == agentId }) {
            activeAgents[index].status = status
        }
    }
    
    func processTask(task: String, with agents: [Agent]) async throws -> TaskResult {
        isProcessing = true
        defer { isProcessing = false }
        
        // Update all agents to thinking status
        for agent in agents {
            updateAgentStatus(agent.id, status: .thinking)
        }
        
        // Simulate task processing
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Create task decomposition
        let subtasks = decomposeTask(task)
        
        // Assign subtasks to agents
        let assignments = assignSubtasks(subtasks, to: agents)
        
        // Process subtasks
        var results: [SubtaskResult] = []
        for assignment in assignments {
            updateAgentStatus(assignment.agent.id, status: .processing)
            let result = try await processSubtask(assignment.subtask, with: assignment.agent)
            results.append(result)
            updateAgentStatus(assignment.agent.id, status: .idle)
        }
        
        return TaskResult(
            task: task,
            subtasks: subtasks,
            results: results,
            summary: generateSummary(results)
        )
    }
    
    private func decomposeTask(_ task: String) -> [Subtask] {
        // Simplified task decomposition
        return [
            Subtask(id: UUID(), description: "Research and analyze requirements", type: .research),
            Subtask(id: UUID(), description: "Design solution architecture", type: .design),
            Subtask(id: UUID(), description: "Implement core functionality", type: .implementation),
            Subtask(id: UUID(), description: "Test and validate", type: .testing)
        ]
    }
    
    private func assignSubtasks(_ subtasks: [Subtask], to agents: [Agent]) -> [(subtask: Subtask, agent: Agent)] {
        var assignments: [(subtask: Subtask, agent: Agent)] = []
        
        for subtask in subtasks {
            // Find best agent for subtask
            let agent = findBestAgent(for: subtask, from: agents) ?? agents.first!
            assignments.append((subtask, agent))
        }
        
        return assignments
    }
    
    private func findBestAgent(for subtask: Subtask, from agents: [Agent]) -> Agent? {
        switch subtask.type {
        case .research:
            return agents.first { $0.type == .scoutBee }
        case .design, .implementation:
            return agents.first { $0.type == .workerBee }
        case .testing:
            return agents.first { $0.type == .workerBee }
        case .coordination:
            return agents.first { $0.type == .queenBee }
        }
    }
    
    private func processSubtask(_ subtask: Subtask, with agent: Agent) async throws -> SubtaskResult {
        // Simulate processing
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return SubtaskResult(
            subtask: subtask,
            agent: agent,
            output: "Completed: \(subtask.description)",
            confidence: Double.random(in: 0.8...0.95),
            duration: Double.random(in: 1...5)
        )
    }
    
    private func generateSummary(_ results: [SubtaskResult]) -> String {
        let totalDuration = results.reduce(0) { $0 + $1.duration }
        let avgConfidence = results.reduce(0) { $0 + $1.confidence } / Double(results.count)
        
        return "Task completed successfully by \(results.count) agents in \(String(format: "%.1f", totalDuration)) seconds with \(String(format: "%.0f%%", avgConfidence * 100)) confidence."
    }
    
    private func updateAgent(_ agent: Agent) {
        if let index = agents.firstIndex(where: { $0.id == agent.id }) {
            agents[index] = agent
        }
    }
}

struct Subtask: Identifiable {
    let id: UUID
    let description: String
    let type: SubtaskType
}

enum SubtaskType {
    case research
    case design
    case implementation
    case testing
    case coordination
}

struct TaskResult {
    let task: String
    let subtasks: [Subtask]
    let results: [SubtaskResult]
    let summary: String
}

struct SubtaskResult {
    let subtask: Subtask
    let agent: Agent
    let output: String
    let confidence: Double
    let duration: TimeInterval
}