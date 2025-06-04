import SwiftUI

struct HexagonView: View {
    let size: CGFloat
    let color: Color
    let icon: String?
    let isAnimating: Bool
    
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    init(size: CGFloat = 60, color: Color = .honeycomb.primary, icon: String? = nil, isAnimating: Bool = false) {
        self.size = size
        self.color = color
        self.icon = icon
        self.isAnimating = isAnimating
    }
    
    var body: some View {
        ZStack {
            // Hexagon shape
            HoneycombStyle.hexagonPath(size: size)
                .fill(HoneycombGradient.primary)
                .overlay(
                    HoneycombStyle.hexagonPath(size: size)
                        .stroke(color, lineWidth: 2)
                )
                .shadow(color: color.opacity(0.3), radius: HoneycombStyle.shadowRadius)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
            
            // Icon
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.white)
            }
        }
        .frame(width: size, height: size * 0.866)
        .onAppear {
            if isAnimating {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            rotation = 360
            scale = 1.1
        }
    }
}

struct HexagonButton: View {
    let size: CGFloat
    let color: Color
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(size: CGFloat = 60, color: Color = .honeycomb.primary, icon: String, action: @escaping () -> Void) {
        self.size = size
        self.color = color
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HexagonView(size: size, color: color, icon: icon)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct HexagonGrid: View {
    let items: Int
    let columns: Int
    let spacing: CGFloat
    let hexSize: CGFloat
    
    init(items: Int, columns: Int = 3, spacing: CGFloat = 8, hexSize: CGFloat = 60) {
        self.items = items
        self.columns = columns
        self.spacing = spacing
        self.hexSize = hexSize
    }
    
    var body: some View {
        VStack(spacing: spacing * 0.75) {
            ForEach(0..<rowCount, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<itemsInRow(row), id: \.self) { col in
                        let index = row * columns + col
                        if index < items {
                            HexagonView(
                                size: hexSize,
                                color: randomColor(for: index)
                            )
                        }
                    }
                }
                .offset(x: row % 2 == 1 ? hexSize * 0.5 : 0)
            }
        }
    }
    
    private var rowCount: Int {
        (items + columns - 1) / columns
    }
    
    private func itemsInRow(_ row: Int) -> Int {
        let remaining = items - (row * columns)
        return min(columns, remaining)
    }
    
    private func randomColor(for index: Int) -> Color {
        let colors: [Color] = [.honeycomb.primary, .honeycomb.secondary, .honeycomb.accent]
        return colors[index % colors.count]
    }
}