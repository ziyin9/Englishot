import SwiftUI
import AVFoundation

struct WordDetailView: View {
    var collectedWords: [Vocabulary]
    var showImages: [Data?]
    @State private var currentIndex: Int
    
    @StateObject private var audioPlayer = AudioPlayer()
    @Environment(\.presentationMode) var presentationMode
    @State private var isBackButtonHovered = false
    @State private var isArrowGlowing = false
    @State private var arrowPhase = 0.0
    @Environment(\.dismiss) var dismiss

    init(collectedWords: [Vocabulary], showImages: [Data?], initialIndex: Int = 0) {
        self.collectedWords = collectedWords
        self.showImages = showImages
        _currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        ZStack {
            // Background gradient with snow effect
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.white.opacity(0.3),
                    Color.blue.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Snow effect
            SSnowfallView(intensity: 0.6)
                .opacity(0.6)
            
            TabView(selection: $currentIndex) {
                ForEach(collectedWords.indices, id: \.self) { index in
                    VStack(spacing: 25) {
                        // Word Content Card
                        SettingsCard {
                            VStack(spacing: 20) {
                                // Word Title and Pronunciation
                                HStack(spacing: 15) {
                                    Text(collectedWords[index].E_word)
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.black, .black],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                    
                                    Button(action: {
                                        if let url = URL(string: collectedWords[index].audioURL) {
                                            audioPlayer.playSound(from: url)
                                        }
                                    }) {
                                        Image(systemName: "speaker.wave.2.fill")
                                            .font(.title2)
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [.blue.opacity(0.8), .blue.opacity(0.7)],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .padding(8)
                                            .background(
                                                Circle()
                                                    .fill(.white.opacity(0.3))
                                                    .shadow(color: .blue.opacity(0.3), radius: 5)
                                            )
                                    }
                                }
                                
                                // Chinese Translation
                                Text(collectedWords[index].C_word)
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 5)
                                
                                // Image Display
                                if let imageData = showImages[index],
                                   let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 400)
                                        .cornerRadius(15)
                                        .shadow(color: .blue.opacity(0.2), radius: 10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [.white.opacity(0.8), .blue.opacity(0.6)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        )
                                }
                                
                                // Example Sentence Card
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Example Sentence")
                                        .font(.headline)
                                        .foregroundColor(.blue.opacity(0.7))
                                    
                                    Text(collectedWords[index].exSentence)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary.opacity(0.8))
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.white.opacity(0.5))
                                                .shadow(color: .blue.opacity(0.1), radius: 5)
                                        )
                                }
                                .padding(.top, 10)
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton {
                    dismiss()
                    
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WordDetailView(
        collectedWords: [
            Vocabulary(bigtopic: "Mall", category: "Kitchen", E_word: "fork", C_word: "叉子", exSentence: "I use a fork to eat.", audioURL: "https://www.example.com/fork.mp3"),
            Vocabulary(bigtopic: "Mall", category: "Kitchen", E_word: "spoon", C_word: "湯匙", exSentence: "I eat soup with a spoon.", audioURL: "https://www.example.com/spoon.mp3")
        ],
        showImages: [nil, nil]
    )
}
