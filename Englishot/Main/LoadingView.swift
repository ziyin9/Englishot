import SwiftUI

struct LoadingView: View {
    @StateObject private var loadingManager = LoadingManager()
    @State private var currentFrame = 1
    @State private var showText = false
    @State private var titleOffset: CGFloat = -100
    @State private var penguinScale: CGFloat = 0.5
    @State private var sparkleOpacity: Double = 0
    
    let onLoadingComplete: () -> Void
    
    var body: some View {
        ZStack {
            // 雪地背景
            Image("snow_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // 漸變遮罩
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.1),
                    Color.white.opacity(0.3),
                    Color.cyan.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App 標題
                VStack(spacing: 10) {
                    Text("🐧 Englishot")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan, .white],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                        .offset(y: titleOffset)
                        .animation(.spring(response: 1.2, dampingFraction: 0.7), value: titleOffset)
                    
                    Text("一起學習英語吧！")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(showText ? 1 : 0)
                        .animation(.easeInOut(duration: 1.5).delay(0.8), value: showText)
                }
                
                Spacer()
                
                // 企鹅动画
                ZStack {
                    // 閃爍效果
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white.opacity(sparkleOpacity), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: sparkleOpacity)
                    
                    // 企鵝動畫
                    Image("penguin_frame_\(String(format: "%02d", currentFrame))")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .scaleEffect(penguinScale)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: penguinScale)
                        .onAppear {
                            startPenguinAnimation()
                        }
                }
                
                Spacer()
                
                // 進度條區域
                VStack(spacing: 15) {
                    Text(loadingManager.currentTask.isEmpty ? "初始化中..." : loadingManager.currentTask)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(showText ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5), value: loadingManager.currentTask)
                    
                    // 進度條
                    ZStack(alignment: .leading) {
                        // 背景
                        Capsule()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 250, height: 8)
                        
                        // 進度填充
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.cyan, .blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 250 * loadingManager.progress, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: loadingManager.progress)
                    }
                    
                    // 進度百分比
                    Text("\(Int(loadingManager.progress * 100))%")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(showText ? 1 : 0)
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            startLoadingSequence()
        }
        .onReceive(loadingManager.$isCompleted) { isCompleted in
            if isCompleted {
                // 載入完成，添加成功动画效果
                withAnimation(.easeInOut(duration: 0.8)) {
                    // 可以在这里添加完成时的动画效果
                    sparkleOpacity = 1.0
                    penguinScale = 1.1
                }
                
                // 延迟后触发转场
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    onLoadingComplete()
                }
            }
        }
    }
    
    private func startPenguinAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.loadingManager.isCompleted {
                timer.invalidate()
                return
            }
            
            self.currentFrame += 1
            if self.currentFrame > 16 {
                self.currentFrame = 1
            }
        }
    }
    
    private func startLoadingSequence() {
        // 標題動畫
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            titleOffset = 0
        }
        
        // 企鵝縮放動畫
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            penguinScale = 1.0
        }
        
        // 文字顯示
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showText = true
        }
        
        // 閃爍效果
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            sparkleOpacity = 0.3
        }
        
        // 開始實際載入任務
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            loadingManager.startLoading()
        }
    }
}

// MARK: - Preview
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView {
            print("Loading completed!")
        }
    }
} 