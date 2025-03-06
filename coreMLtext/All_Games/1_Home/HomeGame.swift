//
//  HomeView.swift
//  Englishot
//
//  Created by 李庭宇 on 2025/2/25.
//

import SwiftUI
import AVFoundation
import UIKit

struct HomeGame: View {
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
    
    var levelData: GameLevelData
//    let wordsToCheck = ["comb", "toothbrush", "toilet", "towel","soap"]
    
    var body: some View {
        NavigationStack {
            
            
            ZStack {
                GameView(showAnswer: $showAnswer, showingCamera: $gameState.showingCamera, levelID: levelData.levelID)
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
                for word in levelData.wordsToCheck {
                    if let wordEntity = wordEntities.first(where: { $0.word == word }) {
                        checkAndReveal(wordEntity: wordEntity)
                    }
                }
            }
            
            .onChange(of: highestConfidenceWord) { newValue in
                            processRecognizedWord(newValue)
                        }
            
            .sheet(isPresented: $gameState.showingCamera) {
                CameraView(image: $image, recognizedObjects: $recognizedObjects, highestConfidenceWord: $highestConfidenceWord)
            }
            
        }
        
        
    }
    private func processRecognizedWord(_ word: String) {
            let lowercasedWord = word.components(separatedBy: " - ").first?.lowercased() ?? word.lowercased()
            print("🔍 辨識到單字: \(lowercasedWord)")
            if levelData.wordsToCheck.contains(lowercasedWord) {
                print("✅ '\(lowercasedWord)' 在 wordsToCheck 裡")
                addNewWord(wordString: lowercasedWord, image: image!)
                if let wordEntity = wordEntities.first(where: { $0.word == lowercasedWord }) {
                    revealWord(wordEntity: wordEntity)
                }
                passToFoundWordSeetWord = lowercasedWord
                showimagePop = true
                print("✅ showimagePop 設為 true，應該顯示 FoundWordPopup")
            }
        else {
                print("⚠️ '\(lowercasedWord)' 不在 wordsToCheck 裡") // ❌ 單字不在 wordsToCheck，問題可能出在這裡！
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
                
                allWordsFound = levelData.wordsToCheck.allSatisfy { word in
                    wordEntities.first(where: { $0.word == word })?.controlshow ?? false
                }
            }
}
#Preview {
    let gameState = GameState()
    let uiState = UIState()
    
    return HomeGame(levelData: BathroomData) // 這裡改成適用於所有關卡
            .environmentObject(gameState)
            .environmentObject(uiState)
}
