//
//  GameView.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/2/25.
//

import SwiftUI

struct GameView_2: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var uiState: UIState
    
    @Binding var showAnswer: [[Bool]]
    @Binding var showingCamera: Bool
    
    @State private var guessedLetters = Array(repeating: Array(repeating: "", count: 11), count: 10)
    @State private var resultMessage = ""
    @State private var image: UIImage?
    @State private var recognizedObjects = [String]()
    @State private var highestConfidenceWord = ""
    
    @FetchRequest(entity: Word.entity(), sortDescriptors: [])
    var wordEntities: FetchedResults<Word>
    
    var title: String
    
    private var levelData_2: GameLevelData_2 {
        switch title {
            
            //Zoo
        case "Mammals1":
            return Mammals1Data
        case "Mammals2":
            return Mammals2Data
        case "Mammals3":
            return Mammals3Data
        case "Marine Animals":
            return Marine_AnimalsData
        case "Birds":
            return BirdsData
            
        default:
            return BirdsData // 預設使用第一關//之後要改
        }
    }
    var body: some View {
        ZStack {
            Image(levelData_2.backgroundImage)
                .resizable()
                .scaledToFill()
                .opacity(0.3)
                .ignoresSafeArea()
            
            GeometryReader{geometry in
                VStack(alignment: .center) {
                    if ("\(levelData_2.title)" == "Electronics Store"){
                        Text("Electronics")
                            .font(.system(size: 60, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                        
                    }else if ("\(levelData_2.title)" == "Clothing Store"){
                        Text("Clothing")
                            .font(.system(size: 60, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                        
                    }else{
                        Text(levelData_2.title)
                            .font(.system(size: 60, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .padding(.top, 60)
                    }
                    
                    GridView(
                        guessedLetters: $guessedLetters,
                        answers: levelData_2.answers,
                        numberHints: levelData_2.numberHints,
                        wordEntities: Array(wordEntities),
                        showAnswer: $showAnswer
                    )
                    VStack{

                        GeometryReader { geometry in
                            let screenWidth = geometry.size.width
                            let screenheight = geometry.size.height
                            
                            let frameWidth = screenWidth * 1
                            let frameHeight = screenheight * 0.9
                            ScrollView{
                                VStack{
                                    Image("\(levelData_2.imageHint)")
                                        .resizable()
                                        .frame(width:frameWidth,height:frameHeight)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // 限制 Vstack 在可用空間內**
                            }
                        }
                    }
                }
            }
            .onAppear {
                uiState.isNavBarVisible = false
                highestConfidenceWord = recognizedObjects.first ?? ""
            }
        }
    }
}
#Preview {
    GameView_2(
        showAnswer: .constant(Array(repeating: Array(repeating: false, count: 11), count: 10)),
        showingCamera: .constant(false),
        title: "bathroom"
    )
    .environmentObject(GameState())
    .environmentObject(UIState())
}
