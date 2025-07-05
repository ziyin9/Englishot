//
//  TutorialManager.swift
//  Englishot
//
//  Created by AI Assistant on 2025/1/1.
//

import SwiftUI
import Combine

// 教程步驟枚舉
enum TutorialStep: Int, CaseIterable {
    case welcome = 0
    case navigateToMap = 1
    case selectHome = 2
    case selectKitchen = 3
    case takePhotoSpoon = 4
    case navigateToBackpack = 5
    case learnSpoonWord = 6
    case navigateToMinigame = 7
    case playSpellingGame = 8
    case navigateToGacha = 9
    case drawCard = 10
    case completed = 11
    
    var title: String {
        switch self {
        case .welcome:
            return "歡迎來到 Englishot！"
        case .navigateToMap:
            return "前往地圖"
        case .selectHome:
            return "選擇家主題"
        case .selectKitchen:
            return "進入廚房"
        case .takePhotoSpoon:
            return "拍照湯匙"
        case .navigateToBackpack:
            return "前往背包"
        case .learnSpoonWord:
            return "學習單字"
        case .navigateToMinigame:
            return "前往小遊戲"
        case .playSpellingGame:
            return "玩拼字遊戲"
        case .navigateToGacha:
            return "前往抽卡"
        case .drawCard:
            return "抽取卡片"
        case .completed:
            return "教程完成！"
        }
    }
    
    var description: String {
        switch self {
        case .welcome:
            return "讓我們一起開始學習英語的旅程吧！"
        case .navigateToMap:
            return "點擊底部的地圖按鈕前往遊戲地圖"
        case .selectHome:
            return "點擊地圖上的家主題圖標"
        case .selectKitchen:
            return "選擇廚房場景開始遊戲"
        case .takePhotoSpoon:
            return "點擊相機按鈕，然後拍照湯匙物件"
        case .navigateToBackpack:
            return "點擊底部的背包按鈕查看收集的單字"
        case .learnSpoonWord:
            return "點擊湯匙卡片學習這個單字"
        case .navigateToMinigame:
            return "點擊底部的小遊戲按鈕"
        case .playSpellingGame:
            return "選擇拼字遊戲來複習剛學的單字"
        case .navigateToGacha:
            return "點擊底部的抽卡按鈕"
        case .drawCard:
            return "使用賺到的金幣抽取企鵝卡片"
        case .completed:
            return "恭喜！你已經完成了新手教程，現在可以自由探索遊戲了！"
        }
    }
    
    var targetView: String {
        switch self {
        case .welcome:
            return "welcome"
        case .navigateToMap:
            return "tabbar_map"
        case .selectHome:
            return "map_home"
        case .selectKitchen:
            return "home_kitchen"
        case .takePhotoSpoon:
            return "camera_button"
        case .navigateToBackpack:
            return "tabbar_backpack"
        case .learnSpoonWord:
            return "backpack_spoon"
        case .navigateToMinigame:
            return "tabbar_minigame"
        case .playSpellingGame:
            return "minigame_spelling"
        case .navigateToGacha:
            return "tabbar_gacha"
        case .drawCard:
            return "gacha_draw"
        case .completed:
            return "completed"
        }
    }
}

// 教程管理器
class TutorialManager: ObservableObject {
    @Published var isActive = false
    @Published var currentStep: TutorialStep = .welcome
    @Published var highlightedView: String = ""
    @Published var showArrow = false
    @Published var arrowPosition: CGPoint = .zero
    @Published var arrowDirection: ArrowDirection = .down
    
    private let userDefaults = UserDefaults.standard
    private let tutorialCompletedKey = "tutorialCompleted"
    private let currentStepKey = "currentTutorialStep"
    
    init() {
        loadTutorialState()
    }
    
    // 檢查是否需要顯示教程
    var shouldShowTutorial: Bool {
        return !userDefaults.bool(forKey: tutorialCompletedKey)
    }
    
    // 開始教程
    func startTutorial() {
        guard shouldShowTutorial else { return }
        isActive = true
        currentStep = .welcome
        highlightedView = currentStep.targetView
        saveTutorialState()
    }
    
    // 前進到下一步
    func nextStep() {
        guard let nextStep = TutorialStep(rawValue: currentStep.rawValue + 1) else {
            completeTutorial()
            return
        }
        
        currentStep = nextStep
        highlightedView = currentStep.targetView
        updateArrowForCurrentStep()
        saveTutorialState()
        
        if currentStep == .completed {
            completeTutorial()
        }
    }
    
    // 跳過教程
    func skipTutorial() {
        completeTutorial()
    }
    
    // 完成教程
    func completeTutorial() {
        isActive = false
        userDefaults.set(true, forKey: tutorialCompletedKey)
        userDefaults.removeObject(forKey: currentStepKey)
        hideArrow()
    }
    
    // 重置教程
    func resetTutorial() {
        userDefaults.removeObject(forKey: tutorialCompletedKey)
        userDefaults.removeObject(forKey: currentStepKey)
        currentStep = .welcome
        isActive = false
        highlightedView = ""
        hideArrow()
    }
    
    // 顯示箭頭指示
    func showArrow(at position: CGPoint, direction: ArrowDirection) {
        arrowPosition = position
        arrowDirection = direction
        showArrow = true
    }
    
    // 隱藏箭頭指示
    func hideArrow() {
        showArrow = false
    }
    
    // 更新當前步驟的箭頭位置
    private func updateArrowForCurrentStep() {
        // 這裡可以根據不同的步驟設置箭頭的位置和方向
        // 具體位置會在各個 View 中動態設置
    }
    
    // 保存教程狀態
    private func saveTutorialState() {
        userDefaults.set(currentStep.rawValue, forKey: currentStepKey)
    }
    
    // 載入教程狀態
    private func loadTutorialState() {
        if !userDefaults.bool(forKey: tutorialCompletedKey) {
            let savedStep = userDefaults.integer(forKey: currentStepKey)
            currentStep = TutorialStep(rawValue: savedStep) ?? .welcome
            highlightedView = currentStep.targetView
        }
    }
}

// 箭頭方向枚舉
enum ArrowDirection {
    case up, down, left, right, topLeft, topRight, bottomLeft, bottomRight
    
    var rotation: Double {
        switch self {
        case .up: return 0
        case .topRight: return 45
        case .right: return 90
        case .bottomRight: return 135
        case .down: return 180
        case .bottomLeft: return 225
        case .left: return 270
        case .topLeft: return 315
        }
    }
} 