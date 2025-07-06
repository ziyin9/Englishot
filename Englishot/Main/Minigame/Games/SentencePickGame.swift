import SwiftUI
import AVFoundation

struct SentencePickGame: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    @FetchRequest(entity: Coin.entity(), sortDescriptors: []) var coinEntities: FetchedResults<Coin>
    
    @State private var selectedWords: [Word] = []
    @State private var currentWord: Word?
    @State private var currentVocabulary: Vocabulary?
    @State private var shuffledImages: [Word] = []
    @State private var isCorrect: Bool? = nil
    @State private var showLeaveGameView = false
    @State private var sentenceWithBlank = ""
    @State private var completedSentence = ""
    @State private var isFirstAttempt = true
    @State private var selectedImageIndex: Int? = nil
    @State private var animateSuccess = false
    @State private var showNextButton = false
    
    let SentencePickGameRewardCoins: Int64
    
    // Haptic feedback generators
    private let successFeedback = UINotificationFeedbackGenerator()
    private let errorFeedback = UINotificationFeedbackGenerator()
    private let selectionFeedback = UIImpactFeedbackGenerator(style: .light)
    
    private var currentCoins: Int64 {
        coinEntities.first?.amount ?? 0
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.9, green: 0.4, blue: 0.6, alpha: 1)).opacity(0.1),
                    Color(#colorLiteral(red: 0.95, green: 0.6, blue: 0.8, alpha: 1)).opacity(0.1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            
            VStack(spacing: 20) {
                GameHeaderView(
                    title: "Sentence & Picture",
                    subtitle: "Choose the correct picture to complete the sentence",
                    colors: [Color(#colorLiteral(red: 0.9, green: 0.4, blue: 0.6, alpha: 1)), Color(#colorLiteral(red: 0.95, green: 0.6, blue: 0.8, alpha: 1))],
                    showLeaveGameView: $showLeaveGameView
                )
                
                if let currentWord = currentWord {
                    // Sentence display with blank
                    VStack(spacing: 15) {
                        Text("完成下面的句子：")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.5, blue: 0.8, alpha: 1)))
                        
                        // Sentence with blank or completed
                        Text(isCorrect == true ? completedSentence : sentenceWithBlank)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.3, blue: 0.7, alpha: 1)))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .shadow(color: Color(#colorLiteral(red: 0.9, green: 0.4, blue: 0.6, alpha: 1)).opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                            .animation(.easeInOut(duration: 0.5), value: isCorrect)
                    }
                    .padding(.horizontal, 20)
                    
                    // Instruction
                    Text("選擇正確的圖片")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.5, blue: 0.8, alpha: 1)))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Images grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 15),
                        GridItem(.flexible(), spacing: 15),
                        GridItem(.flexible(), spacing: 15)
                    ], spacing: 20) {
                        ForEach(Array(shuffledImages.enumerated()), id: \.offset) { index, word in
                            if let imageData = word.itemimage,
                               let uiImage = UIImage(data: imageData) {
                                
                                ZStack {
                                    // Image card with border effects
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(getBorderColor(for: index, word: word), lineWidth: getBorderWidth(for: index, word: word))
                                        )
                                        .shadow(color: Color(#colorLiteral(red: 0.9, green: 0.4, blue: 0.6, alpha: 1)).opacity(0.2), radius: 8, x: 0, y: 4)
                                    
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                        .frame(height: 180) //
                                }
                                .frame(height: 180) //
                                .scaleEffect(selectedImageIndex == index ? 0.95 : 1.0)
                                .onTapGesture {
                                    if isCorrect == nil {
                                        // Light haptic feedback on selection
                                        selectionFeedback.impactOccurred()
                                        
                                        selectedImageIndex = index
                                        checkAnswer(selectedWord: word, index: index)
                                    }
                                }
                                .opacity(getImageOpacity(for: index, word: word))
                                .animation(.easeInOut(duration: 0.3), value: isCorrect)
                                .animation(.easeInOut(duration: 0.1), value: selectedImageIndex)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    // Next button (only visible after correct answer)
                    if showNextButton {
                        Button(action: {
                            // Light haptic feedback for button tap
                            selectionFeedback.impactOccurred()
                            setupNextQuestion()
                        }) {
                            HStack(spacing: 10) {
                                Text("Next Question")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(#colorLiteral(red: 0.9, green: 0.4, blue: 0.6, alpha: 1)), Color(#colorLiteral(red: 0.95, green: 0.6, blue: 0.8, alpha: 1))],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color(#colorLiteral(red: 0.9, green: 0.4, blue: 0.6, alpha: 1)).opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                        }
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showNextButton)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
            
            // Success overlay using ZStack - positioned above everything
            if let isCorrect = isCorrect, isCorrect {
                VStack {
                    Spacer()
                    Text("Correct! 🎉")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(Color(#colorLiteral(red: 0.9, green: 0.4, blue: 0.6, alpha: 1)))
                        .scaleEffect(animateSuccess ? 1.2 : 0.8)
                        .opacity(animateSuccess ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateSuccess)
                    Spacer()
                }
                .zIndex(10) // 確保correct在最上層
                .onAppear {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        animateSuccess = true
                    }
                    
                    // Show next button after animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            showNextButton = true
                        }
                    }
                }
            }
            
            // Leave game overlay
            if showLeaveGameView {
                LeaveGameView(
                    showLeaveGameView: $showLeaveGameView,
                    message: "離開遊戲？",
                    button1Title: "離開遊戲",
                    button1Action: {
                        dismiss()
                        uiState.isNavBarVisible = true

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
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    showLeaveGameView = true
                }
            }
        }
        .onAppear {
            setupGame()
            uiState.isNavBarVisible = false
        }
    }
    
    private func getBorderColor(for index: Int, word: Word) -> Color {
        guard let selectedIndex = selectedImageIndex else { return Color.clear }
        
        if selectedIndex == index {
            if let correct = isCorrect {
                return correct ? Color.green : Color.red
            }
        }
        return Color.clear
    }
    
    private func getBorderWidth(for index: Int, word: Word) -> CGFloat {
        guard let selectedIndex = selectedImageIndex else { return 0 }
        
        if selectedIndex == index && isCorrect != nil {
            return 4
        }
        return 0
    }
    
    private func getImageOpacity(for index: Int, word: Word) -> Double {
        if isCorrect == true {
            return word == currentWord ? 1.0 : 0.5
        }
        return 1.0
    }
    
    private func setupGame() {
        setupNextQuestion()
    }
    
    private func setupNextQuestion() {
        // Reset states
        isCorrect = nil
        isFirstAttempt = true
        selectedImageIndex = nil
        animateSuccess = false
        showNextButton = false
        
        // Fetch all words from CoreData
        if let allWords = fetchWords() {
            // Filter words that have images and corresponding vocabulary
            let validWords = allWords.filter { word in
                word.itemimage != nil && vocabularyList.contains { $0.E_word == word.word }
            }
            
            // Ensure we have at least 3 words for the game
            guard validWords.count >= 3 else { return }
            
            // Randomly select 3 words
            selectedWords = Array(validWords.shuffled().prefix(3))
            
            // Select one word as the current word and find its matching vocabulary item
            if let selectedWord = selectedWords.randomElement() {
                if let vocabularyItem = vocabularyList.first(where: { $0.E_word == selectedWord.word }) {
                    currentWord = selectedWord
                    currentVocabulary = vocabularyItem
                    
                    // Create sentence with blank
                    createSentenceWithBlank(from: vocabularyItem.exSentence, targetWord: selectedWord.word!)
                }
            }
            
            // Shuffle all images for display
            shuffledImages = selectedWords.shuffled()
        }
    }
    
    private func createSentenceWithBlank(from sentence: String, targetWord: String) {
        // Create blank version by replacing the target word with underscores
        let wordCount = targetWord.count
        let blank = String(repeating: "_", count: wordCount)
        
        // Try to replace the exact word (case-insensitive)
        let lowercaseSentence = sentence.lowercased()
        let lowercaseTargetWord = targetWord.lowercased()
        
        if lowercaseSentence.contains(lowercaseTargetWord) {
            // Replace the word with blank, preserving case
            let range = sentence.range(of: targetWord, options: .caseInsensitive)
            if let range = range {
                sentenceWithBlank = sentence.replacingCharacters(in: range, with: blank)
                completedSentence = sentence
            } else {
                // Fallback: just replace with blank at the end
                sentenceWithBlank = sentence.replacingOccurrences(of: targetWord, with: blank, options: .caseInsensitive)
                completedSentence = sentence
            }
        } else {
            // If word not found in sentence, create a simple sentence
            sentenceWithBlank = "This is a \(blank)."
            completedSentence = "This is a \(targetWord)."
        }
    }
    
    private func checkAnswer(selectedWord: Word, index: Int) {
        let correct = selectedWord == currentWord
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isCorrect = correct
        }
        
        if correct {
            // Success haptic feedback
            successFeedback.notificationOccurred(.success)
            
            if isFirstAttempt {
                // Award coins for correct answer
                awardCoins()
            }
        } else {
            // Error haptic feedback
            errorFeedback.notificationOccurred(.error)
            
            isFirstAttempt = false
            
            // Reset selection after showing red border
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedImageIndex = nil
                    isCorrect = nil
                }
            }
        }
    }
    
    private func awardCoins() {
        // Add coins to CoreData
        addCoin(by: Int64(SentencePickGameRewardCoins))
        
        // Show coin reward animation
        uiState.coinRewardAmount = Int(SentencePickGameRewardCoins)
        uiState.showCoinReward = true
        
        // Hide coin reward animation after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            uiState.showCoinReward = false
        }
    }
}

#Preview {
    SentencePickGame(SentencePickGameRewardCoins: 30)
        .environmentObject(UIState())
} 
