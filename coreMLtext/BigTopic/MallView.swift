//
//  ParkView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 12/3/24.
//
import SwiftUI

struct MallView: View {
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>

    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    
    // Animation states
    @State private var isLoaded = false
    @State private var selectedLevel: Int?
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }
  
    // Level data
    private let levels: [(name: String, icon: String, view: AnyView, words: [Vocabulary])] = [
            ("Food", "cart.fill", AnyView(HomeGame(levelData: FoodData).navigationBarBackButtonHidden(true)), FoodData.game_vocabulary),
            ("Electronics Store", "desktopcomputer", AnyView(HomeGame(levelData: Electronics_StoreData).navigationBarBackButtonHidden(true)), Electronics_StoreData.game_vocabulary),
            ("Clothing Store", "tshirt.fill", AnyView(HomeGame(levelData: Clothing_StoreData).navigationBarBackButtonHidden(true)), Clothing_StoreData.game_vocabulary)
            
        ]
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
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
                
                // Animated snowfall
                ForEach(snowflakes) { snowflake in
                    Snowflake_View(snowflake: snowflake)
                }
                
                VStack {
                    HStack {
                        Text("         Mall")
                            .font(.system(size: 60, weight: .bold, design: .serif))
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.black)
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .offset(x: isLoaded ? 0 : -100)
                    

                    VStack(spacing: 25) {
                        Image("Mallimage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .shadow(color: .blue.opacity(0.3), radius: 10)
                            .scaleEffect(isLoaded ? 1 : 0.5)
                        
                        // Level buttons 
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(Array(levels.enumerated()), id: \.offset) { index, level in
                                let progress = getProgressForLevel(wordsForLevel: level.words)
                                LevelButton(
                                    index: index,
                                    icon: level.icon,
                                    name: level.name,
                                    destination: level.view,
                                    isSelected: selectedLevel == index,
                                    progress: progress // Pass progress

                                )
                                .offset(y: isLoaded ? 0 : 200)
                                .animation(.spring(response: 0.6, dampingFraction: 0.7)
                                    .delay(Double(index) * 0.1), value: isLoaded)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()

                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton{
                        dismiss()
                        }
                }
            })
            .onAppear {
                uiState.isNavBarVisible = false
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    isLoaded = true
                    print("schoolWord Entities: \(wordEntities.map { $0.word ?? "nil" })")

                }
            }
            
        }
    }
    func getProgressForLevel(wordsForLevel: [Vocabulary]) -> CGFloat {
        let totalWords = wordsForLevel.count
        let collectedWords = wordsForLevel.filter { vocabulary in
            wordEntities.contains { $0.word == vocabulary.E_word }
        }.count
        
        return totalWords > 0 ? CGFloat(collectedWords) / CGFloat(totalWords) : 0.0
    }
}

#Preview {
    MallView()
        .environmentObject(UIState())
}
