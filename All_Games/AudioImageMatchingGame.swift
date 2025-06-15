import SwiftUI
import AVFoundation

class AudioPlayer: ObservableObject {
    var player: AVPlayer?
    
    func playSound(from url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }
}

struct AudioImageMatchingGame: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(entity: Coin.entity(), sortDescriptors: []) var coinEntities: FetchedResults<Coin>
    
    @State private var selectedWords: [Word] = []
    @State private var currentWord: Word?
    @State private var currentVocabulary: Vocabulary?
    @State private var shuffledImages: [Word] = []
    @State private var isCorrect = false
    @State private var showResult = false
    @State private var score = 0
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var currentRound = 1
    @State private var totalRounds = 5
    @State private var showGameCompletedAlert = false
    @State private var showLeaveGameView = false
    
    private var currentCoins: Int64 {
        coinEntities.first?.amount ?? 0
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)).opacity(0.1),
                    Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.95, alpha: 1)).opacity(0.1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Coin Display
            if uiState.isCoinVisible {
                CoinDisplayView(coins: currentCoins)
            }
            
            VStack(spacing: 20) {
                GameHeaderView(
                    title: "Sound & Image",
                    subtitle: "Match the words you hear",
                    colors: [Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)), Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.95, alpha: 1))],
                    showLeaveGameView: $showLeaveGameView
                )
                
                // Game progress
                HStack {
                    Text("Round \(currentRound) of \(totalRounds)")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)))
                    
                    Spacer()
                    
                    Text("Score: \(score)")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)))
                }
                .padding(.horizontal, 25)
                
                if let currentWord = currentWord {
                    // Instruction
                    Text("Listen to the word and select the correct image")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.5, blue: 0.8, alpha: 1)))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Audio play button
                    Button(action: {
                        playAudio()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 24))
                            
                            Text("Play Audio")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 15)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)), Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.95, alpha: 1))],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)).opacity(0.4), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.vertical, 10)
                    
                    // Images grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 15),
                        GridItem(.flexible(), spacing: 15),
                        GridItem(.flexible(), spacing: 15)
                    ], spacing: 20) {
                        ForEach(shuffledImages, id: \.self) { word in
                            if let imageData = word.itemimage,
                               let uiImage = UIImage(data: imageData) {
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                        .shadow(color: Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)).opacity(0.2), radius: 8, x: 0, y: 4)
                                    
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                }
                                .frame(height: 120)
                                .onTapGesture {
                                    checkAnswer(selectedWord: word)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                }
                
                Spacer()
            }
            .padding(.vertical)
            
            // Leave game overlay
            if showLeaveGameView {
                LeaveGameView(
                    showLeaveGameView: $showLeaveGameView,
                    message: "離開遊戲？",
                    button1Title: "離開遊戲",
                    button1Action: {
                        dismiss()
                    },
                    button2Title: "繼續遊戲",
                    button2Action: {
                        showLeaveGameView = false
                    }
                )
                .zIndex(1)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBar) {
                BackButton {
                    showLeaveGameView = true
                }
            }
        }
        .onAppear {
            setupGame()
        }
        .alert(isPresented: $showResult) {
            Alert(
                title: Text(isCorrect ? "Correct! 🎉" : "Try Again 💪"),
                message: Text(isCorrect ? "Great job!" : "Keep practicing!"),
                dismissButton: .default(Text("Next")) {
                    if isCorrect {
                        score += 1
                    }
                    if currentRound < totalRounds {
                        currentRound += 1
                        setupGame()
                    } else {
                        showGameCompleted()
                    }
                }
            )
        }
        .alert(isPresented: $showGameCompletedAlert) {
            Alert(
                title: Text("Game Completed! 🎊"),
                message: Text("Your final score: \(score) out of \(totalRounds)"),
                primaryButton: .default(Text("Play Again")) {
                    score = 0
                    currentRound = 1
                    setupGame()
                },
                secondaryButton: .default(Text("Exit")) {
                    dismiss()
                }
            )
        }
    }
    
    private func setupGame() {
        // Fetch all words from CoreData
        if let allWords = fetchWords() {
            // Filter words that have images
            let validWords = allWords.filter { word in
                word.itemimage != nil
            }
            
            // Randomly select 6 words
            selectedWords = Array(validWords.shuffled().prefix(6))
            
            // Select one word as the current word and find its matching vocabulary item
            if let selectedWord = selectedWords.randomElement() {
                // Find the matching vocabulary item
                if let vocabularyItem = vocabularyList.first(where: { $0.E_word == selectedWord.word }) {
                    currentWord = selectedWord
                    currentVocabulary = vocabularyItem
                }
            }
            
            // Shuffle all images for display
            shuffledImages = selectedWords.shuffled()
        }
    }
    
    private func playAudio() {
        guard let vocabularyItem = currentVocabulary,
              let audioURL = URL(string: vocabularyItem.audioURL) else {
            print("Invalid audio URL")
            return
        }
        
        audioPlayer.playSound(from: audioURL)
    }
    
    private func checkAnswer(selectedWord: Word) {
        isCorrect = selectedWord == currentWord
        showResult = true
    }
    
    private func showGameCompleted() {
        showGameCompletedAlert = true
    }
}

#Preview {
    AudioImageMatchingGame()
} 