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
    
    // Add new state variables for confidence views
    @State private var showHighConfidenceView: Bool = false
    @State private var showMediumConfidenceView: Bool = false
    @State private var showLowConfidenceView: Bool = false
    @State private var confidenceLevel: Double = 0.0
    
    // 添加相機提示狀態
    @State private var showCameraHint: Bool = false
    @AppStorage("neverShowCameraHint") private var neverShowCameraHint: Bool = false
    
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
                    
                    // 相機提示視圖
                    if showCameraHint {
                        CameraHintView(
                            showCameraHint: $showCameraHint,
                            neverShowAgain: $neverShowCameraHint,
                            onConfirm: {
                                showCameraHint = false
                                gameState.showingCamera = true
                            }
                        )
                    }

                    if uiState.showGameCardView {
                        GameCardView(vocabulary: levelData.game_vocabulary)
                            .environmentObject(uiState)
                            .zIndex(1)
                    }
                }
                
                // 金幣獎勵動畫
                if uiState.showCoinReward {
                    CoinRewardView(amount: Int64(uiState.coinRewardAmount), delay: 0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                        .zIndex(100)
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
            
            // 修改工具欄相機按鈕的動作
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton {
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
                        
                        Button(action: {
                            // 檢查是否需要顯示提示
                            if neverShowCameraHint {
                                gameState.showingCamera = true
                            } else {
                                showCameraHint = true
                            }
                        }) {
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
            
            // In TGame.swift
            .sheet(isPresented: $gameState.showingCamera, onDismiss: {
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
                    levelWords: levelData.game_vocabulary.map { $0.E_word }
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
            let isFirstTimeCollection = addNewWord(wordString: lowercasedWord, image: image!)
            
            // 如果是第一次收集，顯示金幣獎勵動畫
            if isFirstTimeCollection {
                uiState.coinRewardAmount = 20
                uiState.showCoinReward = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    uiState.showCoinReward = false
                }
            }
            
            // Find and reveal the word in the game
            if let wordEntity = wordEntities.first(where: { $0.word == lowercasedWord }) {
                revealWord(wordEntity: wordEntity)
            }
            
            // 準備單字資料但暫時不顯示FoundWordPopup
            passToFoundWordSeetWord = lowercasedWord
            // showimagePop = true  // 暫時註解掉，不顯示FoundWordPopup
            
            // 檢查是否所有單字都找到了
            checkAllWordsFound()
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
//#Preview {
//    let gameState = GameState()
//    let uiState = UIState()
//    
//    return TGame_2(levelData_2: BirdsData, ML_model:"daf") // 這裡改成適用於所有關卡
//            .environmentObject(gameState)
//            .environmentObject(uiState)
//}

struct CameraHintView: View {
    @Binding var showCameraHint: Bool
    @Binding var neverShowAgain: Bool
    var onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("相機使用提示")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                Text("一次只能拍攝一張物品，並保持背景乾淨，光線充足。")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack {
                    Toggle("不再顯示", isOn: $neverShowAgain)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                .padding(.horizontal)
                
                Button(action: onConfirm) {
                    Text("我明白了")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding(.horizontal, 40)
        }
    }
}
