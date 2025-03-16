import SwiftUI

struct PopupDataView: View {
//    @Binding var isPresented: Bool
    
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    @EnvironmentObject var uiState: UIState
    // Categories and their respective icons
    private let categories = [
        ("Home", "house.fill"),
        ("Zoo", "pawprint.fill"),
        ("School", "book.fill"),
        ("Market", "cart.fill"),
        ("Mall", "bag.fill")
    ]
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            if uiState.showDataView {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            uiState.showDataView = false
                        }
                    }
                
                
                // Popup content
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header with close button
                            HStack {
                                Text("Collection Progress")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.8), .blue.opacity(0.6)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                Spacer()
                                
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        uiState.showDataView = false
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray.opacity(0.7))
                                        .font(.system(size: 28))
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 4)
                            
                            // Progress stats
                            VStack(spacing: 24) {
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
                                    .edgesIgnoringSafeArea(.all)
                                    
                                    // Snow effect
                                    SnowfallView()
                                        .opacity(0.6)
                                    
                                    ScrollView {
                                        VStack(spacing: 32) {
                                            
                                            // Total Progress Card
                                            SettingsCard {
                                                VStack(spacing: 20) {
                                                    Text("Total Words")
                                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                                        .foregroundColor(.blue.opacity(0.8))
                                                    
                                                    CircularProgressView(
                                                        totalWords: vocabularyList.count,
                                                        currentWords: wordEntities.count,
                                                        circlewidth:140 ,circleheight:140
                                                    )
                                                    .frame(width: 200, height: 100)
                                                }
                                                .padding(.vertical, 16)
                                            }
                                            .padding(.horizontal)
                                            
                                            // Category Progress Cards
                                            LazyVGrid(columns: [
                                                GridItem(.flexible(), spacing: 10),
                                                GridItem(.flexible(), spacing: 10)
                                            ], spacing: 20) {
                                                ForEach(categories, id: \.0) { category, icon in
                                                    SettingsCard {
                                                        VStack() {
                                                            HStack(spacing: 8) {
                                                                Image(systemName: icon)
                                                                    .foregroundColor(.blue.opacity(0.8))
                                                                    .font(.system(size: 18))
                                                                Text(category)
                                                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                                                    .foregroundColor(.primary.opacity(0.8))
                                                            }
                                                            .padding(.top, 8)
                                                            
                                                            CircularProgressView(
                                                                totalWords: totalWordsForCategory(category),
                                                                currentWords: collectedWordsForCategory(category),
                                                                circlewidth:100 ,circleheight:100
                                                            )
                                                            .frame(width: 110, height: 100)
                                                            .padding(.bottom, 8)
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                        .padding(.vertical, 16)
                                    }
                                }
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                                .shadow(
                                    color: .black.opacity(0.15),
                                    radius: 16,
                                    x: 0,
                                    y: 4
                                )
                        )
                        .frame(
                            width: min(geometry.size.width * 0.9, 500),
                            height: min(geometry.size.height * 0.85, 700)
                        )
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                    }
                    .scrollDisabled(true)
                }
                .ignoresSafeArea()
            }
        }
    }
    
    // Calculate total words for a specific category
    private func totalWordsForCategory(_ bigtopic: String) -> Int {
        vocabularyList.filter { $0.bigtopic.hasPrefix(bigtopic) }.count
    }
    
    // Calculate collected words for a specific category
    private func collectedWordsForCategory(_ bigtopic: String) -> Int {
        wordEntities.filter { word in
            vocabularyList.contains {
                $0.E_word == word.word && $0.bigtopic.hasPrefix(bigtopic)
            }
        }.count
    }
}


#Preview{
    let uiState = UIState()
    
    PopupDataView()
        .environmentObject(uiState)

}
