//
//  ZooView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 2/13/25.
//


//
//  ZooView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 12/3/24.
//




import SwiftUI

struct ZooView: View {
    
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    
    @State private var isLoaded = false
    @State private var selectedLevel: Int?
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }
    
    // Level data with level ID and associated level name, icon, and view
    private let levels: [(name: String, icon: String, view: AnyView, words: [Vocabulary])] = [
            ("Mammals1", "hare.fill", AnyView(TGame_2(levelData: Mammals1Data, ML_model: "Zoo").navigationBarBackButtonHidden(true)), Mammals1Data.game_vocabulary),
            ("Mammals2", "tortoise.fill", AnyView(TGame_2(levelData: Mammals2Data, ML_model: "Zoo").navigationBarBackButtonHidden(true)), Mammals2Data.game_vocabulary),
            ("Mammals3", "dog.fill", AnyView(TGame_2(levelData: Mammals3Data, ML_model: "Zoo").navigationBarBackButtonHidden(true)), Mammals3Data.game_vocabulary),
            ("Marine Animals", "fish.fill", AnyView(TGame_2(levelData: Marine_AnimalsData, ML_model: "Zoo").navigationBarBackButtonHidden(true)), Marine_AnimalsData.game_vocabulary),
            ("Birds", "fish.fill", AnyView(TGame_2(levelData: BirdsData, ML_model: "Zoo").navigationBarBackButtonHidden(true)), BirdsData.game_vocabulary)
        ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background and animated snowfall
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
                
                ForEach(snowflakes) { snowflake in
                    Snowflake_View(snowflake: snowflake)
                }
                
                VStack(spacing: 30) {
                    // Header and main content
                    HStack {
                        Text("        Zoo")
                            .font(.system(size: 60, weight: .bold, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .offset(x: isLoaded ? 0 : -100)
                    
                    VStack(spacing: 25) {
                        Image("Zooimage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .shadow(color: .blue.opacity(0.3), radius: 10)
                            .scaleEffect(isLoaded ? 1 : 0.5)
                        
                        // Level buttons grid with progress
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
                    BackButton {
                        uiState.isNavBarVisible = true

                        dismiss()
                    }
                }
            })
            .onAppear {
                uiState.isNavBarVisible = false
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    isLoaded = true
                }
            }
        }
    }
    
    // Function to calculate the progress for each level
    func getProgressForLevel(wordsForLevel: [Vocabulary]) -> CGFloat {
        let totalWords = wordsForLevel.count
        let collectedWords = wordsForLevel.filter { vocabulary in
            wordEntities.contains { $0.word == vocabulary.E_word }
        }.count
        
        return totalWords > 0 ? CGFloat(collectedWords) / CGFloat(totalWords) : 0.0
    }
    

}



#Preview {
    ZooView()
        .environmentObject(UIState())
}
