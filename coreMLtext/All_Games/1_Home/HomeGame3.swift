//
//  HomeGame3.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 1/24/25.
//


//
//  HomeGame3.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/1/24.
//

import SwiftUI
import AVFoundation
import UIKit

struct HomeGame3: View {
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
        GameView_1_3(showAnswer: $showAnswer, showingCamera: $gameState.showingCamera)
            .onAppear {
                    uiState.isNavBarVisible = false
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
            let wordsToCheck = ["key", "sofa", "television", "fan"]
            
            for word in wordsToCheck {
                if let wordEntity = wordEntities.first(where: { $0.word == word }) {
                    checkAndReveal(wordEntity: wordEntity)
                }
            }
        }
//key sofa television fan
        .onChange(of: highestConfidenceWord) { newValue in
            if newValue.lowercased().contains("key") {
                addNewWord(wordString: "key", image: image!)
                
                if let forkEntity = wordEntities.first(where: { $0.word == "key" }) {
                    for row in 3...5{
                        showAnswer[row][2] = forkEntity.controlshow
                    }
                    
                }
                passToFoundWordSeetWord = "key"
                showimagePop = true
            }else if newValue.lowercased().contains("sofa") {
                addNewWord(wordString: "sofa", image: image!)
                
                if let spoonEntity = wordEntities.first(where: { $0.word == "sofa" }) {
                    for row in 3...6{
                        showAnswer[row][9] = spoonEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "sofa"
                showimagePop = true
            }else if newValue.lowercased().contains("television") {
                addNewWord(wordString: "television", image: image!)
                
                if let knifeEntity = wordEntities.first(where: { $0.word == "television" }) {
                    for col in 1...10{
                        showAnswer[4][col] = knifeEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "television"
                showimagePop = true
            }else if newValue.lowercased().contains("fan") {
                addNewWord(wordString: "fan", image: image!)
                
                if let plateEntity = wordEntities.first(where: { $0.word == "fan" }) {
                    for col in 8...10{
                        showAnswer[6][col] = plateEntity.controlshow
                    }
                }
                passToFoundWordSeetWord = "fan"
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
    //key sofa television fan
    func checkAndReveal(wordEntity: Word) {
        for _ in 0...1 {
            if wordEntity.controlshow {
                switch wordEntity.word {
                case "key":
                    for row in 3...5{
                        showAnswer[row][2] = true
                    }
                    
                case "sofa":
                    for row in 3...6{
                        showAnswer[row][9] = true
                    }
                    
                    
                case "television":
                    for col in 1...10{
                        showAnswer[4][col] = true
                    }
                    
                    
                case "fan":
                    for col in 8...10{
                        showAnswer[6][col] = true
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
    
    return HomeGame3()
        .environmentObject(gameState)
        .environmentObject(uiState)
}
