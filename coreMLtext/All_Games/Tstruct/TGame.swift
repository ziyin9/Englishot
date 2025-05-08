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

struct TGame: View {
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
    
    // Add new state variables for confidence views
    @State private var showHighConfidenceView: Bool = false
    @State private var showMediumConfidenceView: Bool = false
    @State private var showLowConfidenceView: Bool = false
    @State private var confidenceLevel: Double = 0.0
    
    var levelData: GameLevelData
    var ML_model: String?
    
    var body: some View {
        NavigationStack {
            
            
            ZStack {
                ZStack {
                    GameView(showAnswer: $showAnswer, showingCamera: $gameState.showingCamera, title: levelData.title)
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
                    } else if showHighConfidenceView {
                        HighConfidenceView(
                            image: image,
                            recognizedWord: highestConfidenceWord,
                            confidenceLevel: confidenceLevel,
                            showHighConfidenceView: $showHighConfidenceView,
                            showingCamera: $gameState.showingCamera,
                            onSave: {
                                saveRecognizedWord()
                            }
                        )
                    } else if showMediumConfidenceView {
                        MediumConfidenceView(
                            image: image,
                            recognizedWord: highestConfidenceWord,
                            confidenceLevel: confidenceLevel,
                            showMediumConfidenceView: $showMediumConfidenceView,
                            showingCamera: $gameState.showingCamera,
                            onSaveAnyway: {
                                // 不再需要儲存功能，保留空實現
                            }
                        )
                    } else if showLowConfidenceView {
                        LowConfidenceView(
                            image: image,
                            confidenceLevel: confidenceLevel,
                            showLowConfidenceView: $showLowConfidenceView,
                            showingCamera: $gameState.showingCamera
                        )
                    } else if showRecognitionErrorView {
                        ErrorView(
                            showRecognitionErrorView: $showRecognitionErrorView, 
                            showingCamera: $gameState.showingCamera,
                            errorMessage: highestConfidenceWord.contains("不在當前關卡中") ? 
                                "您拍攝的物品不屬於當前關卡，請嘗試找尋與關卡相關的物品" : 
                                "未能成功辨識物品，請再試一次",
                            recognizedWord: highestConfidenceWord,
                            isWrongLevel: highestConfidenceWord.contains("不在當前關卡中")
                        )
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
                        else if showHighConfidenceView {
                            HighConfidenceView(
                                image: image,
                                recognizedWord: highestConfidenceWord,
                                confidenceLevel: confidenceLevel,
                                showHighConfidenceView: $showHighConfidenceView,
                                showingCamera: $gameState.showingCamera,
                                onSave: {
                                    saveRecognizedWord()
                                }
                            )
                        } else if showMediumConfidenceView {
                            MediumConfidenceView(
                                image: image,
                                recognizedWord: highestConfidenceWord,
                                confidenceLevel: confidenceLevel,
                                showMediumConfidenceView: $showMediumConfidenceView,
                                showingCamera: $gameState.showingCamera,
                                onSaveAnyway: {
                                    // 不再需要儲存功能，保留空實現
                                }
                            )
                        } else if showLowConfidenceView {
                            LowConfidenceView(
                                image: image,
                                confidenceLevel: confidenceLevel,
                                showLowConfidenceView: $showLowConfidenceView,
                                showingCamera: $gameState.showingCamera
                            )
                        } else if showRecognitionErrorView {
                            ErrorView(
                                showRecognitionErrorView: $showRecognitionErrorView, 
                                showingCamera: $gameState.showingCamera,
                                errorMessage: highestConfidenceWord.contains("不在當前關卡中") ? 
                                    "您拍攝的物品不屬於當前關卡，請嘗試找尋與關卡相關的物品" : 
                                    "未能成功辨識物品，請再試一次",
                                recognizedWord: highestConfidenceWord,
                                isWrongLevel: highestConfidenceWord.contains("不在當前關卡中")
                            )
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

            
            .onChange(of: highestConfidenceWord) { oldValue, newValue in
                processRecognizedWord(newValue)
            }
            
            // In TGame.swift
            .sheet(isPresented: $gameState.showingCamera, onDismiss: {
                // Reset relevant state when closing camera
//                highestConfidenceWord = ""
            }) {
                CameraView(
                    image: $image,
                    recognizedObjects: $recognizedObjects,
                    highestConfidenceWord: $highestConfidenceWord,
                    showRecognitionErrorView: $showRecognitionErrorView,
                    showHighConfidenceView: $showHighConfidenceView,
                    showMediumConfidenceView: $showMediumConfidenceView,
                    showLowConfidenceView: $showLowConfidenceView,
                    confidenceLevel: $confidenceLevel,
                    MLModel: ML_model,
                    levelWords: levelData.game_vocabulary.map { $0.E_word } // 傳遞當前關卡的單字列表
                )
            }
        }
        
        
    }
    
    // Helper function to save recognized word and show success animation
    private func saveRecognizedWord() {
        guard !highestConfidenceWord.isEmpty else { return }
        
        let lowercasedWord = highestConfidenceWord.components(separatedBy: " - ").first?.lowercased() ?? highestConfidenceWord.lowercased()
        
        // Check if this word is in our game vocabulary
        if levelData.game_vocabulary.contains(where: { $0.E_word.lowercased() == lowercasedWord }) {
            addNewWord(wordString: lowercasedWord, image: image!)
            
            // Find and reveal the word in the game
            if let wordEntity = wordEntities.first(where: { $0.word == lowercasedWord }) {
                revealWord(wordEntity: wordEntity)
            }
            
            // 準備單字資料但暫時不顯示FoundWordPopup
            passToFoundWordSeetWord = lowercasedWord
            // showimagePop = true  // 暫時註解掉，不顯示FoundWordPopup
        }
    }
    
    private func processRecognizedWord(_ word: String) {
        // Words are now being handled by the confidence views
        // This method is now mostly for legacy compatibility
        guard !word.isEmpty else { return }
        
        // Extract word without confidence number
        let lowercasedWord = word.components(separatedBy: " - ").first?.lowercased() ?? word.lowercased()
        print("🔍 辨識到單字: \(lowercasedWord)")

        // We'll let the confidence views handle the actual word processing
        // No need to show any of these if our confidence views are active
        if !showHighConfidenceView && !showMediumConfidenceView && !showLowConfidenceView {
            // Check if the word is in our vocabulary for error cases
            if !levelData.game_vocabulary.contains(where: { $0.E_word.lowercased() == lowercasedWord }) {
                showRecognitionErrorView = true
                print("⚠️ '\(lowercasedWord)' 不在 game_vocabulary 裡")
            }
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
#Preview {
    let gameState = GameState()
    let uiState = UIState()
    
    return TGame(levelData: BathroomData, ML_model:"daf") // 這裡改成適用於所有關卡
            .environmentObject(gameState)
            .environmentObject(uiState)
}
