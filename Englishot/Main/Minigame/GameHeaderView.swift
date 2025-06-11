import SwiftUI

struct GameHeaderView: View {
    let title: String
    let subtitle: String
    let colors: [Color]
    @Binding var showLeaveGameView: Bool
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
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
            
            // Coin display in top right corner
            VStack {
                HStack {
                    Spacer()
                    GameCoinDisplayView()
                        .environmentObject(gameState)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                Spacer()
            }
        }
    }
}

// Coin Display Component for Game Header (smaller version)
struct GameCoinDisplayView: View {
    @EnvironmentObject var gameState: GameState
    @State private var bounce = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(.yellow)
                .shadow(color: .orange, radius: 2)
                .scaleEffect(bounce ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: bounce)
            
            Text("\(gameState.coins)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.2))
                .overlay(
                    Capsule()
                        .stroke(Color.yellow.opacity(0.5), lineWidth: 1)
                )
        )
        .onChange(of: gameState.coins) { _ in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                bounce = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    bounce = false
                }
            }
        }
    }
}

#Preview {
    GameHeaderView(
        title: "Spelling Fun",
        subtitle: "Tap letters to spell the word",
        colors: [Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)), Color(#colorLiteral(red: 0.3, green: 0.65, blue: 0.5, alpha: 1))],
        showLeaveGameView: .constant(false)
    )
    .environmentObject(GameState())
} 