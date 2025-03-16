//
//  GameView.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/2/25.
//

import SwiftUI

struct GameView: View {
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
    
    private var levelData: GameLevelData {
            switch title {
                
                //Home
            case "Bathroom":
                return BathroomData
            case "Kitchen":
                return KitchenData
            case "Living Room":
                return Living_RoomData
            case "Garage":
                return GarageData
                
                //Mall
            case "Food":
                return FoodData
            case "Electronics Store":
                return Electronics_StoreData
            case "Clothing Store":
                return Clothing_StoreData
                
                //Market
            case "Fruit":
                return FruitData
            case "Vegetable":
                return VegetableData
            case "Spices":
                return SpicesData
                
                //school
            case "Classroom1":
                return Classroom1Data
            case "Classroom2":
                return Classroom2Data
            case "music":
                return MusicData
            case "Playground":
                return PlaygroundData
            case "Sports":
                return SportsData
                
                
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
                return BathroomData // 預設使用第一關//之後要改
            }
        }
    
    var body: some View {
        ZStack {
            Image(levelData.backgroundImage)
                .resizable()
                .scaledToFill()
                .opacity(0.3)
                .ignoresSafeArea()
//            VStack{
//                HStack {
//                    Spacer()
//                    
//                    Button(action: { uiState.showGameCardView = true }) {
//                        Image("A")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 40)
//                            .font(.title)
//                            .padding(6)
//                            .background(Color.blue.opacity(0.3))
//                            .clipShape(Circle())
//                    }
//                    .padding(.trailing, 10)
//                    
//                    Button(action: { gameState.showingCamera = true }) {
//                        Image("camera")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 40)
//                            .font(.title)
//                            .padding(6)
//                            .background(Color.blue.opacity(0.3))
//                            .clipShape(Circle())
//                    }
//                    .padding(.trailing, 30)
//                }
//                .padding(.top, 35)
//                Spacer()
//            }

            GeometryReader { geometry in
                VStack(alignment: .center) {
                    if ("\(levelData.title)" == "Electronics Store"){
                        Text("Electronics")
                            .font(.system(size: 60, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                        
                    }else if ("\(levelData.title)" == "Clothing Store"){
                        Text("Clothing")
                            .font(.system(size: 60, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                        
                    }else{
                        Text(levelData.title)
                        .font(.system(size: 60, weight: .bold, design: .serif))
                        .foregroundColor(.black)
                        .padding(.top, 60)
                    }

                    GridView(
                        guessedLetters: $guessedLetters,
                        answers: levelData.answers,
                        numberHints: levelData.numberHints,
                        wordEntities: Array(wordEntities),
                        showAnswer: $showAnswer
                    )


                    VStack {
                        
                        GeometryReader { geometry in
                            let screenWidth = geometry.size.width
                            let screenheight = geometry.size.height
                            
                            let frameWidth = screenWidth * 0.8
                            let frameHeight = frameWidth * 0.4
                            ScrollView{
                                
                                VStack(spacing: 10) {
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.0))
                                        .frame(width: frameWidth, height: frameHeight)
                                        .overlay(
                                            VStack(alignment: .leading) {
                                                Text("Across")
                                                    .font(Font.custom("Kalam-Regular", size: 25))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Group {
                                                    ForEach(levelData.acrossHints, id: \.self) { hint in
                                                    Text(hint)
                                                    }
                                                }
                                                .font(Font.custom("Kalam-Regular", size: 20))
                                                
                                            }
                                        )
                                    
                                    
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.0))
                                        .frame(width: frameWidth, height: frameHeight)
                                        .overlay(
                                            VStack(alignment: .leading) {
                                                Text("Down")
                                                    .font(Font.custom("Kalam-Regular", size: 25))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Group {
                                                    ForEach(levelData.downHints, id: \.self) { hint in
                                                        Text(hint)
                                                    }
                                                }
                                                .font(Font.custom("Kalam-Regular", size: 20))
                                            }
                                        )
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // 限制 Vstack 在可用空間內**
                        }
                    }

                }
            }

            GameCardView(vocabulary: levelData.game_vocabulary)
                .environmentObject(uiState)
        }
        .onAppear {
            uiState.isNavBarVisible = false
            highestConfidenceWord = recognizedObjects.first ?? ""
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                BackButton{
                    dismiss()
                    uiState.showGameCardView = false

                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Spacer()
                    
                    Button(action: { uiState.showGameCardView = true }) {
                        Image("A")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .font(.title)
                            .padding(6)
                            .background(Color.blue.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { gameState.showingCamera = true }) {
                        Image("camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .font(.title)
                            .padding(6)
                            .background(Color.blue.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                }

            }
            
        })
    }
}

#Preview {
    GameView(
        showAnswer: .constant(Array(repeating: Array(repeating: false, count: 11), count: 10)),
        showingCamera: .constant(false),
        title: "bathroom"
    )
    .environmentObject(GameState())
    .environmentObject(UIState())
}
