//
//  GachaView.swift
//  Englishot
//
//  Created by 陳姿縈 on 6/11/25.
//


import SwiftUI

struct GachaView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    @FetchRequest(entity: Coin.entity(), sortDescriptors: []) var coinEntities: FetchedResults<Coin>
    
    @State private var showCard = false
    @State private var cardScale: CGFloat = 0.1
    @State private var cardOpacity = 0.0
    @State private var isSpinning = false
    @State private var showInsufficientCoinsAlert = false
    @State private var showConfirmDrawAlert = false
    
    // Card pool with rarity
    let cardPool: [(image: String, rarity: String)] = [
        ("penguin_happy", "Common"),
        ("penguin_angry", "Rare"),
        ("penguin_sad", "Common"),
        ("penguin_excited", "Ultra Rare")
    ]
    
    @State private var currentCard: (image: String, rarity: String) = ("happy_penguin", "Common")
    private let requiredCoins: Int64 = 100
    
    private var currentCoins: Int64 {
        coinEntities.first?.amount ?? 0
    }
    
    private var canDrawCard: Bool {
        currentCoins >= requiredCoins
    }
    
    var body: some View {
        ZStack {
            // Enhanced background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.6),
                    Color.blue.opacity(0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Animated particles
            ForEach(0..<30) { _ in
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: CGFloat.random(in: 2...6))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 5...10))
                            .repeatForever(autoreverses: false),
                        value: isSpinning
                    )
            }
            
            // Coin Display
            if uiState.isCoinVisible {
                CoinDisplayView(coins: currentCoins)
            }
            
            VStack(spacing: 30) {
                Text("Gacha Draw")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .purple.opacity(0.5), radius: 10)
                
                if showCard {
                    // Card display with enhanced animation
                    VStack(spacing: 15) {
                        Image(currentCard.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [.white, .gray.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: getRarityColor(currentCard.rarity).opacity(0.5), radius: 15)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(getRarityColor(currentCard.rarity), lineWidth: 2)
                            )
                            .scaleEffect(cardScale)
                            .opacity(cardOpacity)
                            .rotation3DEffect(.degrees(isSpinning ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        
                        // Rarity badge
                        Text(currentCard.rarity)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(getRarityColor(currentCard.rarity))
                                    .shadow(color: getRarityColor(currentCard.rarity).opacity(0.5), radius: 5)
                            )
                            .opacity(cardOpacity)
                    }
                } else {
                    // Crystal ball placeholder
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .purple.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 200, height: 200)
                            .shadow(color: .purple.opacity(0.3), radius: 20)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .opacity(0.8)
                    }
                    .scaleEffect(isSpinning ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isSpinning)
                }
                
                // Draw button
                Button(action: {
                    if canDrawCard {
                        showConfirmDrawAlert = true
                    } else {
                        showInsufficientCoinsAlert = true
                    }
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Draw Card")
                        Text("(\(requiredCoins) 🪙)")
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: canDrawCard ? 
                                        [Color.purple, Color.blue] :
                                        [Color.gray.opacity(0.5), Color.gray.opacity(0.3)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: canDrawCard ? .purple.opacity(0.5) : .clear, radius: 10)
                    )
                }
                .disabled(!canDrawCard)
            }
        }
        .onAppear {
            isSpinning = true
        }
        .alert("Insufficient Coins", isPresented: $showInsufficientCoinsAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You need \(requiredCoins) coins to draw a card. Play mini-games to earn more coins!")
        }
        .alert("Confirm Draw", isPresented: $showConfirmDrawAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Draw") {
                drawCard()
            }
        } message: {
            Text("Spend \(requiredCoins) coins to draw a card?")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
    }
    
    private func drawCard() {
        // Deduct coins
        deductCoin(by: requiredCoins)
        
        showCard = false
        cardScale = 0.1
        cardOpacity = 0.0
        
        // Simulate card drawing with animation
        withAnimation(.easeInOut(duration: 1.0)) {
            isSpinning = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Random card selection with rarity consideration
            currentCard = cardPool.randomElement() ?? ("happy_penguin", "Common")
            showCard = true
            
            // Card reveal animation
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                cardScale = 1.2
                cardOpacity = 1.0
                isSpinning = false
            }
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7).delay(0.5)) {
                cardScale = 1.0
            }
        }
    }
    
    private func getRarityColor(_ rarity: String) -> Color {
        switch rarity {
        case "Common":
            return .blue
        case "Rare":
            return .purple
        case "Ultra Rare":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    GachaView()
}
