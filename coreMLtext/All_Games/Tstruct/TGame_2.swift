//
//  TGame 2.swift
//  Englishot
//
//  Created by 陳姿縈 on 4/29/25.
//


//
//  HomeView.swift
//  Englishot
//
//  Created by 李庭宇 on 2025/2/25.
//

import SwiftUI
import AVFoundation
import UIKit
import Vision

struct TGame_2: View {
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
    
    @State private var showRecognitionErrorView: Bool = false
    
    var levelData: GameLevelData_2
    var ML_model: String?
    
    var body: some View {
        NavigationStack {
            
            
            ZStack {
                ZStack {
                    GameView_2(showAnswer: $showAnswer, showingCamera: $gameState.showingCamera, title: levelData.title)
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
                            .zIndex(0)
                            .allowsHitTesting(false)
                    }
                }
                ZStack {
                    if showimagePop {
                        FoundWordPopup(image: image, foundWord: passToFoundWordSeetWord, showimagePop: $showimagePop, onDismiss: {
                            highestConfidenceWord = ""
                            passToFoundWordSeetWord = nil
                        })
                    } else if showRecognitionErrorView {
                        ErrorView(showRecognitionErrorView: $showRecognitionErrorView, showingCamera: $gameState.showingCamera)
                    }

                    if uiState.showGameCardView {
                        GameCardView(vocabulary: levelData.game_vocabulary)
                            .environmentObject(uiState)
                            .zIndex(1)
                    }
                }
            }


            
            
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        
                        if showimagePop {
                            ZStack {
                                FoundWordPopup(image: image, foundWord: passToFoundWordSeetWord, showimagePop: $showimagePop,onDismiss: {
                                    // Reset state
                                    highestConfidenceWord = ""
                                    passToFoundWordSeetWord = nil
                                })
                            }
                        }
                        else if showRecognitionErrorView {
                                                    ErrorView(showRecognitionErrorView: $showRecognitionErrorView, showingCamera: $gameState.showingCamera)
                                                    }
                    }
                }
            )
            
            .onAppear {
                for vocabulary in levelData.game_vocabulary {
                    if let wordEntity = wordEntities.first(where: { $0.word == vocabulary.E_word }) {
                        checkAndReveal(wordEntity: wordEntity)
                    }
                }
            }

            
            .onChange(of: highestConfidenceWord) { oldValue,newValue in
                            processRecognizedWord(newValue)
                        }
            
            // In TGame.swift
            .sheet(isPresented: $gameState.showingCamera, onDismiss: {
            }) {
                CameraView(image: $image, recognizedObjects: $recognizedObjects, highestConfidenceWord: $highestConfidenceWord, showRecognitionErrorView: $showRecognitionErrorView, MLModel: ML_model)
            }
        }
        
        
    }
    private func processRecognizedWord(_ word: String) {
        // 檢查辨識到的單字是否為空
        guard !word.isEmpty else {
//            showRecognitionErrorView = true
//            print("⚠️ 辨識到的單字為空")
            return
        }

        let lowercasedWord = word.components(separatedBy: " - ").first?.lowercased() ?? word.lowercased()
        print("🔍 辨識到單字: \(lowercasedWord)")

        // 檢查 game_vocabulary 是否包含該單字
        if levelData.game_vocabulary.contains(where: { $0.E_word.lowercased() == lowercasedWord }) {
            print("✅ '\(lowercasedWord)' 在 game_vocabulary 裡")
            addNewWord(wordString: lowercasedWord, image: image!)
            
            // 根據 lowercasedWord 查找對應的 wordEntity
            if let wordEntity = wordEntities.first(where: { $0.word == lowercasedWord }) {
                revealWord(wordEntity: wordEntity)
            }
            
            passToFoundWordSeetWord = lowercasedWord
            showimagePop = true
            showRecognitionErrorView = false // 確保在正確辨識時不顯示錯誤視圖
            print("✅ showimagePop 設為 true，應該顯示 FoundWordPopup")
        } else {
            showRecognitionErrorView = true
            print("⚠️ '\(lowercasedWord)' 不在 game_vocabulary 裡") // ❌ 單字不在 game_vocabulary，問題可能出在這裡！
        }
    }

    
    private func checkAndReveal(wordEntity: Word) {
            if wordEntity.controlshow, let positions = levelData.wordPositions[wordEntity.word ?? "default"] {
                for position in positions {
                    showAnswer[position.row][position.col] = true
                }
            }
        }
    private func revealWord(wordEntity: Word) {
        if let positions = levelData.wordPositions[wordEntity.word ?? "default"] {
            for position in positions {
                showAnswer[position.row][position.col] = true
            }
        }
    }
    func checkAllWordsFound() {
        allWordsFound = levelData.game_vocabulary.allSatisfy { vocabulary in
            wordEntities.first(where: { $0.word == vocabulary.E_word })?.controlshow ?? false
        }
    }
}
//#Preview {
//    let gameState = GameState()
//    let uiState = UIState()
//    
//    return TGame_2(levelData_2: BirdsData, ML_model:"daf") // 這裡改成適用於所有關卡
//            .environmentObject(gameState)
//            .environmentObject(uiState)
//}
