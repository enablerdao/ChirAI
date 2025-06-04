import SwiftUI

@main
struct WisbeeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

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
            Text("Chats")
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right")
                }
                .tag(0)
            
            Text("Agents")
                .tabItem {
                    Label("Agents", systemImage: "cpu")
                }
                .tag(1)
            
            Text("Workspace")
                .tabItem {
                    Label("Workspace", systemImage: "square.grid.3x3")
                }
                .tag(2)
            
            Text("Settings")
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
                .font(.system(size: 100))
                .foregroundColor(.yellow)
            
            Text("Welcome to Wisbee")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your AI-powered workspace")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                isAuthenticated = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
    }
}