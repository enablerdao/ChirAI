import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var chatManager = ChatManager()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPearl")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    chatMessagesView
                    inputView
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("🌸")
                        .font(.title2)
                    Text("ChirAI")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("SakuraPink"))
                }
                Text("ローカルAIチャット")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { showingSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(Color("Teal"))
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .shadow(radius: 1)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private var chatMessagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(chatManager.messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                    }
                }
                .padding()
            }
            .onChange(of: chatManager.messages.count) { _ in
                if let lastMessage = chatManager.messages.last {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private var inputView: some View {
        HStack(spacing: 12) {
            TextField("メッセージを入力...", text: $chatManager.inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.send)
                .onSubmit {
                    Task {
                        await chatManager.sendMessage()
                    }
                }
            
            Button(action: {
                Task {
                    await chatManager.sendMessage()
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color("SakuraPink"))
                    .clipShape(Circle())
            }
            .disabled(chatManager.inputText.isEmpty || chatManager.isLoading)
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }
}

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding()
                        .background(Color("SakuraPink"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("🌸")
                        Text("ChirAI")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("SakuraPink"))
                    }
                    
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 50)
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("⚙️ 設定")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("SakuraPink"))
                
                Text("ChirAI v{ChirAIProductionProject().version}")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
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

#Preview {
    ContentView()
}
