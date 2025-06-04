import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    
    var body: some View {
        ZStack {
            if showSplash {
                splashScreen
            } else {
                ModernChatView()
            }
        }
        .onAppear {
            startSplashAnimation()
        }
    }
    
    private var splashScreen: some View {
        ZStack {
            // Background gradient
            DesignSystem.Colors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: DesignSystem.Spacing.xl) {
                // Logo
                ZStack {
                    Circle()
                        .fill(DesignSystem.Colors.primaryGradient)
                        .frame(width: 120, height: 120)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }
                .modernShadow(DesignSystem.Shadows.large)
                
                // App name and tagline
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Text("Wisbee AI")
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .opacity(logoOpacity)
                    
                    Text("Local AI at your fingertips")
                        .font(DesignSystem.Typography.callout)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .opacity(logoOpacity)
                }
                .slideIn(delay: 0.5)
                
                // Loading indicator
                HStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(DesignSystem.Colors.accent)
                            .frame(width: 8, height: 8)
                            .scaleEffect(logoOpacity)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: logoOpacity
                            )
                    }
                }
                .padding(.top, DesignSystem.Spacing.xl)
            }
        }
    }
    
    private func startSplashAnimation() {
        // Logo entrance animation
        withAnimation(.smoothSpring.delay(0.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Transition to main app
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.smooth) {
                showSplash = false
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}