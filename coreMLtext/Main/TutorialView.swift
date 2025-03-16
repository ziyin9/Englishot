//
//  TutorialView.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/16/25.
//


//
//  TutorialView.swift
//  Englishot
//
//  Created by 李庭宇 on 2025/3/16.
//

import SwiftUI

struct TutorialView: View {
    @Binding var showTutorial: Bool
    @State private var stepIndex = 0
    @State private var isAnimating = false
    
    let tutorialSteps = [
        ("Step 1", "Welcome!", "food"),
        ("Step 2", "Click here to access settings.", "fruit"),
        ("Step 3", "Adjust your preferences here.", "Fruit"),
        ("Step 4", "You're ready to go!", "tutorial4")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景漸層效果和點擊事件
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 3)
                
                // 主要內容
                VStack(spacing: -40) {
                    // 教學圖片區域
                    Image(tutorialSteps[stepIndex].2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.6)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: .blue.opacity(0.3), radius: 8)
                        .padding(.top, geometry.safeAreaInsets.top + 60)
                    // 企鵝與對話框區域
                    HStack(spacing: 5) {
                        // 企鵝
                        Image("8")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.4, height:geometry.size.height * 0.4)
                            .rotationEffect(.degrees(isAnimating ? 5 : -5))
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        // 對話框
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.5, height:geometry.size.height * 0.2)
                                .shadow(color: .blue.opacity(0.2), radius: 10)
                            
                            // 文字內容
                            VStack(spacing: 8) {
                                Text(tutorialSteps[stepIndex].0)
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .blue.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                Text(tutorialSteps[stepIndex].1)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .foregroundColor(.blue.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 240)
                            }
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if stepIndex < tutorialSteps.count - 1 {
                    withAnimation {
                        stepIndex += 1
                    }
                } else {
                    withAnimation {
                        showTutorial = false
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// 自定義導航按鈕
//struct NavigationButton: View {
//    let text: String
//    let color: Color
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//
//        }
//    }
//}