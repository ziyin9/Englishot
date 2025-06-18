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
    @State private var refreshTrigger = false
    @State private var showGotCard = false
    @State private var lastDrawnCard: PenguinCard?
    @State private var isDuplicate = false
    @State private var refundAmount: Int64 = 0
    @State private var showDeveloperDelete = false
    @State private var selectedGachaType: GachaType = .normal
    
    private let sortOptions = ["Rarity", "Unlocked", "Newest"]
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    private var requiredCoins: Int64 {
        selectedGachaType.cost
    }
    
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
                    Color(#colorLiteral(red: 0.1, green: 0.15, blue: 0.3, alpha: 1)),
                    Color(#colorLiteral(red: 0.1464613083, green: 0.224046581, blue: 0.456802399, alpha: 1)),
                    Color(#colorLiteral(red: 0.1464613083, green: 0.224046581, blue: 0.456802399, alpha: 1)),
                    Color(#colorLiteral(red: 0.2592188678, green: 0.3274831218, blue: 0.5322758838, alpha: 1)),
                    Color(#colorLiteral(red: 0.2592188678, green: 0.3274831218, blue: 0.5322758838, alpha: 1)),
                    Color(#colorLiteral(red: 0.3584964276, green: 0.4529050306, blue: 0.7361308396, alpha: 1)),
                    Color(#colorLiteral(red: 0.3584964276, green: 0.4529050306, blue: 0.7361308396, alpha: 1)),
                    Color(#colorLiteral(red: 0.8, green: 0.9, blue: 1.0, alpha: 1)),  // Light ice blue
                    Color(#colorLiteral(red: 0.9, green: 0.95, blue: 1.0, alpha: 1))  // Almost white with slight blue tint
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
                    Text("企鵝卡收集冊")//"Penguin Collection"
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.top)
                
                // Gacha Type Selector
                GachaTypeSelectorView(
                    selectedGachaType: $selectedGachaType,
                    currentCoins: currentCoins,
                    onDrawCard: { gachaType in
                        if currentCoins >= gachaType.cost {
                            showConfirmDrawAlert = true
                        } else {
                            showInsufficientCoinsAlert = true
                        }
                    }
                )
                .padding(.horizontal)
                
                // Card sections by type
                ScrollView {
                    VStack(spacing: 25) {
                        ForEach(["Emotion", "Profession", "Activity", "Festival"], id: \.self) { type in
                            if let cards = cardsByType[type], !cards.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    // Section header
                                    HStack {
                                        Image("\(getTypeIcon(for: type))")
                                            .resizable()
                                            .frame(width: 50, height: 50)
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
                                            CardGridItem(card: card, refreshTrigger: $refreshTrigger)
                                                .frame(height: 80)
                                                .environmentObject(gachaSystem)
                                        }
                                    }
                                    .padding(.horizontal)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                

            }
            // Add GotCardView
            if showGotCard, let card = lastDrawnCard {
                GotCardView(
                    card: card,
                    isDuplicate: isDuplicate,
                    refundAmount: refundAmount,
                    isPresented: $showGotCard
                )
            }
            
            // Add developer delete button
            VStack {
                HStack {
                    Button(action: {
                        showDeveloperDelete = true
                    }) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color.red.opacity(0.8))
                            )
                    }
                    .padding(.leading, 16)
                    .padding(.top, 8)
                    Spacer()
                }
                Spacer()
            }
            //  抽卡這裡要有以下這段才會   show
            if uiState.showCoinReward {
                CoinRewardView(amount: Int64(uiState.coinRewardAmount), delay: 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 5)
                    .padding(.trailing, 20)
                    .zIndex(100)
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
            Text("Spend \(requiredCoins) coins to draw a \(selectedGachaType.title) card?")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showDeveloperDelete) {
            DeveloperDeleteView(refreshTrigger: $refreshTrigger)
        }
    }
    
    private func getTypeIcon(for type: String) -> String {
            switch type {
            case "Emotion": return "Emotion"
            case "Profession": return "Profession"
            case "Activity": return "Activity"
            case "Festival": return "Festival"
            default: return "questionmark"
            }
        }
        
        private func getTypeTitle(for type: String) -> String {
            switch type {
            case "Emotion": return "表情"
            case "Profession": return "職業"
            case "Activity": return "活動"
            case "Festival": return "節日"
            default: return type
            }
        }
        
        private func getTypeColor(for type: String) -> Color {
            switch type {
            case "Emotion": return .pink
            case "Profession": return .green
            case "Activity": return .orange
            case "Festival": return .purple
            default: return .gray
            }
        }
    
    private func drawCard() {
        
//         Show coin deduction animation first
        
        
        if let coinDisplayView = uiState.coinDisplayView {
            coinDisplayView.showRewardAnimation(amount: -requiredCoins)
        } else {
            uiState.coinRewardAmount = -Int(requiredCoins)
            uiState.showCoinReward = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                uiState.showCoinReward = false
            }
        }
        
        
        // Draw card using GachaSystem with selected type
        if gachaSystem.drawCard(gameState: GameState(), gachaType: selectedGachaType) {
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
                
                // Show GotCardView
                if let drawnCard = gachaSystem.lastDrawnCard {
                    lastDrawnCard = drawnCard
                    isDuplicate = gachaSystem.lastDrawWasDuplicate
                    refundAmount = drawnCard.duplicateRefund
                    showGotCard = true
                    
                    // If it's a duplicate card, show the refund animation
                    if isDuplicate {
                        if let coinDisplayView = uiState.coinDisplayView {
                            coinDisplayView.showRewardAnimation(amount: Int64(refundAmount))
                        } else {
                            uiState.coinRewardAmount = Int(refundAmount)
                            uiState.showCoinReward = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                uiState.showCoinReward = false
                            }
                        }
                    }
                }
                
                // Trigger refresh after animation completes
                refreshTrigger.toggle()
            }
        }
    }
}

// New component for gacha type selector
struct GachaTypeSelectorView: View {
    @Binding var selectedGachaType: GachaType
    let currentCoins: Int64
    let onDrawCard: (GachaType) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Current coins display
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.yellow)
                Text("Current Coins: \(currentCoins)")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 4)
            
            // Scrollable gacha type selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(GachaType.allCases, id: \.self) { gachaType in
                        GachaTypeCard(
                            gachaType: gachaType,
                            isSelected: selectedGachaType == gachaType,
                            canAfford: currentCoins >= gachaType.cost,
                            onTap: {
                                selectedGachaType = gachaType
                                onDrawCard(gachaType)
                            }
                        )
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .padding(.vertical, 8)
    }
}

struct GachaTypeCard: View {
    let gachaType: GachaType
    let isSelected: Bool
    let canAfford: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                onTap()
            }
        }) {
            VStack(spacing: 8) {
                // Icon and title
                VStack(spacing: 4) {
                    Image(systemName: gachaType.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    Text(gachaType.title)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                // Subtitle
                Text(gachaType.subtitle)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 25)
                
                // Cost
                HStack(spacing: 4) {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                    Text("\(gachaType.cost)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.3))
                )
            }
            .frame(width: 140, height: 120)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: canAfford ? gachaType.gradientColors : [Color.gray.opacity(0.5), Color.gray.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.white.opacity(0.8) : Color.white.opacity(0.2),
                                lineWidth: isSelected ? 3 : 1
                            )
                    )
                    .shadow(
                        color: canAfford ? gachaType.gradientColors.first?.opacity(0.3) ?? .clear : .clear,
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: 2
                    )
            )
            .scaleEffect(isPressed ? 0.95 : (isSelected ? 1.05 : 1.0))
            .opacity(canAfford ? 1.0 : 0.6)
        }
        .disabled(!canAfford)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        
        // Lock overlay for unaffordable options
        .overlay(
            Group {
                if !canAfford {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.8))
                        .background(
                            Circle()
                                .fill(Color.black.opacity(0.6))
                                .frame(width: 40, height: 40)
                        )
                }
            }
        )
    }
}

#Preview {
    GachaView(gachaSystem: GachaSystem())
}
