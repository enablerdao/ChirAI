import SwiftUI

// MARK: - Modern Design System
struct DesignSystem {
    
    // MARK: - Colors
    struct Colors {
        // Primary gradient colors
        static let primaryGradient = LinearGradient(
            colors: [
                Color(red: 0.4, green: 0.2, blue: 0.8),  // Deep purple
                Color(red: 0.2, green: 0.6, blue: 0.9)   // Bright blue
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Background colors
        static let backgroundPrimary = Color(red: 0.05, green: 0.05, blue: 0.1)
        static let backgroundSecondary = Color(red: 0.1, green: 0.1, blue: 0.15)
        static let backgroundTertiary = Color(red: 0.15, green: 0.15, blue: 0.2)
        
        // Message colors
        static let userMessage = LinearGradient(
            colors: [
                Color(red: 0.4, green: 0.2, blue: 0.8),
                Color(red: 0.5, green: 0.3, blue: 0.9)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let aiMessage = Color(red: 0.12, green: 0.12, blue: 0.18)
        
        // Accent colors
        static let accent = Color(red: 0.3, green: 0.7, blue: 1.0)
        static let accentSecondary = Color(red: 0.8, green: 0.4, blue: 0.9)
        
        // Text colors
        static let textPrimary = Color.white
        static let textSecondary = Color(white: 0.7)
        static let textTertiary = Color(white: 0.5)
        
        // Success/Error colors
        static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
        static let error = Color(red: 0.9, green: 0.3, blue: 0.3)
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        static let callout = Font.system(size: 15, weight: .medium, design: .rounded)
        static let caption = Font.system(size: 12, weight: .medium, design: .rounded)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .rounded)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let pill: CGFloat = 50
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(
            color: Color.black.opacity(0.3),
            radius: 4,
            x: 0,
            y: 2
        )
        
        static let medium = Shadow(
            color: Color.black.opacity(0.25),
            radius: 8,
            x: 0,
            y: 4
        )
        
        static let large = Shadow(
            color: Color.black.opacity(0.2),
            radius: 16,
            x: 0,
            y: 8
        )
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions
extension View {
    func modernShadow(_ shadow: Shadow = DesignSystem.Shadows.medium) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
    
    func glassMorphism() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
    }
    
    func modernButton() -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.primaryGradient)
            .foregroundColor(DesignSystem.Colors.textPrimary)
            .font(DesignSystem.Typography.headline)
            .cornerRadius(DesignSystem.CornerRadius.pill)
            .modernShadow()
    }
}