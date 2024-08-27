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
//    @EnvironmentObject var uiState: UIState

    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    @State private var selectedCategory: String = "All"
    @State private var subCategories: [String] = []
    private let mainCategories = ["All", "Home", "School", "Zoo", "Mall", "Market"]
    private let categoryMapping: [String: [String]] = [
        "Home": ["Kitchen", "Bathroom", "Livingroom","Garage"],
        "School": ["Classroom", "Library", "Playground"],
        "Zoo": ["Mammals", "Birds", "Reptiles"],
        "Mall": ["Clothing", "Food Court", "Electronics"],
        "Market": ["Fruits", "Vegetables", "Seafood"],
    ]//之後要改
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
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Vocabulary List")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.top, 40)
                            .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                        Button(action: {
                            deleteWord(wordString:"fork")
                            deleteWord(wordString:"soap")

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
                        CircularProgressView(
                            totalWords: totalWordsForCategory(),
                            currentWords: currentWordsForCategory()
                        )
                        .transition(.scale.combined(with: .opacity))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(mainCategories, id: \.self) { category in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            selectedCategory = category
                                            subCategories = categoryMapping[category] ?? []
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
                    }
                }
//                .onAppear {
//                        uiState.isNavBarVisible = false // 隱藏
//                            }
                

            }
        }
        
    }
    private func filteredWords() -> [Word] {
            if selectedCategory == "All" {
                return Array(wordEntities)
            } else if let subCategories = categoryMapping[selectedCategory] {
                return wordEntities.filter { word in
                    vocabularyList.contains { $0.E_word == word.word && subCategories.contains($0.category) }
                }
            } else {
                return wordEntities.filter { word in
                    vocabularyList.contains { $0.E_word == word.word && $0.category == selectedCategory }
                }
            }
        }

        private func totalWordsForCategory() -> Int {
            if selectedCategory == "All" {
                return vocabularyList.count
            } else if let subCategories = categoryMapping[selectedCategory] {
                return vocabularyList.filter { subCategories.contains($0.category) }.count
            } else {
                return vocabularyList.filter { $0.category == selectedCategory }.count
            }
        }

        private func currentWordsForCategory() -> Int {
            if selectedCategory == "All" {
                return wordEntities.count
            } else if let subCategories = categoryMapping[selectedCategory] {
                return wordEntities.filter { word in
                    vocabularyList.contains { $0.E_word == word.word && subCategories.contains($0.category) }
                }.count
            } else {
                return wordEntities.filter { word in
                    vocabularyList.contains { $0.E_word == word.word && $0.category == selectedCategory }
                }.count
            }
        }


    }


    #Preview {
        BackpackView()
    }
