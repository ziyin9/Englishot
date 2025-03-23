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
    
    var body: some View {
        VStack {
            Text("Audio-Image Matching Game")
                .font(.title)
                .padding()
            
            Text("Round \(currentRound) of \(totalRounds)")
                .font(.headline)
                .padding(.bottom)
            
            if let currentWord = currentWord {
                Text("Listen to the word and select the correct image")
                    .font(.headline)
                    .padding()
                
                Button(action: {
                    playAudio()
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }
                .padding()
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(shuffledImages, id: \.self) { word in
                        if let imageData = word.itemimage,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .onTapGesture {
                                    checkAnswer(selectedWord: word)
                                }
                        }
                    }
                }
                .padding()
            }
            
            Text("Score: \(score)")
                .font(.headline)
                .padding()
        }
        .onAppear {
            setupGame()
        }
        .alert(isPresented: $showResult) {
            Alert(
                title: Text(isCorrect ? "Correct!" : "Try Again"),
                message: Text(isCorrect ? "Great job!" : "Keep practicing!"),
                dismissButton: .default(Text("Next")) {
                    if isCorrect {
                        score += 1
                    }
                    if currentRound < totalRounds {
                        currentRound += 1
                        setupGame()
                    } else {
                        // Game completed
                        showGameCompleted()
                    }
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
        // Show game completion alert
        let alert = UIAlertController(
            title: "Game Completed!",
            message: "Your final score: \(score) out of \(totalRounds)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            // Reset game
            score = 0
            currentRound = 1
            setupGame()
        })
        
        // Present the alert
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
}

#Preview {
    AudioImageMatchingGame()
} 