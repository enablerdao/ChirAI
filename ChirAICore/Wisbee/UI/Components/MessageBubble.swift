import SwiftUI

struct MessageBubble: View {
    let message: Message
    let agent: Agent?
    @State private var showFullContent = false
    
    private var isCurrentUser: Bool {
        if case .user(let userId) = message.sender,
           userId == UserDefaults.standard.user?.id {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if !isCurrentUser {
                avatarView
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isCurrentUser {
                    senderLabel
                }
                
                bubbleContent
                
                timestampLabel
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isCurrentUser ? .trailing : .leading)
            
            if isCurrentUser {
                avatarView
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var avatarView: some View {
        if isCurrentUser {
            Circle()
                .fill(Color.honeycomb.primary)
                .frame(width: 36, height: 36)
                .overlay(
                    Text(UserDefaults.standard.user?.name.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                )
        } else if let agent = agent {
            HexagonView(size: 36, color: agent.type.color, icon: agent.type.icon)
        } else {
            Circle()
                .fill(Color.honeycomb.secondary)
                .frame(width: 36, height: 36)
        }
    }
    
    private var senderLabel: some View {
        Group {
            if case .agent = message.sender, let agent = agent {
                Text(agent.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(agent.type.color)
            }
        }
    }
    
    @ViewBuilder
    private var bubbleContent: some View {
        switch message.type {
        case .text:
            textBubble
        case .code:
            codeBubble
        case .thought:
            thoughtBubble
        default:
            textBubble
        }
    }
    
    private var textBubble: some View {
        Text(message.content)
            .font(.system(size: 15))
            .foregroundColor(isCurrentUser ? .white : .honeycomb.text)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isCurrentUser ? Color.honeycomb.primary : Color.honeycomb.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isCurrentUser ? Color.clear : Color.honeycomb.accent.opacity(0.2), lineWidth: 1)
            )
    }
    
    private var codeBubble: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .font(.caption)
                Text(message.metadata?.codeLanguage ?? "Code")
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                Button(action: copyCode) {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                }
            }
            .foregroundColor(.honeycomb.textSecondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(message.content)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.honeycomb.text)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.honeycomb.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.honeycomb.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var thoughtBubble: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "brain")
                    .font(.caption)
                Text("Thinking Process")
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                Button(action: { showFullContent.toggle() }) {
                    Image(systemName: showFullContent ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
            }
            .foregroundColor(.honeycomb.secondary)
            
            if showFullContent {
                Text(message.content)
                    .font(.caption)
                    .foregroundColor(.honeycomb.textSecondary)
                    .transition(.opacity)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.honeycomb.secondary.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.honeycomb.secondary.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var timestampLabel: some View {
        Text(message.timestamp.formatted(date: .omitted, time: .shortened))
            .font(.caption2)
            .foregroundColor(.honeycomb.textSecondary)
    }
    
    private func copyCode() {
        UIPasteboard.general.string = message.content
    }
}