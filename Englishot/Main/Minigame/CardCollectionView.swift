import SwiftUI
import AVFoundation

struct CardCollectionView: View {
    @ObservedObject var gashaSystem: GashaSystem
    @Environment(\.dismiss) var dismiss
    @State private var selectedCard: PenguinCard?
    @State private var showCardDetail = false
    @State private var filterRarity: String = "All"
    @State private var audioPlayer: AVPlayer?
    
    private let rarityOptions = ["All", "Common", "Rare", "Epic", "Legendary"]
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var filteredCards: [PenguinCard] {
        let allCards = gashaSystem.collectedCards
        
        if filterRarity == "All" {
            return allCards.sorted { $0.cardName < $1.cardName }
        } else {
            let filtered = allCards.filter { $0.rarity == filterRarity }
            return filtered.sorted { $0.cardName < $1.cardName }
        }
    }
    
    private var completionPercentage: Int {
        let collectedCount = gashaSystem.collectedCards.count
        let totalCount = gashaSystem.availableCards.count
        
        guard totalCount > 0 else { return 0 }
        
        let percentage = Double(collectedCount) / Double(totalCount) * 100
        return Int(percentage)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(#colorLiteral(red: 0.1, green: 0.15, blue: 0.3, alpha: 1)),
                        Color(#colorLiteral(red: 0.2, green: 0.25, blue: 0.4, alpha: 1))
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 15) {
                        Text("🐧 Penguin Collection 🐧")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        // Collection stats
                        HStack(spacing: 20) {
                            VStack(spacing: 5) {
                                Text("\(gashaSystem.collectedCards.count)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.yellow)
                                
                                Text("Collected")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            VStack(spacing: 5) {
                                Text("\(gashaSystem.availableCards.count)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.cyan)
                                
                                Text("Total")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            VStack(spacing: 5) {
                                Text("\(completionPercentage)%")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.green)
                                
                                Text("Complete")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        
                        // Filter by rarity
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(rarityOptions, id: \.self) { rarity in
                                    Button(action: { filterRarity = rarity }) {
                                        Text(rarity)
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(filterRarity == rarity ? .black : .white)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .fill(filterRarity == rarity ? .white : Color.white.opacity(0.2))
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Cards grid
                    if filteredCards.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "rectangle.stack")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.5))
                            
                            Text("No cards in this category")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Keep playing games to collect more penguins!")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(filteredCards) { card in
                                    CollectionCardView(card: card)
                                        .onTapGesture {
                                            selectedCard = card
                                            showCardDetail = true
                                            playCardSound()
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .overlay(
            // Close button
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
        )
        .sheet(isPresented: $showCardDetail) {
            if let card = selectedCard {
                CardDetailView(card: card)
            }
        }
    }
    
    private func playCardSound() {
        // Optional: Play a card selection sound
        guard let url = Bundle.main.url(forResource: "card_select", withExtension: "mp3") else { return }
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
    }
}

struct CollectionCardView: View {
    let card: PenguinCard
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // Card background
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
                            .stroke(card.rarityColor, lineWidth: 2)
                    )
                    .shadow(color: card.rarityColor.opacity(0.4), radius: 8, x: 0, y: 4)
                
                VStack(spacing: 8) {
                    // Rarity badge
                    HStack {
                        Spacer()
                        
                        Text(card.rarity.uppercased())
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(card.rarityColor)
                            )
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                    
                    Spacer()
                    
                    // Penguin image
                    Image("penguinnn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(card.rarityColor, lineWidth: 2)
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
                
                // Times drawn indicator
                if card.timesDrawn > 1 {
                    VStack {
                        HStack {
                            Text("×\(card.timesDrawn)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.orange)
                                )
                            
                            Spacer()
                        }
                        .padding(.leading, 8)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                }
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

struct CardDetailView: View {
    let card: PenguinCard
    @Environment(\.dismiss) var dismiss
    @State private var audioPlayer: AVPlayer?
    @State private var isPlayingAudio = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    card.rarityColor.opacity(0.3),
                    Color.black.opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Large card image
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [.white, card.rarityColor.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 280, height: 350)
                            .shadow(color: card.rarityColor.opacity(0.6), radius: 20, x: 0, y: 10)
                        
                        VStack(spacing: 15) {
                            // Rarity indicator
                            Text(card.rarity.uppercased())
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(card.rarityColor)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .stroke(card.rarityColor, lineWidth: 2)
                                        .background(Capsule().fill(card.rarityColor.opacity(0.2)))
                                )
                            
                            // Large penguin image
                            Image("penguinnn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(card.rarityColor, lineWidth: 4)
                                )
                            
                            Text(card.cardName)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(30)
                    }
                    
                    // Card details
                    VStack(spacing: 20) {
                        // Words section
                        HStack(spacing: 30) {
                            VStack(spacing: 8) {
                                Text("English")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(card.englishWord)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 8) {
                                Text("中文")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(card.chineseWord)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        
                        // Audio pronunciation button
                        Button(action: playPronunciation) {
                            HStack(spacing: 10) {
                                Image(systemName: isPlayingAudio ? "speaker.wave.2.fill" : "speaker.wave.1.fill")
                                    .font(.system(size: 18))
                                
                                Text("Play Pronunciation")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(card.rarityColor.opacity(0.8))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .scaleEffect(isPlayingAudio ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: isPlayingAudio)
                        
                        // Voice line
                        Text("\"\(card.voiceLine)\"")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(card.rarityColor.opacity(0.6))
                            )
                            .multilineTextAlignment(.center)
                        
                        // Description
                        Text(card.descriptionText)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 25)
                            .multilineTextAlignment(.center)
                        
                        // Collection info
                        VStack(spacing: 10) {
                            if let dateCollected = card.dateCollected {
                                Text("Collected on: \(dateCollected, style: .date)")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            if card.timesDrawn > 1 {
                                Text("Drawn \(card.timesDrawn) times")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                .padding(.top, 60)
            }
        }
        .overlay(
            // Close button
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 3)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
        )
    }
    
    private func playPronunciation() {
        guard let url = URL(string: card.pronunciationURL) else { return }
        
        isPlayingAudio = true
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
        
        // Reset audio state after a reasonable duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isPlayingAudio = false
        }
    }
}

#Preview {
    CardCollectionView(gashaSystem: GashaSystem())
} 