import SwiftUI
import CoreData

enum ActiveSheet: Identifiable {
    case unlock
    case delete

    var id: Int {
        hashValue
    }
}

struct GachaView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    @FetchRequest(entity: Coin.entity(), sortDescriptors: []) var coinEntities: FetchedResults<Coin>
    @ObservedObject var gachaSystem: GachaSystem
    
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }

    
    @State private var showCard = false
    @State private var cardScale: CGFloat = 0.1
    @State private var cardOpacity = 0.0
    @State private var isSpinning = false

    @State private var selectedSortOption = "Rarity"
    @State private var showGameScene = false
    @State private var refreshTrigger = false
    @State private var showGotCard = false
    @State private var lastDrawnCard: PenguinCard?
    @State private var isDuplicate = false
    @State private var refundAmount: Int64 = 0
    @State private var showDeveloperDelete = false
    @State private var selectedGachaType: GachaType = .normal
    @State private var showUnlockSheet = false
    @State private var activeSheet: ActiveSheet? = nil
    @State private var showRarityAnimation = false
    @State private var currentRarity = ""
    @State private var showCustomAlert = false
    @State private var currentAlertType: AlertType = .insufficientCoins
    @State private var showCollectionInfo = false
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
            // Improved snow effect with varying sizes
            ForEach(snowflakes) { snowflake in
                Snowflake_View(snowflake: snowflake)
            }
            
            VStack(spacing: 15) {
                // Header with collection progress
                VStack {
                    HStack{
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            showCollectionInfo = true
                        }) {
                            Image("gachaicon")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text("企鵝卡收集冊")//"Penguin Collection"
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                
                
                // Card sections by type
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Gacha Type Selector
                        GachaTypeSelectorView(
                            selectedGachaType: $selectedGachaType,
                            currentCoins: currentCoins,
                            onDrawCard: { gachaType in
                                if currentCoins >= gachaType.cost {
                                    currentAlertType = .confirmDraw
                                    showCustomAlert = true
                                } else {
                                    currentAlertType = .insufficientCoins
                                    showCustomAlert = true
                                }
                            }
                        )
                        .padding(.horizontal)
                        
                        
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
            
            
            // Add developer delete button
            VStack {
                HStack(spacing: 5) {
                    Button(action: {
                        activeSheet = .delete
                    }) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color.red.opacity(0.8))
                            )
                            .opacity(0)
                    }
                    Button(action: {
                        activeSheet = .unlock
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color.green.opacity(0.8))
                            )
                            .opacity(0)

                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                Spacer()
            }
            if uiState.showCoinReward {
                CoinRewardView(amount: Int64(uiState.coinRewardAmount), delay: 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 5)
                    .padding(.trailing, 20)
                    .zIndex(100)
            }
            
        }
        .overlay(
            Group {
                if showCustomAlert {
                    CustomAlertView(
                        type: currentAlertType,
                        requiredCoins: requiredCoins,
                        gachaType: selectedGachaType,
                        isPresented: $showCustomAlert,
                        onConfirm: currentAlertType == .confirmDraw ? {
                            drawCard()
                        } : nil
                    )
                }
                
                if showCollectionInfo {
                    CollectionInfoView(
                        isPresented: $showCollectionInfo,
                        gachaSystem: gachaSystem
                    )
                }
            }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .delete:
                DeveloperDeleteView(refreshTrigger: $refreshTrigger)
            case .unlock:
                UnlockCardSheet(refreshTrigger: $refreshTrigger, gachaSystem: gachaSystem)
            }
        }
        .overlay(
            // Add GotCardView as overlay
            Group {
                if showGotCard, let card = lastDrawnCard {
                    GotCardView(
                        card: card,
                        isDuplicate: isDuplicate,
                        refundAmount: refundAmount,
                        isPresented: $showGotCard
                    )
                }
            }
        )
        .fullScreenCover(isPresented: $showRarityAnimation) {
            // 全屏播放稀有度动画
            RarityAnimationView(
                rarity: currentRarity,
                isPresented: $showRarityAnimation
            )
        }
        .onChange(of: showRarityAnimation) { isShowing in
            // 当稀有度动画关闭时，开始显示卡片
            if !isShowing && lastDrawnCard != nil {
                showCardAfterAnimation()
            }
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
            
            // Get the drawn card rarity and show rarity animation first
            if let drawnCard = gachaSystem.lastDrawnCard {
                currentRarity = drawnCard.rarity
                showRarityAnimation = true
                
                // Store the drawn card data for later use
                lastDrawnCard = drawnCard
                isDuplicate = gachaSystem.lastDrawWasDuplicate
                refundAmount = drawnCard.duplicateRefund
            } else {
                // Fallback to original animation if no card drawn
                withAnimation(.easeInOut(duration: 1.0)) {
                    isSpinning = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        cardScale = 1.2
                        cardOpacity = 1.0
                        isSpinning = false
                    }
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7).delay(0.5)) {
                        cardScale = 1.0
                    }
                    
                    refreshTrigger.toggle()
                }
            }
        }
    }
    
    private func showCardAfterAnimation() {
        // Start card reveal animation
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
            
            // Trigger refresh after animation completes
            refreshTrigger.toggle()
        }
    }
}

// New component for gacha type selector
struct GachaTypeSelectorView: View {
    @Binding var selectedGachaType: GachaType
    let currentCoins: Int64
    let onDrawCard: (GachaType) -> Void
    
    var body: some View {
            
            // Scrollable gacha type selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 3) {
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
//                        .frame(width: 90, height: 100)
//                        .padding(20)
                    }
                }
            }
    }
}

struct GachaTypeCard: View {
    let gachaType: GachaType
    let isSelected: Bool
    let canAfford: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var shimmerOffset: CGFloat = -200
    @State private var glowIntensity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    // Computed properties to break down complex expressions
    private var backgroundColors: [Color] {
        if canAfford {
            return [
                gachaType.gradientColors.first?.opacity(0.9) ?? .blue,
                gachaType.gradientColors.last?.opacity(0.7) ?? .purple,
                Color.black.opacity(0.2)
            ]
        } else {
            return [
                Color.gray.opacity(0.4),
                Color.gray.opacity(0.2),
                Color.black.opacity(0.3)
            ]
        }
    }
    
    private var shimmerColors: [Color] {
        [
            Color.clear,
            Color.white.opacity(canAfford ? 0.3 : 0.1),
            Color.clear
        ]
    }
    
    private var borderColors: [Color] {
        if canAfford {
            return [
                Color.white.opacity(0.4),
                gachaType.gradientColors.first?.opacity(0.6) ?? .blue,
                Color.white.opacity(0.4)
            ]
        } else {
            return [Color.gray.opacity(0.3)]
        }
    }
    
    private var iconGlowColors: [Color] {
        if canAfford {
            return [
                Color.white.opacity(0.3),
                gachaType.gradientColors.first?.opacity(0.2) ?? .clear
            ]
        } else {
            return [Color.clear]
        }
    }
    
    private var iconForegroundColors: [Color] {
        if canAfford {
            return [
                Color.white,
                Color.white.opacity(0.8),
                gachaType.gradientColors.first?.opacity(0.9) ?? .blue
            ]
        } else {
            return [Color.gray]
        }
    }
    
    private var titleForegroundColors: [Color] {
        if canAfford {
            return [
                Color.white,
                Color.white.opacity(0.9)
            ]
        } else {
            return [Color.gray.opacity(0.7)]
        }
    }
    
    private var costBackgroundColors: [Color] {
        if canAfford {
            return [
                Color.black.opacity(0.6),
                Color.black.opacity(0.4)
            ]
        } else {
            return [Color.gray.opacity(0.5)]
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                RadialGradient(
                    colors: backgroundColors,
                    center: .topLeading,
                    startRadius: 20,
                    endRadius: 160
                )
            )
            .overlay(shimmerOverlay)
            .overlay(borderOverlay)
    }
    
    private var shimmerOverlay: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: shimmerColors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .offset(x: shimmerOffset)
            .clipped()
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                LinearGradient(
                    colors: borderColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 2
            )
    }
    
    private var cardContent: some View {
        VStack(spacing: 12) {
            iconSection
            titleSection
//            subtitleSection
            costSection
        }
        .padding(16)
    }
    
    private var iconSection: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: iconGlowColors,
                        center: .center,
                        startRadius: 5,
                        endRadius: 25
                    )
                )
                .frame(width: 50, height: 50)
            
            Image("\(gachaType.icon)")
                .resizable()
                .frame(width: 66, height: 66)
                .foregroundStyle(
                    LinearGradient(
                        colors: iconForegroundColors,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
            //rotationEffect
//                .rotationEffect(.degrees(rotationAngle))

        }
    }
    
    private var titleSection: some View {
        Text(gachaType.title)
            .font(.system(size: 16, weight: .black, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: titleForegroundColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
            .multilineTextAlignment(.center)
    }
    
    private var subtitleSection: some View {
        Text(gachaType.subtitle)
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundColor(canAfford ? .white.opacity(0.85) : .gray.opacity(0.6))
            .shadow(color: .black.opacity(0.3), radius: 1)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(height: 28)
    }
    
    private var costSection: some View {
        HStack(spacing: 6) {
            coinIcon
            costText
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 2)
        .background(costBackground)
    }
    
    private var coinIcon: some View {
        Image("fishcoin")
            .resizable()
            .frame(width: 28, height: 28)
//            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.yellow, Color.orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: .yellow.opacity(0.5), radius: 2)
    }
    
    private var costText: some View {
        Text("\(gachaType.cost)")
            .font(.system(size: 15, weight: .black, design: .rounded))
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.5), radius: 1)
    }
    
    private var costBackground: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: costBackgroundColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Capsule()
                    .stroke(
                        Color.white.opacity(canAfford ? 0.3 : 0.1),
                        lineWidth: 1
                    )
            )
    }
    
    private var floatingParticles: some View {
        ForEach(0..<6) { i in
            Circle()
                .fill(gachaType.gradientColors.first?.opacity(0.6) ?? .blue)
                .frame(width: CGFloat.random(in: 2...4))
                .position(
                    x: CGFloat.random(in: 20...140),
                    y: CGFloat.random(in: 20...140)
                )
                .animation(
                    Animation.easeInOut(duration: Double.random(in: 1...2))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2),
                    value: glowIntensity
                )
        }
    }
    
    var body: some View {
        Button(action: {
            // Enhanced press animation with haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isPressed = false
                }
                onTap()
            }
        }) {
            ZStack {
                // Main card background with enhanced gradients
                cardBackground
                
                // Content
                cardContent
            }
            .frame(width: 160, height: 170)
            .cardModifiers(isPressed: isPressed, isSelected: isSelected, canAfford: canAfford, gachaType: gachaType)
                

        }
        .disabled(!canAfford)
        
        // Enhanced lock overlay with glass effect
        .overlay(
            Group {
                if !canAfford {
                    ZStack {
                        // Glass effect background
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.3))
                            .blur(radius: 1)
                        
                        // Lock icon with enhanced styling
                        VStack(spacing: 4) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.white, Color.gray.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .black.opacity(0.5), radius: 2)
                            
                            Text("Locked")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                                .shadow(color: .black.opacity(0.5), radius: 1)
                        }
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.black.opacity(0.4))
                                .frame(width: 60, height: 60)
                                .blur(radius: 0.5)
                        )
                    }
                }
            }
        )
        .onAppear {
            // Start shimmer animation
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                shimmerOffset = 200
            }
            
            // Start glow animation
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowIntensity = 1.0
            }
            
            // Start rotation animation
            withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

// Extension for card modifiers
extension View {
    @ViewBuilder
    func cardModifiers(isPressed: Bool, isSelected: Bool, canAfford: Bool, gachaType: GachaType) -> some View {
        self
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .opacity(canAfford ? 1.0 : 0.5)
            .shadow(
                color: canAfford ? (gachaType.gradientColors.first?.opacity(0.2) ?? .clear) : .clear,
                radius: 6,
                x: 0,
                y: 4
            )
            .rotation3DEffect(
                .degrees(isPressed ? 5 : 0),
                axis: (x: 1, y: 0, z: 0),
                perspective: 1.0
            )
            .animation(.easeInOut(duration: 0.15), value: isPressed)
    }
}

#Preview {
    GachaView(gachaSystem: GachaSystem())
}
