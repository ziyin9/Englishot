import SwiftUI
import AVFoundation

struct AudioImageMatchingGame: View {
    @Environment(\.dismiss) var dismiss
    
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
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                backgroundColor.edgesIgnoringSafeArea(.all)
                // Game header
                VStack{
                    Text("Audio-Image Matching Game")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)))
                        .padding(.top, 20)
                    // Game instructions
                    Text("Listen to the word and select the correct image")
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)))
                        .padding(.horizontal)
                    // Audio button
                    Button(action: {
                        playAudio()
                        isAudioPlaying = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isAudioPlaying = false
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(accentColor)
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            if isAudioPlaying {
                                // Animated sound waves when playing
                                ZStack {
                                    ForEach(0..<3) { i in
                                        Circle()
                                            .stroke(Color.white.opacity(0.8 - Double(i) * 0.2), lineWidth: 2)
                                            .frame(width: 80 + CGFloat(i * 20), height: 80 + CGFloat(i * 20))
                                            .scaleEffect(isAudioPlaying ? 1.2 : 1)
                                            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: isAudioPlaying)
                                    }
                                }
                            }
                            
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 20)
                    Spacer()
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
                
                VStack(spacing: 16) {
                  
                    
                    if let currentWord = currentWord {
                        
                        // Image grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
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
                                                .frame(height: 110)
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
                        // Next question button - shows only after correct answer
//                        if showNextButton {
//                            Button(action: {
//                                // Generate new question
//                                setupGame()
//                                // Reset states
//                                selectedImageIndex = nil
//                                isCorrect = nil
//                                showNextButton = false
//                                incorrectSelections.removeAll()
//                            }) {
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 25)
//                                        .fill(accentColor)
//                                        .frame(height: 50)
//                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
//                                    
//                                    HStack {
//                                        Image(systemName: "arrow.right.circle.fill")
//                                        Text("Next Question")
//                                            .fontWeight(.bold)
//                                    }
//                                    .foregroundColor(.white)
//                                }
//                            }
//                            .padding()
//                        }

                        
                    }
                }
                .padding(.bottom, 20)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        BackButton {
                            showLeaveGameView = true
                        }
                    }
                }
                
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
    AudioImageMatchingGame()
}
