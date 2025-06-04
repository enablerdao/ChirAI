import SwiftUI

struct AgentCard: View {
    let agent: Agent
    let isActive: Bool
    let onTap: () -> Void
    
    @State private var isHovered = false
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Agent hexagon avatar
            ZStack {
                HexagonView(
                    size: 80,
                    color: agent.type.color,
                    icon: agent.type.icon,
                    isAnimating: agent.status == .processing
                )
                
                // Status indicator
                Circle()
                    .fill(statusColor)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .offset(x: 30, y: -25)
                    .scaleEffect(pulseAnimation ? 1.2 : 1.0)
            }
            
            VStack(spacing: 4) {
                Text(agent.name)
                    .font(.headline)
                    .foregroundColor(.honeycomb.text)
                
                Text(agent.type.displayName)
                    .font(.caption)
                    .foregroundColor(.honeycomb.textSecondary)
                
                Text(agent.description)
                    .font(.caption2)
                    .foregroundColor(.honeycomb.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            // Capabilities
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(agent.capabilities.prefix(3), id: \.self) { capability in
                        CapabilityChip(text: capability)
                    }
                    if agent.capabilities.count > 3 {
                        CapabilityChip(text: "+\(agent.capabilities.count - 3)")
                    }
                }
            }
            
            // Action button
            Button(action: onTap) {
                Text(isActive ? "Active" : "Activate")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isActive ? .honeycomb.primary : .white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(isActive ? Color.honeycomb.primary.opacity(0.2) : Color.honeycomb.primary)
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.honeycomb.primary, lineWidth: isActive ? 1 : 0)
                    )
            }
        }
        .padding()
        .frame(width: 180, height: 260)
        .background(
            RoundedRectangle(cornerRadius: HoneycombStyle.cornerRadius)
                .fill(Color.honeycomb.surface)
                .shadow(
                    color: Color.black.opacity(isHovered ? 0.15 : 0.08),
                    radius: isHovered ? 12 : 6,
                    y: isHovered ? 6 : 3
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: HoneycombStyle.cornerRadius)
                .stroke(agent.type.color.opacity(isActive ? 0.5 : 0), lineWidth: 2)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .onHover { hovering in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isHovered = hovering
            }
        }
        .onAppear {
            if agent.status != .idle {
                startPulseAnimation()
            }
        }
    }
    
    private var statusColor: Color {
        switch agent.status {
        case .idle:
            return .gray
        case .thinking:
            return .orange
        case .typing:
            return .blue
        case .processing:
            return .green
        case .error:
            return .red
        }
    }
    
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
    }
}

struct CapabilityChip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundColor(.honeycomb.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.honeycomb.secondary.opacity(0.1))
            )
    }
}