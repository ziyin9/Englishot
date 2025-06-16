import SwiftUI
import CoreData

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
    @State private var showGameScene = false
    //555
    
    private let sortOptions = ["Rarity", "Unlocked", "Newest"]
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
    
    private var cardsByType: [String: [PenguinCard]] {
        Dictionary(grouping: gachaSystem.availableCards) { $0.cardType }
    }
    
    private func sortedCards(for type: String) -> [PenguinCard] {
        let cards = cardsByType[type] ?? []
        return cards.sorted { card1, card2 in
            let rarityOrder = ["Snowflake": 0, "Ice Crystal": 1, "Frozen Star": 2, "Aurora": 3]
            return (rarityOrder[card1.rarity] ?? 0) < (rarityOrder[card2.rarity] ?? 0)
        }
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
                }
                .padding(.top)
                
                // Card sections by type
                ScrollView {
                    VStack(spacing: 25) {
                        ForEach(["Emotion", "Profession", "Activity"], id: \.self) { type in
                            if let cards = cardsByType[type], !cards.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    // Section header
                                    HStack {
                                        Image(systemName: getTypeIcon(for: type))
                                            .font(.system(size: 20))
                                            .foregroundColor(getTypeColor(for: type))
                                        
                                        Text(getTypeTitle(for: type))
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal)
                                    
                                    // Cards grid
                                    LazyVGrid(columns: columns, spacing: 10) {
                                        ForEach(sortedCards(for: type)) { card in
                                            CardGridItem(card: card)
                                                .frame(height: 120)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                // Draw button
                Button(action: {
                    if canDrawCard {
                        showGameScene = true
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
                .fullScreenCover(isPresented: $showGameScene) {
                    GameSceneView(isPresented: $showGameScene) {
                        withAnimation {
                            showGameScene = false
                            drawCard()
                        }
                    }
                    .transition(.opacity)
                }
                //555
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
    
    private func getTypeIcon(for type: String) -> String {
        switch type {
        case "Emotion": return "face.smiling"
        case "Profession": return "briefcase"
        case "Activity": return "figure.walk"
        default: return "questionmark"
        }
    }
    
    private func getTypeTitle(for type: String) -> String {
        switch type {
        case "Emotion": return "表情"
        case "Profession": return "職業"
        case "Activity": return "活動"
        default: return type
        }
    }
    
    private func getTypeColor(for type: String) -> Color {
        switch type {
        case "Emotion": return .pink
        case "Profession": return .green
        case "Activity": return .orange
        default: return .gray
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
//小卡呈現樣式
struct CardGridItem: View {
    let card: PenguinCard
    @State private var showDetail = false
    
    var body: some View {
        Button(action: {
            showDetail = true
        }) {
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(card.rarityColor).opacity(0.3),
                                Color(card.rarityColor).opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(card.rarityColor).opacity(0.5),
                                        Color(card.rarityColor).opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                // Ice crystal pattern overlay
                ZStack {
                    ForEach(0..<3) { i in
                        Image(systemName: "snowflake")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.1))
                            .rotationEffect(.degrees(Double(i) * 60))
                            .offset(x: CGFloat.random(in: -20...20), y: CGFloat.random(in: -20...20))
                    }
                }
                
                VStack(spacing: 8) {
                    // Card image
                    if card.unlocked {
                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: Color(card.rarityColor).opacity(0.3), radius: 5)
                    } else {
                        // Locked card placeholder
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.gray.opacity(0.3),
                                            Color.gray.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Image(systemName: "lock.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(height: 60)
                    }
                    
                    // Card name
                    Text(card.englishWord)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    // Type badge
//                    Text(card.cardType)
//                        .font(.system(size: 10, weight: .medium, design: .rounded))
//                        .foregroundColor(.white.opacity(0.8))
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 2)
//                        .background(
//                            Capsule()
//                                .fill(Color.white.opacity(0.2))
//                        )
                    
                    // Rarity badge
                    HStack(spacing: 4) {
                        Text(card.rarityIcon)
                            .font(.system(size: 10))
//                        Text(card.rarity)
//                            .font(.system(size: 10, weight: .medium, design: .rounded))
                    }
                    .foregroundColor(Color(card.rarityColor))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color(card.rarityColor).opacity(0.2))
                    )
                }
                .padding(8)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showDetail) {
            CardDetailView(card: card)
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.1))
        )
    }
}

#Preview {
    GachaView(gachaSystem: GachaSystem())
}
