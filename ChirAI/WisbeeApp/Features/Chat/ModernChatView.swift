import SwiftUI

struct ModernChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var scrollProxy: ScrollViewReader?
    @State private var showModelPicker = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            DesignSystem.Colors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                messagesView
                
                inputView
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    private var headerView: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wisbee AI")
                        .font(DesignSystem.Typography.title)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                    
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Circle()
                            .fill(DesignSystem.Colors.success)
                            .frame(width: 8, height: 8)
                        
                        Text("Connected")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                modelSelectorButton
            }
            
            Divider()
                .background(DesignSystem.Colors.textTertiary.opacity(0.3))
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.top, DesignSystem.Spacing.md)
        .background(
            DesignSystem.Colors.backgroundSecondary
                .ignoresSafeArea(edges: .top)
        )
    }
    
    private var modelSelectorButton: some View {
        Button(action: { showModelPicker.toggle() }) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: "cpu")
                    .foregroundColor(DesignSystem.Colors.accent)
                
                Text(viewModel.selectedModel)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(1)
                
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .foregroundColor(DesignSystem.Colors.textTertiary)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .fill(DesignSystem.Colors.backgroundTertiary)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                            .stroke(DesignSystem.Colors.accent.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .sheet(isPresented: $showModelPicker) {
            modelPickerView
        }
    }
    
    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: DesignSystem.Spacing.lg) {
                    ForEach(viewModel.messages) { message in
                        ModernMessageBubble(message: message)
                            .id(message.id)
                    }
                    
                    if viewModel.isLoading {
                        typingIndicator
                    }
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
            .onAppear {
                scrollProxy = proxy
            }
            .onChange(of: viewModel.messages.count) { _ in
                scrollToBottom()
            }
        }
    }
    
    private var typingIndicator: some View {
        HStack {
            HStack(spacing: DesignSystem.Spacing.xs) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(DesignSystem.Colors.accent)
                        .frame(width: 8, height: 8)
                        .scaleEffect(1.0)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: viewModel.isLoading
                        )
                }
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.aiMessage)
            .cornerRadius(DesignSystem.CornerRadius.lg)
            
            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
    }
    
    private var inputView: some View {
        VStack(spacing: 0) {
            Divider()
                .background(DesignSystem.Colors.textTertiary.opacity(0.3))
            
            HStack(spacing: DesignSystem.Spacing.md) {
                HStack {
                    TextField("Type your message...", text: $viewModel.inputText, axis: .vertical)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(1...4)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            sendMessage()
                        }
                    
                    if !viewModel.inputText.isEmpty {
                        Button(action: { viewModel.inputText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(DesignSystem.Colors.textTertiary)
                        }
                    }
                }
                .padding(DesignSystem.Spacing.md)
                .background(DesignSystem.Colors.backgroundTertiary)
                .cornerRadius(DesignSystem.CornerRadius.xl)
                
                sendButton
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.backgroundSecondary)
        }
    }
    
    private var sendButton: some View {
        Button(action: sendMessage) {
            Image(systemName: viewModel.isLoading ? "stop.circle.fill" : "arrow.up.circle.fill")
                .font(.title2)
                .foregroundColor(
                    canSend ? DesignSystem.Colors.accent : DesignSystem.Colors.textTertiary
                )
                .scaleEffect(canSend ? 1.0 : 0.8)
        }
        .disabled(!canSend && !viewModel.isLoading)
        .animation(.spring(response: 0.3), value: canSend)
    }
    
    private var modelPickerView: some View {
        NavigationView {
            List(viewModel.availableModels, id: \.self) { model in
                Button(action: {
                    viewModel.changeModel(to: model)
                    showModelPicker = false
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(model)
                                .font(DesignSystem.Typography.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            
                            Text(modelDescription(for: model))
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        if model == viewModel.selectedModel {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(DesignSystem.Colors.accent)
                        }
                    }
                    .padding(.vertical, DesignSystem.Spacing.xs)
                }
            }
            .listStyle(PlainListStyle())
            .background(DesignSystem.Colors.backgroundPrimary)
            .navigationTitle("Select Model")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showModelPicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private var canSend: Bool {
        !viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !viewModel.isLoading
    }
    
    private func sendMessage() {
        guard canSend else { return }
        
        Task {
            await viewModel.sendMessage()
            scrollToBottom()
        }
        
        isTextFieldFocused = false
    }
    
    private func scrollToBottom() {
        guard let lastMessage = viewModel.messages.last else { return }
        
        withAnimation(.easeOut(duration: 0.5)) {
            scrollProxy?.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    private func modelDescription(for model: String) -> String {
        switch model {
        case "gemma3:1b":
            return "Fast, lightweight model • English optimized"
        case "gemma3:4b":
            return "Balanced performance • Better reasoning"
        case "qwen2.5:3b":
            return "Multilingual • Japanese support"
        case let model where model.contains("qwen"):
            return "Multilingual model • Good for translation"
        default:
            return "Local language model"
        }
    }
}

#Preview {
    ModernChatView()
        .preferredColorScheme(.dark)
}