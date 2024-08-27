import SwiftUI
import AVFoundation
import UIKit

struct HomeGame1: View {
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
    
    
    let wordsToCheck = ["comb", "toothbrush", "toilet", "towel","soap"]
    
    var body: some View {
        NavigationStack {
            
            
            ZStack {
                GameView_1_1(showAnswer: $showAnswer, showingCamera: $gameState.showingCamera)
                    .onAppear {
                        uiState.isNavBarVisible = false
                        checkAllWordsFound()
                        
                    }
                if allWordsFound {
                    Image("finish")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(0.2)
                        .offset(y: -180)
                }
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
                        
                        if showimagePop {
                            ZStack {
                                FoundWordPopup(image: image, foundWord: passToFoundWordSeetWord, showimagePop: $showimagePop)
                            }
                        }
                    }
                }
            )
            
            .onAppear {
                
                
                for word in wordsToCheck {
                    if let wordEntity = wordEntities.first(where: { $0.word == word }) {
                        checkAndReveal(wordEntity: wordEntity)
                    }
                }
            }
            
            .onChange(of: highestConfidenceWord) { newValue in
                if newValue.lowercased().contains("comb") {
                    addNewWord(wordString: "comb", image: image!)
                    
                    if let combEntity = wordEntities.first(where: { $0.word == "comb" }) {
                        for col in 2...5{
                            showAnswer[1][col] = combEntity.controlshow
                        }
                    }
                    passToFoundWordSeetWord = "comb"
                    showimagePop = true
                    
                }else if newValue.lowercased().contains("toothbrush") {
                    addNewWord(wordString: "toothbrush", image: image!)
                    
                    if let toothbrushEntity = wordEntities.first(where: { $0.word == "toothbrush" }) {
                        for row in 0...9 {
                            showAnswer[row][3] = toothbrushEntity.controlshow
                        }
                    }
                    passToFoundWordSeetWord = "toothbrush"
                    showimagePop = true
                    
                }else if newValue.lowercased().contains("toilet") {
                    addNewWord(wordString: "toilet", image: image!)
                    
                    if let toiletEntity = wordEntities.first(where: { $0.word == "toilet" }) {
                        for row in 0...5 {
                            showAnswer[row][7] = toiletEntity.controlshow
                        }
                    }
                    passToFoundWordSeetWord = "toilet"
                    showimagePop = true
                    
                }else if newValue.lowercased().contains("towel") {
                    addNewWord(wordString: "towel", image: image!)
                    
                    if let towelEntity = wordEntities.first(where: { $0.word == "towel" }) {
                        for col in 3...7 {
                            showAnswer[3][col] = towelEntity.controlshow
                        }
                    }
                    passToFoundWordSeetWord = "towel"
                    showimagePop = true
                    
                }else if newValue.lowercased().contains("soap") {
                    addNewWord(wordString: "soap", image: image!)
                    
                    if let soapEntity = wordEntities.first(where: { $0.word == "soap" }) {
                        for col in 3...6 {
                            showAnswer[8][col] = soapEntity.controlshow
                        }
                    }
                    passToFoundWordSeetWord = "soap"
                    showimagePop = true
                }
                
            }
            
            .sheet(isPresented: $gameState.showingCamera) {
                CameraView(image: $image, recognizedObjects: $recognizedObjects, highestConfidenceWord: $highestConfidenceWord)
            }
            
        }
        
    }

    
    func checkAndReveal(wordEntity: Word) {
        for _ in 0...1 {
            if wordEntity.controlshow {
                switch wordEntity.word {
                case "comb":
                    for col in 2...5{
                        showAnswer[1][col] = true
                        checkAllWordsFound()
                    }
                    
                case "toothbrush":
                    for row in 0...9 {
                        showAnswer[row][3] = true
                        checkAllWordsFound()
                    }
                case "toilet":
                    for row in 0...5 {
                        showAnswer[row][7] = true
                        checkAllWordsFound()
                    }
                    
                case "towel":
                    for col in 3...7 {
                        showAnswer[3][col] = true
                        checkAllWordsFound()
                    }
                    
                case "soap":
                    for col in 3...6 {
                        showAnswer[8][col] = true
                        checkAllWordsFound()
                    }
                default:
                    break // Handle unexpected words if needed
                }
            }
            break // Exit after one iteration regardless of condition
        }
        
    }
    func checkAllWordsFound() {
                
                allWordsFound = wordsToCheck.allSatisfy { word in
                    wordEntities.first(where: { $0.word == word })?.controlshow ?? false
                }
            }
}
#Preview {
    let gameState = GameState()
    let uiState = UIState()
    
    return HomeGame1()
        .environmentObject(gameState)
        .environmentObject(uiState)
}
