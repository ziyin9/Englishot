//
//  TutorialOverlay.swift
//  Englishot
//
//  Created by AI Assistant on 2025/1/1.
//

import SwiftUI

struct TutorialOverlay: View {
    @ObservedObject var tutorialManager: TutorialManager
    @EnvironmentObject var uiState: UIState
    
    var body: some View {
        ZStack {
            // 非阻塞式教程指引
            if tutorialManager.isActive {
                // 教程指引卡片 - 使用絕對定位避免影響佈局
                TutorialCard(
                    step: tutorialManager.currentStep,
                    onSkip: {
                        tutorialManager.skipTutorial()
                    }
                )
                .environmentObject(tutorialManager)
                .position(x: UIScreen.main.bounds.width / 2, y: 60) // 調整更靠近頂部
                .zIndex(999)
                .transition(.move(edge: .top).combined(with: .opacity))
                
                // 箭頭指示
                if tutorialManager.showArrow {
                    TutorialArrow(
                        direction: tutorialManager.arrowDirection,
                        position: tutorialManager.arrowPosition
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .allowsHitTesting(tutorialManager.isActive) // 只有在教程激活時才允許點擊（跳過按鈕）
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: tutorialManager.isActive)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: tutorialManager.showArrow)
    }
}

struct TutorialCard: View {
    let step: TutorialStep
    let onSkip: () -> Void
    
    @EnvironmentObject var tutorialManager: TutorialManager
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    
    var body: some View {
        HStack(spacing: 10) {
            // 企鵝圖標
            Image("penguinnn")
                .resizable()
                .frame(width: 32, height: 32)
                .scaleEffect(1.0 + sin(Date().timeIntervalSince1970 * 2) * 0.05)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: cardOpacity)
            
            VStack(alignment: .leading, spacing: 4) {
                // 步驟指示器
                HStack {
                    ForEach(0..<TutorialStep.allCases.count - 1, id: \.self) { index in
                        Circle()
                            .fill(index <= step.rawValue ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 4, height: 4)
                            .scaleEffect(index == step.rawValue ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: step)
                        
                        if index < TutorialStep.allCases.count - 2 {
                            Rectangle()
                                .fill(index < step.rawValue ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 1)
                        }
                    }
                }
                
                // 標題
                Text(step.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // 描述
                Text(step.description)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
            }
            
            Spacer()
            
            // 按鈕區域
            if step == .welcome {
                Button("開始") {
                    // 歡迎步驟需要手動開始
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        tutorialManager.nextStep()
                    }
                }
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(LinearGradient(
                            colors: [Color.blue, Color.cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                )
                .allowsHitTesting(true)
            } else if step == .completed {
                Button("完成") {
                    onSkip() // 完成教程
                }
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(LinearGradient(
                            colors: [Color.green, Color.mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                )
                .allowsHitTesting(true)
            } else {
                Button("跳過") {
                    onSkip()
                }
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.gray.opacity(0.6))
                )
                .allowsHitTesting(true)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.1, green: 0.2, blue: 0.4).opacity(0.95),
                            Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.95)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 6)
        )
        .scaleEffect(cardScale)
        .opacity(cardOpacity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
        }
    }
}

struct TutorialArrow: View {
    let direction: ArrowDirection
    let position: CGPoint
    
    @State private var animationOffset: CGFloat = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var body: some View {
        Image(systemName: "arrow.down.circle.fill")
            .font(.system(size: 40, weight: .bold))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.yellow, Color.orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .background(
                Circle()
                    .fill(Color.white)
                    .frame(width: 44, height: 44)
            )
            .shadow(color: .black.opacity(0.3), radius: 5)
            .rotationEffect(.degrees(direction.rotation))
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(
                x: animationOffset * cos(direction.rotation * .pi / 180),
                y: animationOffset * sin(direction.rotation * .pi / 180)
            )
            .position(position)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
                
                // 箭頭跳動動畫
                withAnimation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true)
                ) {
                    animationOffset = 10
                }
            }
    }
}

struct TutorialHighlight: View {
    let frame: CGRect
    let cornerRadius: CGFloat
    
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(glowIntensity),
                        Color.cyan.opacity(glowIntensity),
                        Color.blue.opacity(glowIntensity)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 3
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.blue.opacity(0.1))
            )
            .frame(width: frame.width, height: frame.height)
            .position(x: frame.midX, y: frame.midY)
            .shadow(color: .blue, radius: 10)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                ) {
                    glowIntensity = 1.0
                }
            }
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        TutorialOverlay(tutorialManager: TutorialManager())
            .environmentObject(UIState())
    }
} 