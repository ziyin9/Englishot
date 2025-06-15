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
    @ObservedObject var gachaSystem: GachaSystem
    
    @State private var showCard = false
    @State private var cardScale: CGFloat = 0.1
    @State private var cardOpacity = 0.0
    @State private var isSpinning = false
    @State private var showInsufficientCoinsAlert = false
    @State private var showConfirmDrawAlert = false
    @State private var selectedSortOption = "Rarity"
    @State private var selectedFilter = "All"
    
    private let sortOptions = ["Rarity", "Unlocked", "Newest"]
    private let filterOptions = ["All", "Emotion", "Profession", "Activity"]
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    private let requiredCoins: Int64 = 100
    
    private var currentCoins: Int64 {
        coinEntities.first?.amount ?? 0
    }
    
    private var canDrawCard: Bool {
        currentCoins >= requiredCoins
    }
    
    private var sortedAndFilteredCards: [PenguinCard] {
        var cards = gachaSystem.availableCards
        
        // Apply filter
        if selectedFilter != "All" {
            cards = cards.filter { $0.cardType == selectedFilter }
        }
        
        // Apply sort
        switch selectedSortOption {
        case "Rarity":
            cards.sort { $0.rarity > $1.rarity }
        case "Unlocked":
            cards.sort { $0.unlocked && !$1.unlocked }
        case "Newest":
            cards.sort { ($0.dateCollected ?? Date.distantPast) > ($1.dateCollected ?? Date.distantPast) }
        default:
            break
        }
        
        return cards
    }
    
    var body: some View {
        ZStack {
            // Enhanced ice & snow background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.1, green: 0.15, blue: 0.3, alpha: 1)),
                    Color(#colorLiteral(red: 0.2, green: 0.25, blue: 0.4, alpha: 1))
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Animated snowflakes
            ForEach(0..<30) { _ in
                Image(systemName: "snowflake")
                    .font(.system(size: CGFloat.random(in: 8...15)))
                    .foregroundColor(.white.opacity(0.3))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 5...10))
                            .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            }
            
            VStack(spacing: 15) {
                // Header with collection progress
                VStack(spacing: 10) {
                    Text("Penguin Collection")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    // Collection progress
                    HStack(spacing: 20) {
                        StatView(
                            title: "Collected",
                            value: "\(gachaSystem.collectedCards.count)/\(gachaSystem.availableCards.count)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        
                        StatView(
                            title: "Completion",
                            value: "\(Int(Double(gachaSystem.collectedCards.count) / Double(gachaSystem.availableCards.count) * 100))%",
                            icon: "chart.pie.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)
                    
                    // Sort and filter controls
                    HStack(spacing: 15) {
                        // Sort picker
                        Picker("Sort", selection: $selectedSortOption) {
                            ForEach(sortOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.2))
                        )
                        
                        // Filter picker
                        Picker("Filter", selection: $selectedFilter) {
                            ForEach(filterOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.2))
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                
                // Card grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(sortedAndFilteredCards) { card in
                            CardGridItem(card: card)
                                .frame(height: 120)
                        }
                    }
                    .padding()
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
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
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
                .padding(.bottom)
            }
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
        
        // Draw card using GachaSystem
        if gachaSystem.drawCard(gameState: GameState()) {
            // Card drawn successfully
            showCard = true
            cardScale = 0.1
            cardOpacity = 0.0
            
            // Simulate card drawing with animation
            withAnimation(.easeInOut(duration: 1.0)) {
                isSpinning = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
    }
}

struct CardGridItem: View {
    let card: PenguinCard
    
    var body: some View {
        ZStack {
            // Card background with ice crystal pattern
            RoundedRectangle(cornerRadius: 12)
                .fill(card.rarityGradient)
                .overlay(
                    // Ice crystal pattern
                    ZStack {
                        ForEach(0..<4) { i in
                            Image(systemName: "snowflake")
                                .font(.system(size: 8))
                                .foregroundColor(.white.opacity(0.1))
                                .rotationEffect(.degrees(Double(i) * 90))
                                .offset(x: CGFloat.random(in: -20...20), y: CGFloat.random(in: -20...20))
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [.white, card.rarityColor.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: card.rarityColor.opacity(0.3), radius: 4, x: 0, y: 2)
            
            VStack(spacing: 4) {
                // Card image with ice frame
                if card.unlocked {
                    Image(card.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white, card.rarityColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: card.rarityColor.opacity(0.3), radius: 2)
                } else {
                    // Locked card placeholder with ice theme
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.1), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "penguin")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                        
                        Image(systemName: "lock.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .offset(x: 15, y: 15)
                    }
                }
                
                // Card name with type badge
                VStack(spacing: 2) {
                    Text(card.cardName)
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    // Type badge
                    Text(card.cardType)
                        .font(.system(size: 8, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(card.cardTypeColor)
                        )
                }
                
                // Rarity badge with icon
                HStack(spacing: 2) {
                    Text(card.rarityIcon)
                        .font(.system(size: 8))
                    Text(card.rarity)
                        .font(.system(size: 8, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(card.rarityColor)
                )
            }
            .padding(4)
        }
        .opacity(card.unlocked ? 1.0 : 0.6)
    }
}

struct StatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

#Preview {
    GachaView(gachaSystem:GachaSystem())
}
