import SwiftUI
import CoreData

struct SpellingGameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var uiState: UIState
    
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    @FetchRequest(entity: Coin.entity(), sortDescriptors: []) var coinEntities: FetchedResults<Coin>

    @State var SpellingGameRewardCoins : Int64

    
    @State private var currentWord: Word? = nil
    @State private var shuffledLetters: [Letter] = []
    @State private var selectedLetters: [Letter] = []
    @State private var isCorrect: Bool? = nil
    @State private var showNextButton = false
    @State private var shakeTiles = false
    @State private var animateSuccess = false
    @State private var animateFail = false
    @State private var celebrationParticles: [CelebrationParticle] = []
    @State private var showLeaveGameView = false // 控制顯示離開遊戲視圖
    @State private var hideClearButton = false // 立即隱藏Clear按鈕
    
    private var currentCoins: Int64 {
        coinEntities.first?.amount ?? 0
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)).opacity(0.1),
                    Color(#colorLiteral(red: 0.3, green: 0.65, blue: 0.5, alpha: 1)).opacity(0.1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Celebration particles
            ForEach(celebrationParticles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
            
            // Main game content
            VStack(spacing: 12) {
                GameHeaderView(
                    title: "Spelling Fun",
                    subtitle: "Tap letters to spell the word",
                    colors: [Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)), Color(#colorLiteral(red: 0.3, green: 0.65, blue: 0.5, alpha: 1))],
                    showLeaveGameView: $showLeaveGameView
                )
                
                if let word = currentWord {
                    // Word image with fixed size and position
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)).opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        // Image display
                        if let imageData = word.itemimage, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .padding(20)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)).opacity(0.5))
                                .padding(40)
                        }
                    }
                    .frame(width: 266, height: 350)
                    .padding(.bottom, 10)
                    
                    // Selected letters display with horizontal scrolling for long words
                    HStack(spacing: 8) {
                        ForEach(0..<(currentWord?.word?.count ?? 0), id: \.self) { index in
                            if index < selectedLetters.count {
                                LetterTile(letter: selectedLetters[index], isSelected: true)
                                 .scaleEffect(animateSuccess ? 1.1 : 1.0)
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)).opacity(0.3), lineWidth: 2)
                                    .frame(width: 30, height: 45)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)).opacity(0.1))
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 60)
                    .modifier(ShakeEffect(animatableData: shakeTiles ? 1 : 0))
                    
                    // Shuffled letters area with fixed height
                    ZStack {
                        if !showNextButton {
                            VStack(spacing: 10) {
                                // Dynamic row distribution based on letter count
                                let rowCount = shuffledLetters.count > 10 ? 3 : 2
                                let lettersPerRow = shuffledLetters.count / rowCount + (shuffledLetters.count % rowCount > 0 ? 1 : 0)
                                
                                ForEach(0..<rowCount, id: \.self) { rowIndex in
                                    HStack(spacing: 8) {
                                        ForEach(0..<lettersPerRow, id: \.self) { colIndex in
                                            let index = rowIndex * lettersPerRow + colIndex
                                            if index < shuffledLetters.count {
                                                let letter = shuffledLetters[index]
                                                if !selectedLetters.contains(where: { $0.id == letter.id }) {
                                                    LetterTile(letter: letter, isSelected: false)
                                                        .onTapGesture {
                                                            selectLetter(letter)
                                                        }
                                                } else {
                                                    // Use same size as unselected tile to prevent layout shift
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.clear)
                                                        .frame(width: 50, height: 60)
                                                        .opacity(0.3)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 120)
                    .padding(.horizontal)
                    
                    // Fixed position for Clear/Next button container
                    ZStack {
                        // Clear button - hide immediately when answer is being checked
                        if !showNextButton && !hideClearButton {
                            Button(action: {
                                if !selectedLetters.isEmpty {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedLetters.removeLast()
                                        isCorrect = nil
                                        animateSuccess = false
                                        animateFail = false
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "delete.left")
                                    Text("Clear")
                                }
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(selectedLetters.isEmpty ?
                                            Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 0.5)) :
                                            Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)))
                                )
                            }
                            .disabled(selectedLetters.isEmpty)
                            .transition(.opacity)
                        }
                        
                        // Next Word button - in the same position as Clear
                        if showNextButton {
                            Button(action: {
                                loadNewWord()
                            }) {
                                HStack {
                                    Text("Next Word")
                                    Image(systemName: "arrow.right")
                                }
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)))
                                )
                            }
                            .transition(.opacity)
                        }
                    }
                    .frame(height: 50)
                    .padding(.top, 5)
                }
                
                Spacer()
            }
            .padding()
            
            // Success overlay using ZStack - positioned above everything
            if let isCorrect = isCorrect, isCorrect {
                VStack {
                    Spacer()
                    Text("Correct! 🎉")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.3, alpha: 1)))
                        .scaleEffect(animateSuccess ? 1.2 : 0.8)
                        .opacity(animateSuccess ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateSuccess)
                    Spacer()
                }
                .zIndex(10) //確保correct在最上層
                .onAppear {
                    // Use a single smooth animation trigger
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        animateSuccess = true
                    }
                    createCelebrationParticles()
                    
                    // Clean up after animation completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            self.isCorrect = nil
                            self.animateSuccess = false
                        }
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
                        uiState.isNavBarVisible = true
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton {
                    showLeaveGameView = true

                }
            }
        }
        .onAppear {
            loadNewWord()
            uiState.isNavBarVisible = false
                 
        }
    }

    private func loadNewWord() {
        // Reset state
        selectedLetters = []
        shuffledLetters = []
        isCorrect = nil
        showNextButton = false
        animateSuccess = false
        animateFail = false
        celebrationParticles = []
        hideClearButton = false  // 重置Clear按鈕狀態
        
        // Pick a random word
        if wordEntities.count > 0 {
            let randomIndex = Int.random(in: 0..<wordEntities.count)
            currentWord = wordEntities[randomIndex]
            
            if let word = currentWord?.word {
                // Create letter objects with unique IDs
                shuffledLetters = word.map { Letter(character: String($0)) }
                
                // Shuffle letters
                shuffledLetters.shuffle()
            }
        }
    }
    
    private func selectLetter(_ letter: Letter) {
        // Use faster animation for selecting letters
            selectedLetters.append(letter)
            
            // Check if the word is complete
            if selectedLetters.count == currentWord?.word?.count {
                checkAnswer()
            }
    }
    
    private func checkAnswer() {
        guard let correctWord = currentWord?.word else { return }
        
        let enteredWord = selectedLetters.map { $0.character }.joined()
        let isWordCorrect = enteredWord.lowercased() == correctWord.lowercased()
        
        // 立即隱藏Clear按鈕，不管答案對錯
        hideClearButton = true
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isCorrect = isWordCorrect
            
            if isWordCorrect {
                // Award coins for correct answer
                addCoin(by:SpellingGameRewardCoins)
                uiState.coinRewardAmount = Int(SpellingGameRewardCoins)
                uiState.showCoinReward = true
                
                // Consolidate async operations to reduce conflicts
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    uiState.showCoinReward = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showNextButton = true
                    }
                }
            } else {
                // Shake the tiles
                shakeTiles = true
                
                // Reset shake after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    shakeTiles = false
                }
                
                // Clear selected letters after a delay and show Clear button again
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedLetters = []
                        isCorrect = nil
                        animateFail = false
                        hideClearButton = false  // 答錯時重新顯示Clear按鈕
                    }
                }
            }
        }
    }
    
    private func createCelebrationParticles() {
        celebrationParticles = []
        // Reduce particle count from 15 to 8 for better performance
        for _ in 0..<8 {
            let randomX = CGFloat.random(in: 50...UIScreen.main.bounds.width-50)
            let randomY = CGFloat.random(in: 200...UIScreen.main.bounds.height-200)
            
            let colors: [Color] = [.green, .yellow, .blue, .pink, .purple, .orange]
            let randomColor = colors.randomElement() ?? .green
            
            let particle = CelebrationParticle(
                position: CGPoint(x: randomX, y: randomY),
                size: CGFloat.random(in: 6...12),
                color: randomColor,
                opacity: 1.0
            )
            
            celebrationParticles.append(particle)
        }
        
        // Use a simpler, single animation for all particles
        withAnimation(.easeOut(duration: 1.2)) {
            for index in celebrationParticles.indices {
                celebrationParticles[index].opacity = 0
            }
        }
    }
}

struct Letter: Identifiable, Equatable {
    let id = UUID()
    let character: String
    
    static func ==(lhs: Letter, rhs: Letter) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LetterTile: View {
    let letter: Letter
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    isSelected ?
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.2, green: 0.6, blue: 0.3, alpha: 1)),
                            Color(#colorLiteral(red: 0.3, green: 0.7, blue: 0.4, alpha: 1))
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)),
                            Color.white
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isSelected ?
                            Color.white.opacity(0.6) :
                            Color(#colorLiteral(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            
            Text(letter.character.lowercased())
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isSelected ? .white : Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.3, alpha: 1)))
        }
        .frame(width: isSelected ? 30 : 50, height: isSelected ? 45 : 60)
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct CelebrationParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
}
