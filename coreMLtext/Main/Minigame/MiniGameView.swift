import SwiftUI

struct MiniGameView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var uiState: UIState
    @Environment(\.dismiss) var dismiss

    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    
    @State private var isLoaded = false
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }
    
    private var isMemoryGamePlayable: Bool {
        wordEntities.count >= 6
    }
    
    private var isAudioGamePlayable: Bool {
        wordEntities.count >= 6
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.white.opacity(0.3),
                        Color.blue.opacity(0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Snow effect
                ForEach(snowflakes) { snowflake in
                    Snowflake_View(snowflake: snowflake)
                }
                
                VStack {
                    // Header
                    Text("Mini Games")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.7), .blue.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                        .padding(.top, 20)
                    
                    // Game buttons
                    VStack(spacing: 25) {
                        // Memory Game Button
                        NavigationLink(destination: MemoryGameView()
                            .navigationBarBackButtonHidden()

                            ) {
                            GameButton(
                                title: isMemoryGamePlayable ? "Memory Game" : "Need 6+ Words",
                                icon: isMemoryGamePlayable ? "brain.head.profile" : "lock.fill",
                                isEnabled: isMemoryGamePlayable
                            )
                        }
                    
                        
                        .disabled(!isMemoryGamePlayable)
                        
                        // Audio-Image Game Button
                        NavigationLink(destination: AudioImageMatchingGame()
                            .navigationBarBackButtonHidden()

                        ) {
                            GameButton(
                                title: isAudioGamePlayable ? "Audio-Image Game" : "Need 6+ Words",
                                icon: isAudioGamePlayable ? "speaker.wave.2.fill" : "lock.fill",
                                isEnabled: isAudioGamePlayable
                            )
                        }
                        
                        
                        .disabled(!isAudioGamePlayable)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)

            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    isLoaded = true
                }
            }
        }
    }
}

struct GameButton: View {
    let title: String
    let icon: String
    let isEnabled: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.cyan]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
        .opacity(isEnabled ? 1.0 : 0.6)
        .scaleEffect(isEnabled ? 1.0 : 0.95)
    }
}

#Preview {
    MiniGameView()
        .environmentObject(GameState())
        .environmentObject(UIState())
}
