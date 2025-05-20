import SwiftUI

struct TutorialOverlayView: View {
    @Binding var isShowing: Bool
    @State private var currentStep = 0
    
    let steps: [TeachingStep] = [
        TeachingStep(
            imageName: "Tutorial1",
            title: "Welcome to Englishot",
            description: "主頁地圖選擇五大主題進去子關卡"
        ),
        TeachingStep(
            imageName: "Tutorial2",
            title: "Explore Locations",
            description: "以該主題出現的小關卡等你破解"
        ),
        TeachingStep(
            imageName: "Tutorial3",
            title: "Complete Challenges",
            description: "仔細觀察背景圖的小提示喔～還有下方的例句"
        ),
        TeachingStep(
            imageName: "Tutorial4",
            title: "Complete Challenges",
            description: "點擊右上角的相機我們來進行拍照收集吧！一次只能一個物品喔"
        ),
        TeachingStep(
            imageName: "Tutorial5",
            title: "Complete Challenges",
            description: "確定好答案後按拍攝"
        ),
        TeachingStep(
            imageName: "Tutorial6",
            title: "Complete Challenges",
            description: "恭喜答對！收集到了這個單字存入背包～"
        ),
        TeachingStep(
            imageName: "Tutorial7",
            title: "Complete Challenges",
            description: "右上角小卡A可以看這關已經有拍到的單字～且謎題的單字也會自動填入喔"
        ),
        TeachingStep(
            imageName: "Tutorial8",
            title: "Complete Challenges",
            description: "進入背包，哇好多可愛的單字企鵝卡"
        ),
        TeachingStep(
            imageName: "Tutorial9",
            title: "Complete Challenges",
            description: "開始學習你剛剛收集到的單字～按喇叭可以聽聲音喔～"
        ),
        TeachingStep(
            imageName: "Tutorial10",
            title: "Complete Challenges",
            description: "還有你的進度！滿滿的成就感！再接再厲！"
        ),
        TeachingStep(
            imageName: "Tutorial11",
            title: "Complete Challenges",
            description: "收集單字解鎖三款複習小遊戲等你玩！"
        )
    ]
    
    var body: some View {
        ZStack {
            // 全屏漸變背景
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            // 內容容器
            VStack(spacing: 0) {
                // 關閉按鈕
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.8))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(9)
                    .accessibilityLabel("Close tutorial")
                    
                    Spacer()
                }
                
                // 教學內容
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            Image(steps[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 480)
                                .cornerRadius(12)
//                                .padding(.horizontal)
                            
                            Text(steps[index].title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(steps[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                        }
                        .padding()
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                // 導航按鈕
                HStack(spacing: 20) {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation {
                                currentStep -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("上一頁")
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                            )
                            .foregroundColor(.white)
                        }
                    } else {
                        Spacer()
                            .frame(height: 36)
                    }
                    
                    Spacer()
                    
                    if currentStep < steps.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentStep += 1
                            }
                        }) {
                            HStack {
                                Text("下一頁")
                                Image(systemName: "chevron.right")
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                            )
                            .foregroundColor(.white)
                        }
                    } else {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("開始探索")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                )
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.black.opacity(0.3))
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.9)
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            isShowing = false
        }
    }
}

struct TeachingStep {
    let imageName: String
    let title: String
    let description: String
}

struct TutorialOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialOverlayView(isShowing: .constant(true))
    }
} 
