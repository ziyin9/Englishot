import SwiftUI
import AVFoundation

struct AudioImageMatchingGame: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState

    @FetchRequest(entity: Coin.entity(), sortDescriptors: []) var coinEntities: FetchedResults<Coin>

    @State var AudioImageGameRewardCoins : Int64

    
    @State private var selectedWords: [Word] = []
    @State private var currentWord: Word?
    @State private var currentVocabulary: Vocabulary?
    @State private var shuffledImages: [Word] = []
    @State private var isCorrect: Bool? = nil
    @State private var audioPlayer = AudioPlayer()
    @State private var showLeaveGameView = false
    @State private var isAudioPlaying = false
    @State private var selectedImageIndex: Int? = nil
    @State private var showNextButton = false
    @State private var incorrectSelections: Set<Int> = []
    // Colors
    let backgroundColor = Color(#colorLiteral(red: 0.9490196078, green: 0.9764705882, blue: 0.9882352941, alpha: 1))
    let accentColor = Color(#colorLiteral(red: 0.2196078431, green: 0.5803921569, blue: 0.9882352941, alpha: 1))
    let correctColor = Color.green.opacity(0.2)
    let incorrectColor = Color.red.opacity(0.2)
    let cardColor = Color.white
    
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
            VStack{
                GameHeaderView(
                    title: "Sound & Image",
                    subtitle: "Match the words you hear",
                    colors: [Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)), Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.95, alpha: 1))],
                    showLeaveGameView: $showLeaveGameView
                )
                Spacer()
                Spacer()

                
            }

            VStack(spacing: 20) {
                VStack{
                    
                    // Play audio button
                    Button(action: {
                        // Add haptic feedback
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isAudioPlaying = true
                        }
                        playAudio()
                    }) {
                        HStack(spacing: 12) {
                            // Animated speaker icon
                            Image(systemName: isAudioPlaying ? "speaker.wave.2.fill" : "speaker.wave.2")
                                .font(.system(size: 24))
                                .symbolEffect(.bounce, value: isAudioPlaying)
                                .scaleEffect(isAudioPlaying ? 1.1 : 1.0)
                            
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(accentColor)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .scaleEffect(isAudioPlaying ? 1.02 : 1.0)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.bottom, 10)
                    .onChange(of: isAudioPlaying) { newValue in
                        if !newValue {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                isAudioPlaying = false
                            }
                        }
                    }
                }
                VStack(spacing: 16) {
                    // Image grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(Array(shuffledImages.enumerated()), id: \.element) { index, word in
                            if let imageData = word.itemimage,
                               let uiImage = UIImage(data: imageData) {
                                ZStack {
                                    // Background changes color based on answer
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(backgroundColor(for: index, word: word))
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    
                                    // Image
                                    VStack {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                            .padding(8)
                                    }
                                    
                                    // Selection indicator border
                                    if selectedImageIndex == index || incorrectSelections.contains(index) {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(borderColor(for: index, word: word), lineWidth: 3)
                                    }
                                }
                                .frame(height: 150)
                                .onTapGesture {
                                    // Only allow selection if not already marked as incorrect
                                    // and not showing the next button yet
                                    if !showNextButton && !incorrectSelections.contains(index) {
                                        selectedImageIndex = index
                                        // Add haptic feedback
                                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                        impactMed.impactOccurred()
                                        
                                        // Check answer immediately
                                        checkAnswer(selectedWord: word, at: index)
                                    }
                                }
                                .opacity(incorrectSelections.contains(index) ? 0.7 : 1.0)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                if showNextButton {
                    Button(action: {
                        // Generate new question
                        setupGame()
                        // Reset states
                        selectedImageIndex = nil
                        isCorrect = nil
                        showNextButton = false
                        incorrectSelections.removeAll()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(accentColor)
                                .frame(height: 50)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Next Question")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom,50)
                }
            }
            .padding()
            
            // Leave game overlay
            if showLeaveGameView {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                LeaveGameView(
                    showLeaveGameView: $showLeaveGameView,
                    message: "不會保留遊戲紀錄確定要離開嗎？",
                    button1Title: "離開遊戲",
                    button1Action: {
                        print("離開遊戲被點擊")
                        dismiss()
                    },
                    button2Title: "繼續遊戲",
                    button2Action: {
                        showLeaveGameView = false
                        print("繼續遊戲被點擊")
                    }
                )
                .zIndex(1)
            }
            if uiState.isCoinVisible {
                CoinDisplayView(coins: currentCoins)
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
    }
    
    // Background color based on the answer state
    private func backgroundColor(for index: Int, word: Word) -> Color {
        if selectedImageIndex == index && isCorrect == true {
            // If this is the selected image and it's correct
            return Color.green.opacity(0.2) // Correct answer
        } else if incorrectSelections.contains(index) {
            // If this is a previously selected incorrect image
            return Color.red.opacity(0.2) // Wrong answer
        }
        
        // Default background
        return cardColor
    }
    
    // Border color based on answer
    private func borderColor(for index: Int, word: Word) -> Color {
        if selectedImageIndex == index && isCorrect == true {
            return Color.green // Correct answer
        } else if incorrectSelections.contains(index) {
            return Color.red // Wrong answer
        }
        return accentColor // Default selection color
    }
    
    private func setupGame() {
        // Fetch all words from CoreData
        if let allWords = fetchWords() {
            // Filter words that have images
            let validWords = allWords.filter { word in
                word.itemimage != nil
            }
            
            // Randomly select 6 words (or whatever number fits your grid)
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
    
    private func checkAnswer(selectedWord: Word, at index: Int) {
        // Determine if answer is correct
        if selectedWord == currentWord {
            // Correct answer
            isCorrect = true
            addCoin(by:AudioImageGameRewardCoins)

            // Add success haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Show next button after short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    showNextButton = true
                }
            }
        } else {
            // Wrong answer - add to incorrect selections
            incorrectSelections.insert(index)
            
            // Add error haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            // Reset selection index so they can try again
            selectedImageIndex = nil
        }
    }
}

#Preview {
    AudioImageMatchingGame(AudioImageGameRewardCoins:10)
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
