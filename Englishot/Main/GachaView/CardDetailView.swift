import SwiftUI
import CoreData

struct CardDetailView: View {
    let card: PenguinCard
    @Environment(\.dismiss) var dismiss
    @State private var isPlayingAudio = false
    @State private var isCollected = false
    
    var body: some View {
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
            
            // Animated snowflakes
            ForEach(0..<20) { _ in
                Image(systemName: "snowflake")
                    .font(.system(size: CGFloat.random(in: 8...15)))
                    .foregroundColor(.white.opacity(0.2))
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
            
            ScrollView {
                VStack(spacing: 25) {
                    // Card image
                    if isCollected {
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
                    } else {
                        // Locked card placeholder
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.1), .white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 200, height: 200)
                            
                            Image(systemName: "penguin")
                                .font(.system(size: 100))
                                .foregroundColor(.gray)
                            
                            Image(systemName: "lock.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                                .offset(x: 60, y: 60)
                        }
                    }
                    
                    // Word information
                    VStack(spacing: 15) {
                        // English word with pronunciation button
                        HStack(spacing: 15) {
                            Text(card.englishWord)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            if isCollected {
                                Button(action: {
                                    // Play pronunciation
                                    isPlayingAudio = true
                                    // Add audio playback logic here
                                }) {
                                    Image(systemName: isPlayingAudio ? "speaker.wave.2.fill" : "speaker.wave.2")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .fill(Color.white.opacity(0.2))
                                        )
                                }
                            }
                        }
                        
                        // Chinese translation
                        Text(card.chineseWord)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Card type and rarity
                        HStack(spacing: 15) {
                            // Type badge
                            HStack(spacing: 5) {
                                Image(systemName: card.cardTypeIcon)
                                Text(card.cardType)
                            }
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(card.cardTypeColor)
                            )
                            
                            // Rarity badge
                            HStack(spacing: 5) {
                                Text(card.rarityIcon)
                                Text(card.rarity)
                            }
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(card.rarityColor)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Description
                    if isCollected {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Description")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(card.descriptionText)
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.1))
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 30)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            checkIfWordIsCollected()
        }
    }
    
    private func checkIfWordIsCollected() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<PenguinCardWord> = PenguinCardWord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "penguinword == %@", card.englishWord)
        
        do {
            let results = try context.fetch(fetchRequest)
            isCollected = !results.isEmpty
        } catch {
            print("Failed to check if word is collected: \(error)")
            isCollected = false
        }
    }
}

#Preview {
    CardDetailView(card: PenguinCard(
        cardName: "Happy Penguin",
        englishWord: "happy",
        chineseWord: "開心",
        pronunciationURL: "https://example.com/happy.mp3",
        emotionType: "happy",
        rarity: "Snowflake",
        imageName: "penguin_happy",
        descriptionText: "A joyful penguin with a bright smile!",
        voiceLine: "I'm so happy!",
        cardType: "Emotion"
    ))
} 
