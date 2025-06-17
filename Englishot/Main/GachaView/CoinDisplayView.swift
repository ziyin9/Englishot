import SwiftUI

struct CoinDisplayView: View {
    @EnvironmentObject var uiState: UIState
    let coins: Int64
    @State private var bounce = false
    @State private var showReward = false
    @State private var rewardAmount: Int64 = 0
    
    var body: some View {
        Group {
                ZStack {
                    HStack(spacing: 8) {
                        Image(systemName: "fish.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                            .shadow(color: .orange, radius: 2)
                            .scaleEffect(bounce ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: bounce)
                        
                        Text("\(coins)")
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
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
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
                    
                    if showReward {
                        CoinRewardView(amount: rewardAmount, delay: 0)
                            .position(x: UIScreen.main.bounds.width - 60, y: 70)
                    }
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
//        .onAppear {
//            // Set the reference to this view in UIState
//            uiState.coinDisplayView = self
//        }
    }
    
    // 顯示獎勵動畫
    func showRewardAnimation(amount: Int64) {
        rewardAmount = amount
        showReward = true
        
        // Hide reward after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showReward = false
        }
    }
}

#Preview {
    CoinDisplayView(coins: 520)
        .environmentObject(UIState())
} 
