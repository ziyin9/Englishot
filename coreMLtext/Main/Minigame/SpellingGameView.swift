import SwiftUI
import CoreData

struct SpellingGameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var uiState: UIState
    
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    
    @State private var currentWord: Word? = nil
    @State private var shuffledLetters: [Letter] = []
    @State private var selectedLetters: [Letter] = []
    @State private var isCorrect: Bool? = nil
    @State private var showNextButton = false
    @State private var score = 0
    @State private var roundsPlayed = 0
    @State private var gameOver = false
    @State private var animateSuccess = false
    @State private var animateFail = false
    @State private var shakeTiles = false
    @State private var celebrationParticles: [CelebrationParticle] = []
    
    let totalRounds = 5
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.8, green: 0.95, blue: 0.85, alpha: 1)),
                    Color(#colorLiteral(red: 0.95, green: 1.0, blue: 0.95, alpha: 1))
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
            
            if gameOver {
                gameOverView
            } else {
                gamePlayView
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startGame()
        }
    }
    
    private var gamePlayView: some View {
        VStack(spacing: 20) {
            // Header with progress and back button
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        
                        Text("Exit")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color(#colorLiteral(red: 0.3, green: 0.7, blue: 0.4, alpha: 1)))
                    )
                }
                
                Spacer()
                
                // Score display
                HStack {
                    Text("Score: \(score)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.3, alpha: 1)))
                }
                
                Spacer()
                
                // Round progress
                HStack {
                    Text("Round: \(roundsPlayed)/\(totalRounds)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.5, blue: 0.4, alpha: 1)))
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
            
            if let word = currentWord {
                // Word image
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
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
                            .foregroundColor(.gray)
                            .padding(40)
                    }
                }
                .frame(width: 270, height: 350)
                .padding(.bottom, 20)
                
                // Selected letters display
                HStack(spacing: 8) {
                    ForEach(0..<(currentWord?.word?.count ?? 0), id: \.self) { index in
                        if index < selectedLetters.count {
                            LetterTile(letter: selectedLetters[index], isSelected: true)
                                .scaleEffect(animateSuccess ? 1.1 : 1.0)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                .frame(width: 45, height: 55)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                .modifier(ShakeEffect(animatableData: shakeTiles ? 1 : 0))
                
                // Result feedback
                if let isCorrect = isCorrect {
                    Text(isCorrect ? "Correct! 🎉" : "Try again!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(isCorrect ? Color.green : Color.red)
                        .opacity(isCorrect ? (animateSuccess ? 1 : 0) : (animateFail ? 1 : 0))
                        .scaleEffect(isCorrect ? (animateSuccess ? 1.2 : 0.8) : (animateFail ? 1.2 : 0.8))
                        .padding(.bottom, 20)
                        .onAppear {
                            if isCorrect {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                                    animateSuccess = true
                                }
                                createCelebrationParticles()
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    animateFail = true
                                }
                            }
                        }
                }
                
                // Shuffled letters for selection
                if !showNextButton {
                    VStack(spacing: 15) {
                        HStack(spacing: 10) {
                            ForEach(0..<min(shuffledLetters.count, shuffledLetters.count/2), id: \.self) { index in
                                let letter = shuffledLetters[index]
                                if !selectedLetters.contains(where: { $0.id == letter.id }) {
                                    LetterTile(letter: letter, isSelected: false)
                                        .onTapGesture {
                                            selectLetter(letter)
                                        }
                                } else {
                                    Color.clear
                                        .frame(width: 45, height: 55)
                                }
                            }
                        }
                        
                        HStack(spacing: 10) {
                            ForEach(shuffledLetters.count/2..<shuffledLetters.count, id: \.self) { index in
                                let letter = shuffledLetters[index]
                                if !selectedLetters.contains(where: { $0.id == letter.id }) {
                                    LetterTile(letter: letter, isSelected: false)
                                        .onTapGesture {
                                            selectLetter(letter)
                                        }
                                } else {
                                    Color.clear
                                        .frame(width: 45, height: 55)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                // Clear or next button
                HStack(spacing: 20) {
                    if !selectedLetters.isEmpty && !showNextButton {
                        Button(action: {
                            withAnimation {
                                selectedLetters.removeLast()
                                isCorrect = nil
                                animateSuccess = false
                                animateFail = false
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
                                    .fill(Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)))
                            )
                        }
                    }
                    
                    if showNextButton {
                        Button(action: {
                            nextRound()
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
                                    .fill(Color(#colorLiteral(red: 0.3, green: 0.7, blue: 0.4, alpha: 1)))
                            )
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var gameOverView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Text("Game Over!")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.3, alpha: 1)))
                
                Text("Your Score")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.5, blue: 0.4, alpha: 1)))
            }
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(#colorLiteral(red: 0.3, green: 0.7, blue: 0.4, alpha: 1)),
                                Color(#colorLiteral(red: 0.5, green: 0.8, blue: 0.5, alpha: 1))
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 150, height: 150)
                
                Text("\(score)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Button(action: {
                startGame()
            }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Play Again")
                }
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(#colorLiteral(red: 0.3, green: 0.7, blue: 0.4, alpha: 1)),
                                    Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.5, alpha: 1))
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: Color(#colorLiteral(red: 0.3, green: 0.7, blue: 0.4, alpha: 0.5)), radius: 10, x: 0, y: 5)
            }
            .padding(.top, 20)
            
            Button(action: {
                dismiss()
            }) {
                Text("Back to Games")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.3, alpha: 1)))
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .stroke(Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.3, alpha: 1)), lineWidth: 2)
                    )
            }
            .padding(.top, 10)
        }
        .padding()
    }
    
    private func startGame() {
        score = 0
        roundsPlayed = 0
        gameOver = false
        nextRound()
    }
    
    private func nextRound() {
        guard roundsPlayed < totalRounds else {
            withAnimation {
                gameOver = true
            }
            return
        }
        
        // Reset state
        selectedLetters = []
        shuffledLetters = []
        isCorrect = nil
        showNextButton = false
        animateSuccess = false
        animateFail = false
        celebrationParticles = []
        
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
        withAnimation {
            selectedLetters.append(letter)
            
            // Check if the word is complete
            if selectedLetters.count == currentWord?.word?.count {
                checkAnswer()
            }
        }
    }
    
    private func checkAnswer() {
        guard let correctWord = currentWord?.word else { return }
        
        let enteredWord = selectedLetters.map { $0.character }.joined()
        let isWordCorrect = enteredWord.lowercased() == correctWord.lowercased()
        
        withAnimation {
            isCorrect = isWordCorrect
            
            if isWordCorrect {
                score += 10
                
                // Show next button after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showNextButton = true
                        roundsPlayed += 1
                    }
                }
            } else {
                // Shake the tiles
                shakeTiles = true
                
                // Reset shake after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    shakeTiles = false
                }
                
                // Clear selected letters after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        selectedLetters = []
                        isCorrect = nil
                        animateFail = false
                    }
                }
            }
        }
    }
    
    private func createCelebrationParticles() {
        for _ in 0..<30 {
            let randomX = CGFloat.random(in: 50...UIScreen.main.bounds.width-50)
            let randomY = CGFloat.random(in: 200...UIScreen.main.bounds.height-200)
            
            let colors: [Color] = [.green, .yellow, .blue, .pink, .purple, .orange]
            let randomColor = colors.randomElement() ?? .green
            
            let particle = CelebrationParticle(
                position: CGPoint(x: randomX, y: randomY),
                size: CGFloat.random(in: 5...15),
                color: randomColor,
                opacity: 1.0
            )
            
            celebrationParticles.append(particle)
            
            // Animate particle fading
            withAnimation(Animation.easeOut(duration: 1.5).delay(Double.random(in: 0.1...0.5))) {
                if let index = celebrationParticles.firstIndex(where: { $0.id == particle.id }) {
                    celebrationParticles[index].opacity = 0
                }
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
            
            Text(letter.character.uppercased())
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isSelected ? .white : Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.3, alpha: 1)))
        }
        .frame(width: 45, height: 55)
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

#Preview {
    SpellingGameView()
        .environmentObject(GameState())
        .environmentObject(UIState())
} 
