import SwiftUI

// MemoryCard資料結構
struct MemoryCard: Identifiable {
    let id = UUID()
    let word: String
    let image: Data?
    var isFaceUp = false
    var isMatched = false
    var isShowingWord = false  // 是否顯示英文單字
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
    @State private var showLeaveGameView = false // 控制顯示離開遊戲視圖

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
                
                VStack(spacing: 15) {
                    Text("Memory Game")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.7), .blue.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                        .padding(.top, 20)
                    
                    Text("Matched Pairs: \(matchedPairs)/6")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    handleCardTap(card)
                                }
                        }
                    }
                    .padding()
                    
                }//vs
                if showLeaveGameView {
                    LeaveGameView(
                        showLeaveGameView: $showLeaveGameView,
                        message: "不會保留遊戲紀錄確定要離開嗎？",
                        button1Title: "離開遊戲",
                        button1Action: {
                            print("離開遊戲被點擊")
                            dismiss() // 離開遊戲的動作
                        },
                        button2Title: "繼續遊戲",
                        button2Action: {
                            showLeaveGameView = false
                            print("繼續遊戲被點擊")
                        }
                    )
                    .transition(.opacity)
                    .zIndex(1)
                }
                if showGameOver {
                    
                    LeaveGameView(showLeaveGameView: $showGameOver, message: "Good Job!", button1Title: "離開遊戲", button1Action: { dismiss() }, button2Title: "再玩一次", button2Action: {setupGame() })
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton {
                        showLeaveGameView = true
                    }
                }
            }
            .onAppear {
                setupGame()
            }
//
//            .alert("Game Over!", isPresented: $showGameOver) {
//                Button("Play Again") {
//                    setupGame()
//                }
//                Button("Back to Menu") {
//                    dismiss()
//                }
//            } message: {
//                Text("Congratulations! You've matched all the pairs!")
//            }
            
        }
    }
    
    // 初始化遊戲
    private func setupGame() {
        // 隨機選取5個單字
        let randomWords = Array(wordEntities.shuffled().prefix(6))
        
        // 創建每對卡片（英文單字和圖片）
        cards = randomWords.flatMap { wordEntity in
            [
                MemoryCard(word: wordEntity.word ?? "", image: wordEntity.itemimage, isShowingWord: true), // 顯示英文單字
                MemoryCard(word: wordEntity.word ?? "", image: wordEntity.itemimage, isShowingWord: false) // 顯示圖片
            ]
        }.shuffled()
        
        matchedPairs = 0
        selectedCards = []
        isProcessing = false
        showGameOver = false
    }
    
    // 處理卡片點擊
    private func handleCardTap(_ card: MemoryCard) {
        guard !isProcessing && !card.isMatched && !card.isFaceUp else { return }
        
        // 翻轉卡片
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index].isFaceUp = true
            selectedCards.append(cards[index])
        }
        
        // 檢查是否選擇了兩張卡片並且它們是否匹配
        if selectedCards.count == 2 {
            isProcessing = true
            checkForMatch()
        }
    }
    
    // 檢查配對
    private func checkForMatch() {
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        
        if card1.word == card2.word {
            // 配對成功
            if let index1 = cards.firstIndex(where: { $0.id == card1.id }),
               let index2 = cards.firstIndex(where: { $0.id == card2.id }) {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                cards[index1].isMatched = true
                cards[index2].isMatched = true
                matchedPairs += 1
                
                if matchedPairs == 6 {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showGameOver = true
                    }
                }
            }
        } else {
            // 配對失敗 - 在延遲後將卡片翻回去
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let index1 = cards.firstIndex(where: { $0.id == card1.id }),
                   let index2 = cards.firstIndex(where: { $0.id == card2.id }) {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error) 
                    cards[index1].isFaceUp = false
                    cards[index2].isFaceUp = false
                }
            }
        }
        
        // 清除選擇的卡片，並允許新的選擇
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            selectedCards = []
            isProcessing = false
        }
    }
}

struct CardView: View {
    let card: MemoryCard
    
    // Snowflake pattern view
    private var snowflakePattern: some View {
        ZStack {
            Image(systemName: "snowflake")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.2))
                .position(x: 10, y: 10)
            Image(systemName: "snowflake")
                .font(.system(size: 8))
                .foregroundColor(.white.opacity(0.2))
                .position(x: 90, y: 100)
            Image("penguinnn")
                .resizable()
                .scaledToFit()
                .frame(width: 70 ,height: 70)
        }
    }
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(radius: 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                
                if card.isMatched {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.2))
                }
                
                // Snowflake pattern overlay for face-up cards
                snowflakePattern
                    .opacity(0.1)
                
                if card.isShowingWord {
                    Text(card.word)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.blue)
                } else {
                    if let imageData = card.image,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.8), .blue.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(radius: 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .overlay(
                        snowflakePattern
                    )
            }
        }
        .frame(height: 130)
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.easeInOut(duration: 0.3), value: card.isFaceUp)
    }
}

// Preview
#Preview {
    MemoryGameView()
        .environmentObject(GameState())
        .environmentObject(UIState())
}
