








import SwiftUI
import AVFoundation
import UIKit

struct HomeGame4: View {
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
        GameView_1_4(showAnswer: $showAnswer, showingCamera: $gameState.showingCamera)
            .onAppear {
                    uiState.isNavBarVisible = false
                        }
//            .onDisappear {
//                    uiState.isNavBarVisible = true
//                        }
//        Text(highestConfidenceWord)
//
        
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
                    if showimagePop {
                        ZStack {
                            FoundWordPopup(image: image, foundWord: passToFoundWordSeetWord, showimagePop: $showimagePop)
                        }
                    }
                }
            }
        )
        .onAppear {
            let wordsToCheck = ["tire", "scooter", "bicycle", "box", "car"]
            
            for word in wordsToCheck {
                if let wordEntity = wordEntities.first(where: { $0.word == word }) {
                    checkAndReveal(wordEntity: wordEntity)
                }
            }
        }

        .onChange(of: highestConfidenceWord) { newValue in
            if newValue.lowercased().contains("tire") {
                addNewWord(wordString: "tire", image: image!)
                
                if let tireEntity = wordEntities.first(where: { $0.word == "tire" }) {
                    for row in 2...4{
                        showAnswer[row][3] = tireEntity.controlshow
                    }
                    
                }
                passToFoundWordSeetWord = "scooter"
                showimagePop = true
                
            }else if newValue.lowercased().contains("scooter") {
                addNewWord(wordString: "scooter", image: image!)
                
                if let scooterEntity = wordEntities.first(where: { $0.word == "scooter" }) {
                    for row in 2...8{
                        showAnswer[row][6] = scooterEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "scooter"
                showimagePop = true
                
            }else if newValue.lowercased().contains("bicycle") {
                addNewWord(wordString: "bicycle", image: image!)
                
                if let bicycleEntity = wordEntities.first(where: { $0.word == "bicycle" }) {
                    for col in 2...8{
                        showAnswer[3][col] = bicycleEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "bicycle"
                showimagePop = true
                
            }else if newValue.lowercased().contains("box") {
                addNewWord(wordString: "box", image: image!)
                
                if let boxEntity = wordEntities.first(where: { $0.word == "box" }) {
                    for col in 5...7{
                        showAnswer[5][col] = boxEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "box"
                showimagePop = true
                
            }else if newValue.lowercased().contains("car") {
                addNewWord(wordString: "car", image: image!)
                
                if let carEntity = wordEntities.first(where: { $0.word == "car" }) {
                    for col in 3...5{
                        showAnswer[8][col] = carEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "car"
                showimagePop = true
            }

        
        }
        
        
        
        
        
        .sheet(isPresented: $gameState.showingCamera) {
            CameraView(image: $image, recognizedObjects: $recognizedObjects, highestConfidenceWord: $highestConfidenceWord)
        }
        
    }
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
    
    return HomeGame4()
        .environmentObject(gameState)
        .environmentObject(uiState)
}
