import SwiftUI

struct CoinDisplayView: View {
    @EnvironmentObject var uiState: UIState
    let coins: Int64
    @State private var bounce = false
    
    var body: some View {
        Group {
            if uiState.isCoinVisible {
                HStack(spacing: 8) {
                    Image(systemName: "fish.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange, radius: 2)
                        .scaleEffect(bounce ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: bounce)
                    
                    Text("\(coins)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color.yellow.opacity(0.5), lineWidth: 1)
                        )
                )
                .transition(.scale.combined(with: .opacity))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 50)
                .padding(.trailing, 10)
            }
        }
        .ignoresSafeArea(edges: .top)

        .onChange(of: coins) { _ in
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
    CoinDisplayView(coins: 520)
        .environmentObject(UIState())
} 
