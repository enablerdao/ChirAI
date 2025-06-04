import SwiftUI

struct ModernMessageBubble: View {
    let message: ChatMessage
    @State private var isVisible = false
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
                userMessageView
            } else {
                aiMessageView
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }
        }
    }
    
    private var userMessageView: some View {
        VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
            HStack {
                Text(message.content)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .padding(DesignSystem.Spacing.md)
                    .background(DesignSystem.Colors.userMessage)
                    .cornerRadius(DesignSystem.CornerRadius.lg)
                    .modernShadow(DesignSystem.Shadows.small)
            }
            
            HStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(DesignSystem.Colors.accent)
                    .font(.caption)
                
                Text("You")
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
    }
    
    private var aiMessageView: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        aiIcon
                        
                        Text(message.model ?? "AI")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.accent)
                            .padding(.horizontal, DesignSystem.Spacing.sm)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(
                                Capsule()
                                    .fill(DesignSystem.Colors.accent.opacity(0.2))
                            )
                    }
                    
                    Text(message.content)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .textSelection(.enabled)
                }
                
                Spacer()
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.aiMessage)
            .cornerRadius(DesignSystem.CornerRadius.lg)
            .modernShadow(DesignSystem.Shadows.small)
        }
    }
    
    private var aiIcon: some View {
        ZStack {
            Circle()
                .fill(DesignSystem.Colors.primaryGradient)
                .frame(width: 24, height: 24)
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ModernMessageBubble(
            message: ChatMessage(
                content: "Hello! How can I help you today?",
                isUser: false,
                model: "gemma3:1b"
            )
        )
        
        ModernMessageBubble(
            message: ChatMessage(
                content: "I'd like to know about local LLM models.",
                isUser: true
            )
        )
    }
    .padding()
    .background(DesignSystem.Colors.backgroundPrimary)
    .preferredColorScheme(.dark)
}