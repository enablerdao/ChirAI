import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isAuthenticated = false
    
    var body: some View {
        if isAuthenticated {
            MainTabView(selectedTab: $selectedTab)
        } else {
            WelcomeView(isAuthenticated: $isAuthenticated)
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ChatView()
            }
            .tabItem {
                Label("Chats", systemImage: "bubble.left.and.bubble.right")
            }
            .tag(0)
            
            VStack {
                Image(systemName: "cpu")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                Text("Agents")
                    .font(.title)
                    .padding()
                Text("Manage your AI agents")
                    .foregroundColor(.secondary)
            }
            .tabItem {
                Label("Agents", systemImage: "cpu")
            }
            .tag(1)
            
            VStack {
                Image(systemName: "square.grid.3x3")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                Text("Workspace")
                    .font(.title)
                    .padding()
                Text("Your project workspace")
                    .foregroundColor(.secondary)
            }
            .tabItem {
                Label("Workspace", systemImage: "square.grid.3x3")
            }
            .tag(2)
            
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                Text("Settings")
                    .font(.title)
                    .padding()
                Text("App preferences and configuration")
                    .foregroundColor(.secondary)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(3)
        }
        .tint(Color.yellow)
    }
}

struct WelcomeView: View {
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "hexagon.fill")
                .font(.system(size: 120))
                .foregroundColor(.yellow)
                .shadow(color: .yellow.opacity(0.3), radius: 10)
            
            VStack(spacing: 16) {
                Text("Welcome to Wisbee")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Your AI-powered workspace")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 20) {
                FeatureRow(icon: "cpu", title: "Smart Agents", description: "Create AI agents for different tasks")
                FeatureRow(icon: "bubble.left.and.bubble.right", title: "Natural Chat", description: "Conversation-based interface")
                FeatureRow(icon: "square.grid.3x3", title: "Organized", description: "Keep projects structured")
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isAuthenticated = true
                }
            }) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Get Started")
                        .fontWeight(.semibold)
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.yellow, Color.orange.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .yellow.opacity(0.4), radius: 8)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.05), Color.yellow.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.yellow)
                .frame(width: 40, height: 40)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}