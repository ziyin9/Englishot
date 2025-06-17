import SwiftUI

struct GotCardView: View {
    let card: PenguinCard
    let isDuplicate: Bool
    let refundAmount: Int64
    @Binding var isPresented: Bool
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // Card content
            VStack(spacing: 20) {
                // Card image with effects
                ZStack {
                    // Background glow
                    Circle()
                        .fill(card.rarityGradient)
                        .frame(width: 220, height: 220)
                        .blur(radius: 20)
                        .opacity(0.5)
                    
                    // Card image
                    Image(card.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white, card.rarityColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                        .shadow(color: card.rarityColor.opacity(0.5), radius: 10)
                }
                .scaleEffect(showContent ? 1 : 0.5)
                .opacity(showContent ? 1 : 0)
                
                // Card information
                VStack(spacing: 15) {
                    // English word
                    Text(card.englishWord)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    // Chinese translation
                    Text(card.chineseWord)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Rarity badge
                    HStack(spacing: 5) {
                        Text(card.rarityIcon)
                        Text(card.rarity)
                    }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(card.rarityColor)
                    )
                    
                    // Duplicate card message
                    if isDuplicate {
                        VStack(spacing: 8) {
                            Text("你已經擁有這張卡片！")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("退回 \(refundAmount) 金幣作為補償！")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.yellow)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                    }
                }
                .offset(y: showContent ? 0 : 50)
                .opacity(showContent ? 1 : 0)
                
                // Confirm button
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Text("確認")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .offset(y: showContent ? 0 : 30)
                .opacity(showContent ? 1 : 0)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(#colorLiteral(red: 0.1, green: 0.15, blue: 0.3, alpha: 1)))
            )
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
} 