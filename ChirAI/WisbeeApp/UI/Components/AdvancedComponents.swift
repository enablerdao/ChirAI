import SwiftUI

// MARK: - Advanced UI Components

// MARK: - Particle Animation View
struct ParticleAnimationView: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var opacity: Double
        var scale: CGFloat
        var color: Color
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: 4, height: 4)
                    .scaleEffect(particle.scale)
                    .opacity(particle.opacity)
                    .position(x: particle.x, y: particle.y)
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        for _ in 0..<20 {
            let particle = Particle(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                opacity: Double.random(in: 0.1...0.8),
                scale: CGFloat.random(in: 0.5...2.0),
                color: [.blue, .purple, .pink, .cyan].randomElement()!
            )
            particles.append(particle)
        }
        
        animateParticles()
    }
    
    private func animateParticles() {
        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
            for i in particles.indices {
                particles[i].y -= 1000
                particles[i].opacity = 0
            }
        }
    }
}

// MARK: - Enhanced Message Bubble
struct EnhancedMessageBubble: View {
    let message: ChatMessage
    @State private var isVisible = false
    @State private var showActions = false
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
                userBubble
            } else {
                aiBubble
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal)
        .scaleEffect(isVisible ? 1 : 0.8)
        .opacity(isVisible ? 1 : 0)
        .offset(dragOffset)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if abs(value.translation.x) > 100 {
                        showActions = true
                    }
                }
        )
        .contextMenu {
            messageContextMenu
        }
    }
    
    private var userBubble: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.8),
                                Color.purple.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            
            HStack(spacing: 4) {
                Text("You")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
    }
    
    private var aiBubble: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // Model badge
                    HStack(spacing: 6) {
                        aiIcon
                        Text(message.model ?? "AI")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(.blue.opacity(0.15))
                            )
                    }
                    
                    // Message content with typing animation
                    TypewriterText(text: message.content)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.quaternary, lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
        }
    }
    
    private var aiIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 24, height: 24)
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    private var messageContextMenu: some View {
        VStack {
            Button(action: { copyMessage() }) {
                Label("コピー", systemImage: "doc.on.doc")
            }
            
            Button(action: { shareMessage() }) {
                Label("共有", systemImage: "square.and.arrow.up")
            }
            
            if !message.isUser {
                Button(action: { regenerateResponse() }) {
                    Label("再生成", systemImage: "arrow.clockwise")
                }
            }
        }
    }
    
    private func copyMessage() {
        UIPasteboard.general.string = message.content
        // Show toast notification
    }
    
    private func shareMessage() {
        // Implement share functionality
    }
    
    private func regenerateResponse() {
        // Implement regenerate functionality
    }
}

// MARK: - Typewriter Text Effect
struct TypewriterText: View {
    let text: String
    @State private var displayedText = ""
    @State private var currentIndex = 0
    
    var body: some View {
        Text(displayedText)
            .onAppear {
                startTyping()
            }
    }
    
    private func startTyping() {
        displayedText = ""
        currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText.append(text[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Custom Loading Indicator
struct AILoadingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(.blue.gradient)
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 1.5 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
            
            Text("AI is thinking...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Enhanced Model Picker
struct EnhancedModelPicker: View {
    @Binding var selectedModel: String
    let availableModels: [String]
    @State private var showingPicker = false
    
    var body: some View {
        Button(action: { showingPicker = true }) {
            HStack(spacing: 8) {
                modelIcon
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedModel)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(modelDescription)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.quaternary, lineWidth: 1)
                    )
            )
        }
        .sheet(isPresented: $showingPicker) {
            ModelSelectionSheet(
                selectedModel: $selectedModel,
                availableModels: availableModels
            )
        }
    }
    
    private var modelIcon: some View {
        Image(systemName: selectedModel.contains("qwen") ? "globe.asia.australia" : "cpu")
            .font(.system(size: 16))
            .foregroundColor(.blue)
    }
    
    private var modelDescription: String {
        switch selectedModel {
        case let model where model.contains("qwen"):
            return "多言語対応・日本語最適化"
        case let model where model.contains("gemma"):
            return "高速・軽量モデル"
        default:
            return "汎用モデル"
        }
    }
}

// MARK: - Model Selection Sheet
struct ModelSelectionSheet: View {
    @Binding var selectedModel: String
    let availableModels: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(availableModels, id: \.self) { model in
                ModelRow(
                    model: model,
                    isSelected: model == selectedModel
                ) {
                    selectedModel = model
                    dismiss()
                }
            }
            .navigationTitle("モデル選択")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Model Row
struct ModelRow: View {
    let model: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(modelDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var modelDescription: String {
        switch model {
        case let m where m.contains("qwen"):
            return "多言語サポート・日本語に最適化"
        case let m where m.contains("gemma3:1b"):
            return "超高速・軽量・英語特化"
        case let m where m.contains("gemma3:4b"):
            return "バランス型・汎用モデル"
        default:
            return "実験的モデル"
        }
    }
}