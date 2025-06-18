import SwiftUI

struct CoinRewardView: View {
    let amount: Int64
    let delay: Double
    @State private var offset: CGFloat = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var isPositive: Bool {
        amount >= 0
    }
    
    var body: some View {
        Text("\(isPositive ? "+" : "")\(amount)")
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: isPositive ? [.yellow, .orange] : [.red, .orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            .offset(y: offset)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(x: UIScreen.main.bounds.width - 50, y: 70)  // 調高起始位置
            .onAppear {
                // Add initial delay if specified
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeOut(duration: 0.6)) {
                        offset = -40
                        scale = 1.2
                        opacity = 1
                    }
                    
                    // Start fade out after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.easeIn(duration: 0.4)) {
                            opacity = 0
                        }
                    }
                }
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        CoinRewardView(amount: 50, delay: 0)
        CoinRewardView(amount: -30, delay: 0)
    }
}
