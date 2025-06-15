import SwiftUI
import AVFoundation

struct CardCollectionView: View {
    @ObservedObject var gachaSystem: GachaSystem
    @Environment(\.dismiss) var dismiss
    @State private var selectedCard: PenguinCard?
    @State private var showCardDetail = false
    @State private var filterRarity: String = "All"
    @State private var filterType: String = "All"
    @State private var audioPlayer: AVPlayer?
    
    private let rarityOptions = ["All", "Common", "Rare", "Epic", "Legendary"]
    private let typeOptions = ["All", "Emotion", "Profession", "Activity"]
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var filteredCards: [PenguinCard] {
        let allCards = gachaSystem.collectedCards
        
        var filtered = allCards
        
        if filterRarity != "All" {
            filtered = filtered.filter { $0.rarity == filterRarity }
        }
        
        if filterType != "All" {
            filtered = filtered.filter { $0.cardType == filterType }
        }
        
        return filtered.sorted { $0.cardName < $1.cardName }
    }
    
    private var completionPercentage: Int {
        let collectedCount = gachaSystem.collectedCards.count
        let totalCount = gachaSystem.availableCards.count
        
        guard totalCount > 0 else { return 0 }
        
        let percentage = Double(collectedCount) / Double(totalCount) * 100
        return Int(percentage)
    }
    
    var body: some View {
        NavigationView {
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
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 15) {
                        Text("🐧 Penguin Collection 🐧")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        // Collection stats
                        HStack(spacing: 20) {
                            StatView(
                                title: "Collected",
                                value: "\(gachaSystem.collectedCards.count)/\(gachaSystem.availableCards.count)",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                            
                            StatView(
                                title: "Completion",
                                value: "\(completionPercentage)%",
                                icon: "chart.pie.fill",
                                color: .blue
                            )
                        }
                        .padding(.horizontal)
                        
                        // Filter controls
                        HStack(spacing: 15) {
                            // Rarity filter
                            Picker("Rarity", selection: $filterRarity) {
                                ForEach(rarityOptions, id: \.self) { rarity in
                                    Text(rarity).tag(rarity)
                                }
                            }
                            .pickerStyle(.menu)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.2))
                            )
                            
                            // Type filter
                            Picker("Type", selection: $filterType) {
                                ForEach(typeOptions, id: \.self) { type in
                                    Text(type).tag(type)
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
                    .padding(.bottom)
                    
                    // Card grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(filteredCards) { card in
                                CollectionCardView(card: card)
                                    .onTapGesture {
                                        selectedCard = card
                                        showCardDetail = true
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showCardDetail) {
                if let card = selectedCard {
                    CardDetailView(card: card)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CollectionCardView: View {
    let card: PenguinCard
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // Enhanced card background with ice theme
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [.white, card.rarityColor.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                LinearGradient(
                                    colors: [.white, card.rarityColor.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: card.rarityColor.opacity(0.4), radius: 8, x: 0, y: 4)
                
                // Ice crystal pattern
                ForEach(0..<4) { i in
                    Image(systemName: "snowflake")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.2))
                        .rotationEffect(.degrees(Double(i) * 90))
                        .offset(x: 60, y: 60)
                }
                
                VStack(spacing: 8) {
                    // Type and rarity badges
                    HStack {
                        // Type badge
                        HStack(spacing: 4) {
                            Image(systemName: card.cardTypeIcon)
                                .font(.system(size: 8))
                            Text(card.cardType)
                                .font(.system(size: 8, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(card.cardTypeColor)
                        )
                        
                        Spacer()
                        
                        // Rarity badge
                        Text(card.rarity.uppercased())
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(card.rarityColor)
                            )
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 8)
                    
                    Spacer()
                    
                    // Penguin image
                    Image(card.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white, card.rarityColor.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                    
                    // Card name
                    Text(card.cardName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    // English word
                    Text(card.englishWord)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(card.rarityColor)
                    
                    Spacer()
                }
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                withAnimation {
                    isPressed = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isPressed = false
                    }
                }
            }
        }
    }
}

#Preview {
    CardCollectionView(gachaSystem: GachaSystem())
}
