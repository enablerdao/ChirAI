import Foundation
import SwiftUI

@MainActor
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .light
    @Published var accentColor: Color = .honeycomb.primary
    
    private let defaults = UserDefaults.standard
    private let themeKey = "app_theme"
    
    init() {
        loadTheme()
    }
    
    private func loadTheme() {
        if let themeName = defaults.string(forKey: themeKey),
           let theme = Theme(rawValue: themeName) {
            self.currentTheme = theme
        }
    }
    
    func setTheme(_ theme: Theme) {
        currentTheme = theme
        defaults.set(theme.rawValue, forKey: themeKey)
    }
}

enum Theme: String, CaseIterable {
    case light
    case dark
    case system
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
}

extension Color {
    struct Honeycomb {
        let primary = Color("HoneycombPrimary")
        let secondary = Color("HoneycombSecondary")
        let accent = Color("HoneycombAccent")
        let background = Color("HoneycombBackground")
        let surface = Color("HoneycombSurface")
        let text = Color("HoneycombText")
        let textSecondary = Color("HoneycombTextSecondary")
        
        // Agent colors
        let royal = Color("RoyalBee")
        let worker = Color("WorkerBee")
        let scout = Color("ScoutBee")
        let custom = Color("CustomBee")
        
        // Semantic colors
        let success = Color("Success")
        let warning = Color("Warning")
        let error = Color("Error")
        let info = Color("Info")
        
        // Hexagon gradient colors
        let hexGradientStart = Color("HexGradientStart")
        let hexGradientEnd = Color("HexGradientEnd")
    }
    
    static let honeycomb = Honeycomb()
}

struct HoneycombGradient {
    static let primary = LinearGradient(
        colors: [Color.honeycomb.hexGradientStart, Color.honeycomb.hexGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accent = LinearGradient(
        colors: [Color.honeycomb.primary, Color.honeycomb.secondary],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let subtle = LinearGradient(
        colors: [Color.honeycomb.background, Color.honeycomb.surface],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct HoneycombStyle {
    static let cornerRadius: CGFloat = 12
    static let hexagonSize: CGFloat = 60
    static let spacing: CGFloat = 16
    static let shadowRadius: CGFloat = 4
    static let animationDuration: Double = 0.3
    
    static func hexagonPath(size: CGFloat) -> Path {
        Path { path in
            let width = size
            let height = size * 0.866
            let halfWidth = width / 2
            let quarterWidth = width / 4
            
            path.move(to: CGPoint(x: halfWidth, y: 0))
            path.addLine(to: CGPoint(x: width, y: height / 2))
            path.addLine(to: CGPoint(x: width - quarterWidth, y: height))
            path.addLine(to: CGPoint(x: quarterWidth, y: height))
            path.addLine(to: CGPoint(x: 0, y: height / 2))
            path.addLine(to: CGPoint(x: halfWidth, y: 0))
        }
    }
}