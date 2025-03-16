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
    private let mainCategories = ["All", "Home", "School", "Zoo", "Mall", "Market"]

    private let columns = [
        GridItem(.flexible(), spacing: -20),
        GridItem(.flexible(), spacing: -20)
    ]

    @State private var selectedCategoryOffset: CGFloat = 0
    @State private var cardScale: CGFloat = 1.0
    @Namespace private var animation

    
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
                SnowfallView()
                    .opacity(0.6)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer()
                        Spacer()
                        VStack{
                            Text("Vocabulary List")
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
                            circlewidth: 150 ,
                            circleheight: 150
                            
                        )
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
                            ForEach(filteredWords(), id: \.self) { wordEntity in
                                if let index = vocabularyList.firstIndex(where: { $0.E_word == wordEntity.word }) {
                                    let itemImage = wordEntity.itemimage
                                    VocabularyCard(vocabulary: vocabularyList[index], showimage: itemImage)
                                        .scaleEffect(cardScale)
                                        .overlay(
                                            NavigationLink(destination: WordDetailView(vocabulary: vocabularyList[index],
                                                                                     showimage: itemImage)) {
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
//                            deleteWord(wordString:"fork")
//                            deleteWord(wordString:"soap")
//                            deleteWord(wordString:"fan")
//                            deleteWord(wordString:"sock")
//                            deleteWord(wordString:"comb")
//                            deleteWord(wordString:"television")
//                            deleteWord(wordString:"plug")
//                            deleteWord(wordString:"knife")
//                            deleteWord(wordString:"spoon")
//                            deleteWord(wordString:"toothbrush")
//                            deleteWord(wordString:"towel")
//                            deleteWord(wordString:"lamp")
//                            deleteWord(wordString:"cup")
//                            deleteWord(wordString:"bicycle")
//                            deleteWord(wordString:"key")
                    deleteWord(wordString:"box")
                    deleteWord(wordString:"fork")

//                            deleteWord(wordString:"toilet")
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
                if uiState.showDataView{
                    PopupDataView()
                }
                

            }
            .edgesIgnoringSafeArea(.all)
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


    }


    #Preview {
        BackpackView()
    }
