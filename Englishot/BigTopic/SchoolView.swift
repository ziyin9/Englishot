//
//  SchoolView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 12/3/24.
//
//
//  SchoolView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 12/3/24.
//
import SwiftUI

struct SchoolView: View {
    
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    
    @State private var isLoaded = false
    @State private var selectedLevel: Int?
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }
    
    // Level data with level ID and associated level name, icon, and view
    private let levels: [(name: String, icon: String, view: AnyView, words: [Vocabulary])] = [
            ("Classroom1", "book.fill", AnyView(TGame(levelData: Classroom1Data, ML_model: "Home_School").navigationBarBackButtonHidden(true)), Classroom1Data.game_vocabulary),
            ("Classroom2", "pencil", AnyView(TGame(levelData: Classroom2Data, ML_model: "Home_School").navigationBarBackButtonHidden(true)), Classroom2Data.game_vocabulary),
            ("Music", "music.note", AnyView(TGame(levelData: MusicData, ML_model: "Home_School").navigationBarBackButtonHidden(true)), MusicData.game_vocabulary),
            ("Playground", "sportscourt.fill", AnyView(TGame(levelData: PlaygroundData, ML_model: "Home_School").navigationBarBackButtonHidden(true)), PlaygroundData.game_vocabulary),
            ("Sports", "sportscourt.fill", AnyView(TGame(levelData: SportsData, ML_model: "Home_School").navigationBarBackButtonHidden(true)), SportsData.game_vocabulary),
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
                        Text("        School")
                            .font(.system(size: 60, weight: .bold, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .offset(x: isLoaded ? 0 : -100)
                    
                    VStack(spacing: 25) {
                        Image("Schoolimage")
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
                        dismiss()
                        uiState.isNavBarVisible = true

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
    SchoolView()
        .environmentObject(UIState())
}
