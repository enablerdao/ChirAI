import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with model selector
            VStack(spacing: 0) {
                HStack {
                    Text("Chat with AI")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Menu {
                        ForEach(viewModel.availableModels, id: \.self) { model in
                            Button(action: {
                                Task {
                                    viewModel.changeModel(to: model)
                                }
                            }) {
                                HStack {
                                    Text(model)
                                    if model == viewModel.selectedModel {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "cpu")
                                .font(.system(size: 14))
                            Text(viewModel.selectedModel)
                                .font(.caption)
                                .lineLimit(1)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        viewModel.clearChat()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                Divider()
            }
            
            // Messages
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Thinking...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        scrollView.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Input area
            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $viewModel.inputText, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1...5)
                        .focused($isInputFocused)
                        .onSubmit {
                            Task {
                                await viewModel.sendMessage()
                            }
                        }
                    
                    Button(action: {
                        Task {
                            await viewModel.sendMessage()
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(viewModel.inputText.isEmpty ? .gray : .yellow)
                    }
                    .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
        }
        .navigationBarHidden(true)
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.isUser {
                Spacer(minLength: 60)
            } else {
                Image(systemName: "cpu")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow)
                    .frame(width: 32, height: 32)
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(16)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if !message.isUser, let model = message.model {
                    Text(model)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Text(message.content)
                    .padding(12)
                    .background(
                        message.isUser ? Color.yellow.opacity(0.9) : Color.gray.opacity(0.1)
                    )
                    .foregroundColor(
                        message.isUser ? .black : .primary
                    )
                    .cornerRadius(16)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !message.isUser {
                Spacer(minLength: 60)
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                    .frame(width: 32, height: 32)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChatView()
}