import SwiftUI

struct MemoryCard: Identifiable {
    let id = UUID()
    let word: String
    let image: Data?
    var isFaceUp = false
    var isMatched = false
}

struct MemoryGameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var uiState: UIState
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    
    @State private var cards: [MemoryCard] = []
    @State private var selectedCards: [MemoryCard] = []
    @State private var isProcessing = false
    @State private var matchedPairs = 0
    @State private var showGameOver = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.3),
                        Color.blue.opacity(0.1),
                        Color.blue.opacity(0.2),
                        Color.purple.opacity(0.1),
                        Color.blue.opacity(0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Memory Game")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.7), .blue.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.top, 40)
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    Text("Matched Pairs: \(matchedPairs)/5")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    handleCardTap(card)
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarItems(leading: Button("Back") {
                dismiss()
            })
            .onAppear {
                setupGame()
            }
            .alert("Game Over!", isPresented: $showGameOver) {
                Button("Play Again") {
                    setupGame()
                }
                Button("Back to Menu") {
                    dismiss()
                }
            } message: {
                Text("Congratulations! You've matched all the pairs!")
            }
        }
    }
    
    private func setupGame() {
        // Get 5 random words from wordEntities
        let randomWords = Array(wordEntities.shuffled().prefix(5))
        
        // Create pairs of cards (word and image)
        cards = randomWords.flatMap { wordEntity in
            [
                MemoryCard(word: wordEntity.word ?? "", image: wordEntity.itemimage),
                MemoryCard(word: wordEntity.word ?? "", image: wordEntity.itemimage)
            ]
        }.shuffled()
        
        matchedPairs = 0
        selectedCards = []
        isProcessing = false
    }
    
    private func handleCardTap(_ card: MemoryCard) {
        guard !isProcessing && !card.isMatched && !card.isFaceUp else { return }
        
        // Flip the card
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index].isFaceUp = true
            selectedCards.append(cards[index])
        }
        
        // Check for match when two cards are selected
        if selectedCards.count == 2 {
            isProcessing = true
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        
        if card1.word == card2.word {
            // Match found
            if let index1 = cards.firstIndex(where: { $0.id == card1.id }),
               let index2 = cards.firstIndex(where: { $0.id == card2.id }) {
                cards[index1].isMatched = true
                cards[index2].isMatched = true
                matchedPairs += 1
                
                if matchedPairs == 5 {
                    showGameOver = true
                }
            }
        } else {
            // No match - flip cards back after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let index1 = cards.firstIndex(where: { $0.id == card1.id }),
                   let index2 = cards.firstIndex(where: { $0.id == card2.id }) {
                    cards[index1].isFaceUp = false
                    cards[index2].isFaceUp = false
                }
            }
        }
        
        // Clear selected cards and allow new selection
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            selectedCards = []
            isProcessing = false
        }
    }
}

struct CardView: View {
    let card: MemoryCard
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 5)
                
                if card.isMatched {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.3))
                }
                
                if let imageData = card.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                } else {
                    Text(card.word)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .shadow(radius: 5)
            }
        }
        .frame(height: 120)
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.easeInOut(duration: 0.3), value: card.isFaceUp)
    }
}

#Preview {
    MemoryGameView()
        .environmentObject(GameState())
        .environmentObject(UIState())
} 