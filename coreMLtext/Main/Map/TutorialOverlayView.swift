import SwiftUI

struct TutorialOverlayView: View {
    @Binding var isShowing: Bool
    @State private var currentStep = 0
    
    let steps: [TeachingStep] = [
        TeachingStep(
            imageName: "Screenshot",
            title: "Welcome to Englishot",
            description: "This is a fun way to learn English through interactive maps and games."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Explore Locations",
            description: "Visit different locations on the map to discover new learning opportunities."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        ),
        TeachingStep(
            imageName: "Screenshot",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
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
                                .frame(height: 450)
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
