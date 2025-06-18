import SwiftUI
import AVFoundation

class AudioPlayer: ObservableObject {
    
    var player: AVPlayer?

    func playSound(from url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }
    
}

struct BackpackView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var uiState: UIState
    
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    @State private var selectedCategory: String = "All"
    @State private var subCategories: [String] = []
    @State private var showMemoryGame = false
    @State private var showAudioImageGame = false
    private let mainCategories = ["All", "Home", "School", "Zoo", "Mall", "Market"]
    
    private let columns = [
        GridItem(.flexible(), spacing: -20),
        GridItem(.flexible(), spacing: -20)
    ]
    
    @State private var selectedCategoryOffset: CGFloat = 0
    @State private var cardScale: CGFloat = 1.0
    @Namespace private var animation
    @State private var selectedWordIndex: Int = 0
    
    @State private var showDeleteWordView = false
    @State private var wordEntitiesArray: [Word] = []
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.3),
                        Color.blue.opacity(0.1),
                        Color.blue.opacity(0.2),
                        Color.purple.opacity(0.1),
                        Color.blue.opacity(0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Snow particles effect
                SSnowfallView(intensity: 0.6)
                    .opacity(0.6)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack{
                            Text("Backpack")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.7), .blue.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(maxWidth: .infinity, alignment: .center)
                            // Center the title
                                .padding(.top, 40)
                                .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                            
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            
                        }
                        
                                                
                        
                        
                        CircularProgressView(
                            totalWords: totalWordsForCategory(selectedCategory),
                            currentWords: collectedWordsForCategory(selectedCategory),
                            circlewidth: 150,
                            circleheight: 150
                        )
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.8),
                                            .blue.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .white.opacity(0.5), radius: 2, x: -2, y: -2)
                                .shadow(color: .blue.opacity(0.3), radius: 4, x: 3, y: 3)
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.6), .blue.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .scaleEffect(uiState.showDataView ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: uiState.showDataView)
                        .transition(.scale.combined(with: .opacity))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                uiState.showDataView = true
                            }
                        }
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(mainCategories, id: \.self) { category in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            selectedCategory = category
                                            cardScale = 0.8
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                                    cardScale = 1.0
                                                }
                                            }
                                        }
                                    }) {
                                        HStack {
                                            Image("8")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            
                                            Text(category)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 8)
                                        .background(
                                            ZStack {
                                                if selectedCategory == category {
                                                    Capsule()
                                                        .fill(Color.blue.opacity(0.8))
                                                        .matchedGeometryEffect(id: "category", in: animation)
                                                }
                                            }
                                        )
                                        .foregroundColor(selectedCategory == category ? .white : .black)
                                        .cornerRadius(20)
                                        .shadow(color: selectedCategory == category ? .blue.opacity(0.3) : .clear,
                                                radius: 5, x: 0, y: 3)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                                                    ForEach(Array(filteredWords().enumerated()), id: \.element) { index, wordEntity in
                                                        if let vocabIndex = vocabularyList.firstIndex(where: { $0.E_word == wordEntity.word }) {
                                                            let itemImage = wordEntity.itemimage
                                                            VocabularyCard(vocabulary: vocabularyList[vocabIndex], showimage: itemImage)
                                                                .scaleEffect(cardScale)
                                                                .onTapGesture {
                                                                    selectedWordIndex = index  // Update to use the filtered list index
                                                                }
                                                                .overlay(
                                                                    NavigationLink(destination: WordDetailView(
                                                                        collectedWords: filteredCollectedWords(),
                                                                        showImages: getShowImages(for: filteredCollectedWords()),
                                                                        initialIndex: index  // Pass the correct index from filtered list
                                                                    )) {
                                                                        Rectangle()
                                                                            .foregroundColor(.clear)
                                                                    }
                                                                        .frame(width: 80, height: 100)
                                                                )
                                                        }
                                                    }
                                                }
                                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedCategory)
                                                Spacer()
                                                Spacer()
                                                Spacer()
                                                
                                            }
                                        }
                                        //                .onAppear {
                                        //                        uiState.isNavBarVisible = false // 隱藏
                                        //                            }
                                        Button(action: {
                                            wordEntitiesArray = Array(wordEntities)
                                            showDeleteWordView.toggle() // 切換視圖顯示
                                        }) {
                                            Image(systemName: "trash.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(
                                                    Circle()
                                                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .top, endPoint: .bottom))
                                                        .shadow(radius: 10)
                                                )
                                        }
                                        .sheet(isPresented: $showDeleteWordView) {
                                            DeleteWordView(wordEntities: $wordEntitiesArray) // 傳遞綁定的 wordEntities
                                        }

                                        if uiState.showDataView{
                                            PopupDataView()
                                        }
                                        
                                        
                                    }
//                                    .sheet(isPresented: $showMemoryGame) {
//                                        MemoryGameView()
//                                            .edgesIgnoringSafeArea(.all)
                                        //            .overlay {
                                        //                if showingDataView {
                                        //                    PopupDataView(
                                        //                        isPresented: $showingDataView
                                        //                    )
                                        ////                    .padding(20)
                                        //                    .edgesIgnoringSafeArea(.all)
                                        //
                                        ////                    .ignoresSafeArea()
                                        //                    .transition(.scale.combined(with: .opacity))
                                        //                }
                                        //            }
                                        
//                                    }
//                                    .sheet(isPresented: $showAudioImageGame) {
//                                        AudioImageMatchingGame()
//                                            .edgesIgnoringSafeArea(.all)
//                                    }
                                    
                                    
                                    
                                }
                            }
                                // Calculate total words for a specific category
                                private func totalWordsForCategory(_ bigtopic: String) -> Int {
                                    if selectedCategory == "All" {
                                        return vocabularyList.count
                                    } else{
                                        return vocabularyList.filter { $0.bigtopic.hasPrefix(bigtopic) }.count
                                    }
                                }
                                
                                // Calculate collected words for a specific category
                                private func collectedWordsForCategory(_ bigtopic: String) -> Int {
                                    if selectedCategory == "All" {
                                        return wordEntities.count
                                    }else {
                                        return wordEntities.filter { word in
                                            vocabularyList.contains {
                                                $0.E_word == word.word && $0.bigtopic.hasPrefix(bigtopic)
                                            }
                                        }.count
                                    }
                                }
                                
                                private func filteredWords() -> [Word] {
                                    if selectedCategory == "All" {
                                        return Array(wordEntities)
                                    } else {
                                        return wordEntities.filter { word in
                                            vocabularyList.contains { $0.E_word == word.word && $0.bigtopic == selectedCategory }
                                        }
                                    }
                                }
                                
                                private func filteredCollectedWords() -> [Vocabulary] {
                                    let collectedWords = wordEntities.compactMap { entity -> Vocabulary? in
                                        vocabularyList.first { vocab in
                                            vocab.E_word == entity.word &&
                                            (selectedCategory == "All" || vocab.bigtopic == selectedCategory)
                                        }
                                    }
                                    return collectedWords
                                }
                                
                                private func getShowImages(for vocabularies: [Vocabulary]) -> [Data?] {
                                    return vocabularies.map { vocabulary in
                                        wordEntities.first { $0.word == vocabulary.E_word }?.itemimage
                                    }
                                }
                                
                            }


                            #Preview {
                                BackpackView()
                            }
