import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                WelcomePage()
                    .tag(0)
                
                FeaturesPage()
                    .tag(1)
                
                GetStartedPage()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            if currentPage == 2 {
                Button(action: {
                    appState.isAuthenticated = true
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.honeycomb.primary)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }
}

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            HexagonView(size: 120, color: .honeycomb.primary)
            
            VStack(spacing: 16) {
                Text("Welcome to Wisbee")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your AI-powered workspace")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct FeaturesPage: View {
    var body: some View {
        VStack(spacing: 48) {
            Spacer()
            
            VStack(spacing: 32) {
                FeatureRow(
                    icon: "cpu",
                    title: "Smart Agents",
                    description: "Create and manage AI agents tailored to your needs"
                )
                
                FeatureRow(
                    icon: "bubble.left.and.bubble.right",
                    title: "Natural Conversations",
                    description: "Chat with AI agents like you would with a colleague"
                )
                
                FeatureRow(
                    icon: "square.grid.3x3",
                    title: "Organized Workspace",
                    description: "Keep all your projects and conversations in one place"
                )
            }
            
            Spacer()
        }
        .padding()
    }
}

struct GetStartedPage: View {
    var body: some View {
        VStack(spacing: 48) {
            Spacer()
            
            HexagonView(size: 100, color: .honeycomb.accent)
            
            VStack(spacing: 16) {
                Text("Ready to Begin?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Let's set up your workspace and create your first AI agent")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.honeycomb.primary)
                .frame(width: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}