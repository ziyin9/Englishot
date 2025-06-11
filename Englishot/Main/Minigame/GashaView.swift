import SwiftUI
import AVFoundation

struct GashaView: View {
    @EnvironmentObject var gameState: GameState
    @StateObject private var gashaSystem = GashaSystem()
    @Environment(\.dismiss) var dismiss
    
    @State private var isAnimating = false
    @State private var showCardCollection = false
    @State private var animationPhase = 0
    @State private var sparkleParticles: [SparkleParticle] = []
    @State private var audioPlayer: AVPlayer?
    @State private var showLeaveGameView = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.5
    
    private let drawCost = 100
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.1, blue: 0.3),
                Color(red: 0.2, green: 0.1, blue: 0.4),
                Color(red: 0.3, green: 0.1, blue: 0.5)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var titleGradient: LinearGradient {
        LinearGradient(
            colors: [.white, Color(red: 1, green: 0.8, blue: 0.4), .white],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var coinGradient: LinearGradient {
        LinearGradient(
            colors: [.yellow, .orange, .yellow],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var drawButtonGradient: LinearGradient {
        LinearGradient(
            colors: gameState.coins >= drawCost ? 
                [Color(red: 0.9, green: 0.4, blue: 0.2), Color(red: 0.8, green: 0.2, blue: 0.3)] : 
                [.gray, .gray.opacity(0.6)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var body: some View {
        ZStack {
            // Background
            backgroundGradient
                .ignoresSafeArea()
                .overlay(
                    ParticleOverlay(particles: sparkleParticles)
                )
            
            // Main content
            VStack(spacing: 20) {
                // Header
                HeaderView(
                    isAnimating: isAnimating,
                    titleGradient: titleGradient
                )
                .padding(.top, 40)
                
                // Coin display
                GashaCoinDisplayView(
                    coins: gameState.coins,
                    coinGradient: coinGradient
                )
                
                Spacer()
                
                // Crystal ball
                CrystalBallView(
                    isAnimating: isAnimating,
                    animationPhase: animationPhase,
                    rotationAngle: rotationAngle,
                    scale: scale,
                    glowOpacity: glowOpacity
                )
                .onAppear {
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        scale = 1.05
                        glowOpacity = 0.8
                    }
                }
                
                Spacer()
                
                // Buttons
                ButtonsView(
                    isAnimating: isAnimating,
                    drawCost: drawCost,
                    coins: gameState.coins,
                    collectedCount: gashaSystem.collectedCards.count,
                    drawButtonGradient: drawButtonGradient,
                    onDraw: drawCard,
                    onShowCollection: { showCardCollection = true }
                )
                .padding(.bottom, 40)
            }
            .padding(.horizontal)
            
            // Navigation
            NavigationBar(showLeaveGameView: $showLeaveGameView)
            
            // Leave game confirmation
            if showLeaveGameView {
                LeaveGameView(
                    showLeaveGameView: $showLeaveGameView,
                    message: "離開抽卡？",
                    button1Title: "離開",
                    button1Action: { dismiss() },
                    button2Title: "繼續",
                    button2Action: { showLeaveGameView = false }
                )
            }
        }
        .onAppear {
            startAnimations()
        }
        .sheet(isPresented: $showCardCollection) {
            CardCollectionView(gashaSystem: gashaSystem)
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isAnimating = true
        }
        
        // Generate initial particles
        for _ in 0..<20 {
            sparkleParticles.append(SparkleParticle())
        }
        
        // Continuously update particles
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            updateParticles()
        }
    }
    
    private func updateParticles() {
        for i in sparkleParticles.indices {
            sparkleParticles[i].update()
            if sparkleParticles[i].opacity <= 0 {
                sparkleParticles[i] = SparkleParticle()
            }
        }
    }
    
    private func drawCard() {
        guard gameState.coins >= drawCost else { return }
        
        withAnimation(.easeInOut(duration: 1.0)) {
            isAnimating = true
            animationPhase = 1
        }
        
        // Play draw animation and sound
        playDrawAnimation()
        
        // After animation, show card and update game state
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let drawnCard = gashaSystem.drawCard(gameState: gameState)
            
            // Show card reveal animation
            withAnimation(.easeInOut(duration: 0.5)) {
                animationPhase = 0
                isAnimating = false
            }
        }
    }
    
    private func playDrawAnimation() {
        // Add more particles during draw
        for _ in 0..<30 {
            sparkleParticles.append(SparkleParticle())
        }
        
        // Play draw sound
        if let soundURL = Bundle.main.url(forResource: "draw_sound", withExtension: "mp3") {
            audioPlayer = AVPlayer(url: soundURL)
            audioPlayer?.play()
        }
    }
}

// MARK: - Supporting Views

struct ParticleOverlay: View {
    let particles: [SparkleParticle]
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .blur(radius: 1)
            }
        }
    }
}

struct HeaderView: View {
    let isAnimating: Bool
    let titleGradient: LinearGradient
    
    var body: some View {
        VStack(spacing: 15) {
            Text("✨ Penguin Gacha ✨")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(titleGradient)
                .shadow(color: Color(red: 0.5, green: 0.3, blue: 0.8), radius: 10, x: 0, y: 4)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            
            Text("Draw magical penguin cards!")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: .purple, radius: 5)
        }
    }
}

struct GashaCoinDisplayView: View {
    let coins: Int
    let coinGradient: LinearGradient
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                ForEach(0..<3) { i in
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.yellow)
                        .opacity(0.3)
                        .offset(x: CGFloat(i - 1) * 2, y: CGFloat(i - 1) * 2)
                }
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.yellow)
                    .shadow(color: .orange, radius: 5)
            }
            
            Text("\(coins)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(coinGradient)
                .shadow(color: .black.opacity(0.5), radius: 2)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.3))
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [.yellow.opacity(0.7), .orange.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: .purple.opacity(0.3), radius: 10)
        )
    }
}

struct CrystalBallView: View {
    let isAnimating: Bool
    let animationPhase: Int
    let rotationAngle: Double
    let scale: CGFloat
    let glowOpacity: Double
    
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.4, green: 0.2, blue: 0.8).opacity(0.4),
                            .clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 150
                    )
                )
                .frame(width: 250, height: 250)
                .opacity(glowOpacity)
            
            // Crystal ball
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color(red: 0.3, green: 0.2, blue: 0.8).opacity(0.6),
                            Color(red: 0.2, green: 0.3, blue: 0.9).opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 180)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                        .blur(radius: 2)
                )
                .shadow(color: Color(red: 0.3, green: 0.2, blue: 0.8), radius: 15)
                .rotationEffect(.degrees(rotationAngle))
                .scaleEffect(scale)
            
            // Content
            if !isAnimating {
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(color: .white, radius: 5)
                    .rotationEffect(.degrees(rotationAngle))
            } else {
                Image("penguinnn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .shadow(color: .white, radius: 10)
                    .scaleEffect(animationPhase == 1 ? 1.5 : 1.0)
                    .opacity(animationPhase >= 1 ? 1.0 : 0.0)
            }
        }
    }
}

struct ButtonsView: View {
    let isAnimating: Bool
    let drawCost: Int
    let coins: Int
    let collectedCount: Int
    let drawButtonGradient: LinearGradient
    let onDraw: () -> Void
    let onShowCollection: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Draw button
            Button(action: onDraw) {
                HStack(spacing: 15) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 24))
                    
                    Text("Draw Card")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    Text("(\(drawCost) 🪙)")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 35)
                .padding(.vertical, 18)
                .background(
                    Capsule()
                        .fill(drawButtonGradient)
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: coins >= drawCost ? Color(red: 0.9, green: 0.4, blue: 0.2).opacity(0.6) : .gray.opacity(0.3), radius: 10)
                )
            }
            .disabled(coins < drawCost || isAnimating)
            .scaleEffect(isAnimating ? 0.95 : 1.0)
            
            // Collection button
            Button(action: onShowCollection) {
                HStack(spacing: 12) {
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 20))
                    
                    Text("My Collection")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
                    Text("(\(collectedCount))")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.5), .purple.opacity(0.5)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: .purple.opacity(0.3), radius: 8)
                )
            }
        }
    }
}

struct NavigationBar: View {
    @Binding var showLeaveGameView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { showLeaveGameView = true }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .padding(.leading, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            
            Spacer()
        }
    }
}

// Particle effect
struct SparkleParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var size: CGFloat
    var opacity: Double
    var speed: CGFloat
    
    init() {
        position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
        
        let colors: [Color] = [.yellow, .orange, .purple, .blue]
        color = colors.randomElement() ?? .yellow
        size = CGFloat.random(in: 2...6)
        opacity = Double.random(in: 0.3...0.7)
        speed = CGFloat.random(in: 1...3)
    }
    
    mutating func update() {
        position.y -= speed
        opacity -= 0.01
        if position.y < 0 {
            position.y = UIScreen.main.bounds.height
            opacity = Double.random(in: 0.3...0.7)
        }
    }
}

#Preview {
    GashaView()
        .environmentObject(GameState())
} 
