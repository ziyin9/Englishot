import SwiftUI
import AVFoundation
import UIKit

struct HomeGame2: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    @EnvironmentObject var gameState: GameState
    
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>

    @State private var recognizedObjects: [String] = []
    @State private var highestConfidenceWord: String = ""
    @State private var image: UIImage? = nil
    @State private var showimagePop: Bool = false
    @State private var passToFoundWordSeetWord: String?
    @State private var showAnswer = Array(repeating: Array(repeating: false, count: 11), count: 10)
    @State private var allWordsFound: Bool = false

    
    var body: some View {
        GameView_1_2(showAnswer: $showAnswer, showingCamera: $gameState.showingCamera)
            .onAppear {
                    uiState.isNavBarVisible = false // 隱藏
                        }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton{
                        dismiss()
                    }
                }
            })
        
        .overlay(
            GeometryReader { geometry in
                ZStack {
                    Text("Highest Confidence Word: \(highestConfidenceWord)")
                        .font(.headline)
                        .padding()
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(10)
                        .padding(.bottom)
                    VStack {
                            HStack {
                                Spacer()
                             
                            }
                            Spacer()

                    }
                    //width: geometry.size.width, height: geometry.size.height,

                    if showimagePop {
                        ZStack {
                            FoundWordPopup(image: image, foundWord: passToFoundWordSeetWord, showimagePop: $showimagePop)
                        }
                    }
                }
            }
        )
        .onAppear {
            let wordsToCheck = ["spoon", "fork", "knife", "plate"]
            
            for word in wordsToCheck {
                if let wordEntity = wordEntities.first(where: { $0.word == word }) {
                    checkAndReveal(wordEntity: wordEntity)
                }
            }
        }

        .onChange(of: highestConfidenceWord) { newValue in
            if newValue.lowercased().contains("fork") {
                addNewWord(wordString: "fork", image: image!)
                
                if let forkEntity = wordEntities.first(where: { $0.word == "fork" }) {
                    for row in 1...4{
                        showAnswer[row][5] = forkEntity.controlshow
                    }
                    
                }
                passToFoundWordSeetWord = "fork"
                showimagePop = true
            }else if newValue.lowercased().contains("spoon") {
                addNewWord(wordString: "spoon", image: image!)
                
                if let spoonEntity = wordEntities.first(where: { $0.word == "spoon" }) {
                    for col in 2...7{
                        showAnswer[2][col] = spoonEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "spoon"
                showimagePop = true
            }else if newValue.lowercased().contains("knife") {
                addNewWord(wordString: "knife", image: image!)
                
                if let knifeEntity = wordEntities.first(where: { $0.word == "knife" }) {
                    for col in 5...9{
                        showAnswer[5][col] = knifeEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "knife"
                showimagePop = true
            }else if newValue.lowercased().contains("plate") {
                addNewWord(wordString: "plate", image: image!)
                
                if let plateEntity = wordEntities.first(where: { $0.word == "plate" }) {
                    for row in 2...6{
                        showAnswer[row][3] = plateEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "plate"
                showimagePop = true
            }

        
        }
        
        
        
        
        
        .sheet(isPresented: $gameState.showingCamera) {
            CameraView(image: $image, recognizedObjects: $recognizedObjects, highestConfidenceWord: $highestConfidenceWord)
        }
        
    }
//    func checkAndReveal(forkEntity: Word) {
//        for _ in 0...1 {
//            if forkEntity.controlshow {
//                showAnswer[1][5] = true
//                showAnswer[2][5] = true
//                showAnswer[3][5] = true
//                showAnswer[4][5] = true
//                
//            }
//            break
//        }
//    }
    func checkAndReveal(wordEntity: Word) {
        for _ in 0...1 {
            if wordEntity.controlshow {
                switch wordEntity.word {
                case "spoon":
                    for col in 2...7{
                        showAnswer[2][col] = true
                    }
                    
                case "fork":
                    for row in 1...4{
                        showAnswer[row][5] = true
                    }
                    
                    
                case "knife":
                    for col in 5...9{
                        showAnswer[4][col] = true
                    }
                    
                    
                case "plate":
                    for row in 2...6{
                        showAnswer[row][3] = true
                    }
                    
                default:
                    break
                }
            }
            break 
        }
    }


}







#Preview {
    let gameState = GameState()
    let uiState = UIState()
    
    return HomeGame2()
        .environmentObject(gameState)
        .environmentObject(uiState)
}
