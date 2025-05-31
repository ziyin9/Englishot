import SwiftUI

struct GameHeaderView: View {
    let title: String
    let subtitle: String
    let colors: [Color]
    @Binding var showLeaveGameView: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            // Title with gradient
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: colors[0].opacity(0.3), radius: 5, x: 0, y: 2)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
            
            // Subtitle
            Text(subtitle)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(colors[0].opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GameHeaderView(
        title: "Spelling Fun",
        subtitle: "Tap letters to spell the word",
        colors: [Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)), Color(#colorLiteral(red: 0.3, green: 0.65, blue: 0.5, alpha: 1))],
        showLeaveGameView: .constant(false)
    )
} 