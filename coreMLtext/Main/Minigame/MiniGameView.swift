import SwiftUI

struct MiniGameView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var uiState: UIState
    @Environment(\.dismiss) var dismiss

    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    
    @State private var isLoaded = false
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }
    @State private var isHoveringMemory = false
    @State private var isHoveringAudio = false
    
    private var isMemoryGamePlayable: Bool {
        wordEntities.count >= 6
    }
    
    private var isAudioGamePlayable: Bool {
        wordEntities.count >= 6
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced background gradient with more depth
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(#colorLiteral(red: 0.8, green: 0.9, blue: 1.0, alpha: 1)), // Light sky blue
                        Color(#colorLiteral(red: 0.95, green: 0.97, blue: 1.0, alpha: 1)), // Almost white
                        Color(#colorLiteral(red: 0.85, green: 0.91, blue: 1.0, alpha: 1)) // Pale blue
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Improved snow effect with varying sizes
                ForEach(snowflakes) { snowflake in
                    Snowflake_View(snowflake: snowflake)
                }
                
                // Content
                VStack(spacing: 30) {
                    // Enhanced header
                    VStack(spacing: 10) {
                        Text("Winter Games")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(#colorLiteral(red: 0.2, green: 0.5, blue: 0.8, alpha: 1)),
                                        Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.9, alpha: 1))
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Challenge your vocabulary skills")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.5, blue: 0.8, alpha: 1)))
                    }
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                    .padding(.top, 30)
                    .offset(y: isLoaded ? 0 : -50)
                    .opacity(isLoaded ? 1 : 0)
                    
                    Spacer()
                    
                    // Game cards container with spring animation
                    VStack(spacing: 70) {
                        // Memory Game Card
                        NavigationLink(destination: MemoryGameView()
                            .navigationBarBackButtonHidden()
                        ) {
                            EnhancedGameCard(
                                title: "Memory Match",
                                subtitle: "Test your word recall skills",
                                mainIcon: "brain.head.profile",
                                decorativeIcons: ["sparkles", "star.fill", "lightbulb.fill"],
                                colors: [Color(#colorLiteral(red: 0.3, green: 0.4, blue: 0.9, alpha: 1)), Color(#colorLiteral(red: 0.5, green: 0.6, blue: 0.95, alpha: 1))],
                                isHovering: $isHoveringMemory,
                                isEnabled: isMemoryGamePlayable,
                                lockedMessage: "Collect 6+ Words to Unlock"
                            )
                            .scaleEffect(isHoveringMemory ? 1.03 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHoveringMemory)
                            .onHover { hovering in
                                isHoveringMemory = hovering
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!isMemoryGamePlayable)
                        .offset(x: isLoaded ? 0 : -300)
                        .opacity(isLoaded ? 1 : 0)
                        
                        // Audio-Image Game Card
                        NavigationLink(destination: AudioImageMatchingGame()
                            .navigationBarBackButtonHidden()
                        ) {
                            EnhancedGameCard(
                                title: "Sound & Image",
                                subtitle: "Match the words you hear",
                                mainIcon: "speaker.wave.2.fill",
                                decorativeIcons: ["ear.fill", "photo.fill", "waveform"],
                                colors: [Color(#colorLiteral(red: 0.2, green: 0.7, blue: 0.9, alpha: 1)), Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.95, alpha: 1))],
                                isHovering: $isHoveringAudio,
                                isEnabled: isAudioGamePlayable,
                                lockedMessage: "Collect 6+ Words to Unlock"
                            )
                            .scaleEffect(isHoveringAudio ? 1.03 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHoveringAudio)
                            .onHover { hovering in
                                isHoveringAudio = hovering
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!isAudioGamePlayable)
                        .offset(x: isLoaded ? 0 : 300)
                        .opacity(isLoaded ? 1 : 0)
                    }
                    .padding(.horizontal, 25)
                    
                    Spacer()
                    
                    
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // Staggered animations
                withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.1)) {
                    isLoaded = true
                }
            }
        }
    }
}

struct EnhancedGameCard: View {
    let title: String
    let subtitle: String
    let mainIcon: String
    let decorativeIcons: [String]
    let colors: [Color]
    @Binding var isHovering: Bool
    let isEnabled: Bool
    let lockedMessage: String
    
    @State private var animateIcons = false
    
    var body: some View {
        ZStack {
            // Card background with frost effect
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: isEnabled ? colors : [Color.gray.opacity(0.6), Color.gray.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.7), lineWidth: 2)
                )
                .shadow(color: isEnabled ? colors[0].opacity(0.5) : Color.gray.opacity(0.3), radius: 8, x: 0, y: 5)
            
            // Ice crystal patterns
            ZStack {
                ForEach(0..<6) { index in
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .scaleEffect(0.97 - CGFloat(index) * 0.05)
                }
            }
            
            // Content
            VStack(spacing: 12) {
                // Main icon with glow
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .blur(radius: 10)
                    
                    // Icon background
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 80, height: 80)
                    
                    if isEnabled {
                        // Main icon
                        Image(systemName: mainIcon)
                            .font(.system(size: 40))
                            .foregroundColor(colors[0])
                            .offset(y: animateIcons ? -2 : 2)
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateIcons)
                    } else {
                        // Locked icon
                        Image(systemName: "lock.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color.gray)
                    }
                    
                    // Decorative small icons
                    if isEnabled {
                        ForEach(0..<decorativeIcons.count, id: \.self) { index in
                            Image(systemName: decorativeIcons[index])
                                .font(.system(size: 14))
                                .foregroundColor(colors[0])
                                .offset(
                                    x: CGFloat([-35, 35, 0][index]) + (animateIcons ? CGFloat([-5, 5, 0][index]) : 0),
                                    y: CGFloat([20, 20, -35][index]) + (animateIcons ? CGFloat([5, -5, -5][index]) : 0)
                                )
                                .opacity(animateIcons ? 0.8 : 0.4)
                                .animation(
                                    Animation.easeInOut(duration: 2)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.3),
                                    value: animateIcons
                                )
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Title and subtitle
                VStack(spacing: 6) {
                    Text(isEnabled ? title : lockedMessage)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
                    
                    if isEnabled {
                        Text(subtitle)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Play button
                if isEnabled {
                    HStack {
                        Spacer()
                        
                        Text("Play Now")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(colors[0])
                        
                        Image(systemName: "play.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(colors[0])
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.9))
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 15)
                }
            }
        }
        .frame(height: 220)
        .opacity(isEnabled ? 1.0 : 0.7)
        .onAppear {
            // Start animations
            withAnimation(Animation.easeInOut(duration: 0.3).delay(0.5)) {
                animateIcons = true
            }
        }
    }
}

#Preview {
    MiniGameView()
        .environmentObject(GameState())
        .environmentObject(UIState())
}
