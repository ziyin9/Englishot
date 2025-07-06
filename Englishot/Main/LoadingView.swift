import SwiftUI
import AVFoundation
import Foundation

struct LoadingView: View {
    @StateObject private var loadingManager = LoadingManager()
    @State private var currentFrame = 1
    @State private var showText = false
    @State private var canSkip = false
    @State private var showTapHint = false
    @State private var snowflakes: [Snowflake] = (0..<30).map { _ in Snowflake() }
    @State private var penguinAnimationTimer: Timer?
    
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
            
            // 飄雪動畫
            ForEach(snowflakes) { snowflake in
                Snowflake_View(snowflake: snowflake)
            }
            
            VStack(spacing: 40) {
                // App 標題 (簡化)
                VStack(spacing: 10) {
                    Text(" Englishot 📷")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan, .white],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                    
                    Text("收集單字 成就自己的背包庫吧！")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(showText ? 1 : 0)
                }
                
                Spacer()
                
                // 企鵝動畫
                Image("penguin_frame_\(String(format: "%02d", currentFrame))")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .onAppear {
                        startPenguinAnimation()
                    }
                
                Spacer()
                
                // 簡化的載入狀態
                VStack(spacing: 15) {
                    if !loadingManager.isCompleted {
                        Text(loadingManager.currentTask.isEmpty ? "初始化中..." : loadingManager.currentTask)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        // 簡化的進度條
                        ProgressView(value: loadingManager.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .frame(width: 200)
                            .scaleEffect(y: 2)
                    } else {
                        VStack(spacing: 10) {
                            
                            
                            if showTapHint {
                                Text("點擊螢幕繼續")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                    .opacity(showTapHint ? 1 : 0)
                                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showTapHint)
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
            }
            .padding()
        }
        .onTapGesture {
            if canSkip {
                // 播放點擊音效
                SoundPlayer.shared.playSound(named: "pop")
                
                // 觸覺回饋
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                // 停止企鵝動畫
                penguinAnimationTimer?.invalidate()
                penguinAnimationTimer = nil
                
                onLoadingComplete()
            }
        }
        .onAppear {
            startSimpleLoadingSequence()
        }
        .onDisappear {
            penguinAnimationTimer?.invalidate()
            penguinAnimationTimer = nil
        }
        .onReceive(loadingManager.$isCompleted) { isCompleted in
            if isCompleted {
                canSkip = true
                showTapHint = true
            }
        }
    }
    
    private func startPenguinAnimation() {
        penguinAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            self.currentFrame += 1
            if self.currentFrame > 16 {
                self.currentFrame = 1
            }
        }
    }
    
    private func startSimpleLoadingSequence() {
        // 簡單的文字顯示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showText = true
        }
        
        // 立即開始載入任務 (不延遲)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
