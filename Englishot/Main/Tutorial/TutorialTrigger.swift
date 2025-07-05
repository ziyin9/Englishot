//
//  TutorialTrigger.swift
//  Englishot
//
//  Created by AI Assistant on 2025/1/1.
//

import SwiftUI

// 教程觸發器組件，用於檢測用戶操作並推進教程
struct TutorialTrigger: View {
    let stepToTrigger: TutorialStep
    let targetFrame: CGRect
    @ObservedObject var tutorialManager: TutorialManager
    let action: () -> Void
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: targetFrame.width, height: targetFrame.height)
            .position(x: targetFrame.midX, y: targetFrame.midY)
            .onTapGesture {
                if tutorialManager.isActive && tutorialManager.currentStep == stepToTrigger {
                    action()
                    tutorialManager.nextStep()
                } else {
                    action()
                }
            }
            .overlay(
                // 顯示高亮效果
                Group {
                    if tutorialManager.isActive && 
                       tutorialManager.currentStep == stepToTrigger &&
                       tutorialManager.highlightedView == stepToTrigger.targetView {
                        TutorialHighlight(
                            frame: targetFrame,
                            cornerRadius: 12
                        )
                    }
                }
            )
            .onAppear {
                // 當目標元素出現時，更新箭頭位置
                if tutorialManager.isActive && tutorialManager.currentStep == stepToTrigger {
                    updateArrowPosition()
                }
            }
    }
    
    private func updateArrowPosition() {
        let arrowPosition = calculateArrowPosition()
        let direction = calculateArrowDirection()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tutorialManager.showArrow(at: arrowPosition, direction: direction)
        }
    }
    
    private func calculateArrowPosition() -> CGPoint {
        // 根據目標框架計算箭頭位置
        switch stepToTrigger {
        case .navigateToMap, .navigateToBackpack, .navigateToMinigame, .navigateToGacha:
            // 對於底部導航欄，箭頭指向上方
            return CGPoint(x: targetFrame.midX, y: targetFrame.minY - 60)
        case .selectHome:
            // 對於地圖上的家圖標，箭頭指向左上方
            return CGPoint(x: targetFrame.maxX + 40, y: targetFrame.minY - 40)
        case .takePhotoSpoon:
            // 對於相機按鈕，箭頭指向左方
            return CGPoint(x: targetFrame.minX - 60, y: targetFrame.midY)
        default:
            // 默認位置：目標上方
            return CGPoint(x: targetFrame.midX, y: targetFrame.minY - 60)
        }
    }
    
    private func calculateArrowDirection() -> ArrowDirection {
        // 根據步驟計算箭頭方向
        switch stepToTrigger {
        case .navigateToMap, .navigateToBackpack, .navigateToMinigame, .navigateToGacha:
            return .up
        case .selectHome:
            return .bottomLeft
        case .takePhotoSpoon:
            return .left
        case .selectKitchen, .learnSpoonWord, .playSpellingGame, .drawCard:
            return .down
        default:
            return .down
        }
    }
}

// 簡化版觸發器，用於簡單的按鈕觸發
struct SimpleTutorialTrigger: ViewModifier {
    let stepToTrigger: TutorialStep
    @ObservedObject var tutorialManager: TutorialManager
    let onTrigger: () -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay(
                // 高亮效果
                Group {
                    if tutorialManager.isActive && 
                       tutorialManager.currentStep == stepToTrigger &&
                       tutorialManager.highlightedView == stepToTrigger.targetView {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.1))
                            )
                            .shadow(color: .blue, radius: 10)
                            .scaleEffect(1.05)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: tutorialManager.currentStep
                            )
                    }
                }
            )
            .onTapGesture {
                if tutorialManager.isActive && tutorialManager.currentStep == stepToTrigger {
                    onTrigger()
                    // 延遲一點時間讓用戶看到操作效果
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        tutorialManager.nextStep()
                    }
                } else {
                    onTrigger()
                }
            }
            .background(
                // 用於獲取元素位置的隱藏視圖
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            if tutorialManager.isActive && tutorialManager.currentStep == stepToTrigger {
                                let frame = geometry.frame(in: .global)
                                updateArrowPosition(for: frame)
                            }
                        }
                        .onChange(of: tutorialManager.currentStep) { newStep in
                            if newStep == stepToTrigger {
                                let frame = geometry.frame(in: .global)
                                updateArrowPosition(for: frame)
                            }
                        }
                }
            )
    }
    
    private func updateArrowPosition(for frame: CGRect) {
        let arrowPosition = calculateArrowPosition(for: frame)
        let direction = calculateArrowDirection()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tutorialManager.showArrow(at: arrowPosition, direction: direction)
        }
    }
    
    private func calculateArrowPosition(for frame: CGRect) -> CGPoint {
        switch stepToTrigger {
        case .navigateToMap, .navigateToBackpack, .navigateToMinigame, .navigateToGacha:
            return CGPoint(x: frame.midX, y: frame.minY - 60)
        case .selectHome:
            return CGPoint(x: frame.maxX + 40, y: frame.minY - 40)
        case .takePhotoSpoon:
            return CGPoint(x: frame.minX - 60, y: frame.midY)
        default:
            return CGPoint(x: frame.midX, y: frame.minY - 60)
        }
    }
    
    private func calculateArrowDirection() -> ArrowDirection {
        switch stepToTrigger {
        case .navigateToMap, .navigateToBackpack, .navigateToMinigame, .navigateToGacha:
            return .up
        case .selectHome:
            return .bottomLeft
        case .takePhotoSpoon:
            return .left
        default:
            return .down
        }
    }
}

// 擴展 View 以支援教程觸發器
extension View {
    func tutorialTrigger(
        step: TutorialStep,
        tutorialManager: TutorialManager,
        onTrigger: @escaping () -> Void
    ) -> some View {
        self.modifier(
            SimpleTutorialTrigger(
                stepToTrigger: step,
                tutorialManager: tutorialManager,
                onTrigger: onTrigger
            )
        )
    }
} 