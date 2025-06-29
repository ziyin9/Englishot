import SwiftUI
import AVKit
import AVFoundation

// 自定义视频播放器视图，去掉所有控件
struct CustomVideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false  // 隐藏播放控件
        controller.videoGravity = .resizeAspectFill  // 填满整个视图
        controller.allowsPictureInPicturePlayback = false  // 禁用画中画
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // 不需要更新
    }
}

struct RarityAnimationView: View {
    let rarity: String
    @Binding var isPresented: Bool
    @State private var player: AVPlayer?
    @State private var playerItem: AVPlayerItem?
    @State private var animationCompleted = false
    
    private var videoFileName: String {
        switch rarity {
        case "Snowflake":
            return "1"
        case "Ice Crystal":
            return "2"
        case "Frozen Star":
            return "3"
        case "Aurora":
            return "4"
        default:
            return "1"
        }
    }
    
    var body: some View {
        ZStack {
            // 全黑背景
            Color.black
                .ignoresSafeArea(.all)
            
            if let player = player {
                CustomVideoPlayerView(player: player)
//                    .aspectRatio(contentMode: .fill)  // 改为 .fill 以填满整个屏幕
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .clipped()  // 裁剪超出屏幕的部分
                    .ignoresSafeArea(.all)  // 忽略所有安全区域，真正全屏
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        cleanupPlayer()
                    }
            } else {
                // 备用动画效果（如果视频文件不存在）
                FallbackAnimationView(rarity: rarity, isPresented: $isPresented)
                    .ignoresSafeArea(.all)
            }
            
            // 添加跳过提示文字
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("跳過")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(15)
                        .padding(.trailing, 20)
                        .padding(.bottom, 50)
                }
            }
        }
        .preferredColorScheme(.dark)  // 强制使用深色模式
        .statusBarHidden()  // 隐藏状态栏
        .onTapGesture {
            // 点击屏幕跳过动画
            skipAnimation()
        }
        .onAppear {
            // 重置所有状态，确保每次都是全新的播放体验
            animationCompleted = false
            setupPlayer()
        }
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
            // 视频播放完成后清理播放器并自动关闭
            cleanupPlayer()
            withAnimation(.easeOut(duration: 0.3)) {
                isPresented = false
            }
        }
    }
    
    private func skipAnimation() {
        // 完全清理播放器状态，确保下次能重新开始
        cleanupPlayer()
        
        // 关闭动画界面
        withAnimation(.easeOut(duration: 0.2)) {
            isPresented = false
        }
    }
    
    private func setupPlayer() {
        // 清理之前的播放器状态
        cleanupPlayer()
        
        guard let videoURL = Bundle.main.url(forResource: videoFileName, withExtension: "mp4") else {
            print("找不到视频文件: \(videoFileName).mp4")
            // 如果找不到视频文件，直接使用备用动画，不需要延迟
            return
        }
        
        // 创建全新的播放器实例，确保每次都是独立的播放
        playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        
        // 确保从头开始播放
        player?.seek(to: .zero)
        
        // 设置音量（可选）
        player?.volume = 0.7
        
        // 设置播放器属性，确保完整播放体验
        player?.actionAtItemEnd = .none
    }
    
    private func cleanupPlayer() {
        // 停止当前播放并清理资源
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        playerItem = nil
    }
}

// 备用动画效果
struct FallbackAnimationView: View {
    let rarity: String
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 0.1
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0.0
    
    private var rarityColor: Color {
        switch rarity {
        case "Snowflake": return Color(red: 0.68, green: 0.91, blue: 0.95)
        case "Ice Crystal": return Color(red: 0.45, green: 0.82, blue: 0.96)
        case "Frozen Star": return Color(red: 0.35, green: 0.62, blue: 0.97)
        case "Aurora": return Color(red: 0.56, green: 0.78, blue: 1.0)
        default: return Color(red: 0.68, green: 0.91, blue: 0.95)
        }
    }
    
    private var rarityIcon: String {
        switch rarity {
        case "Snowflake": return "❄️"
        case "Ice Crystal": return "💎"
        case "Frozen Star": return "✨"
        case "Aurora": return "🌌"
        default: return "❄️"
        }
    }
    
    var body: some View {
        ZStack {
            // 全屏黑色背景
            Color.black
                .ignoresSafeArea(.all)
            
            // 背景光晕效果
            Circle()
                .fill(
                    RadialGradient(
                        colors: [rarityColor.opacity(0.6), rarityColor.opacity(0.2), Color.clear],
                        center: .center,
                        startRadius: 100,
                        endRadius: 400
                    )
                )
                .frame(width: 800, height: 800)
                .scaleEffect(scale)
                .opacity(opacity)
            
            // 中心图标
            Text(rarityIcon)
                .font(.system(size: 150))
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)
                .shadow(color: rarityColor, radius: 30)
            
            // 粒子效果
            ForEach(0..<30, id: \.self) { index in
                Circle()
                    .fill(rarityColor)
                    .frame(width: CGFloat.random(in: 4...12), height: CGFloat.random(in: 4...12))
                    .offset(
                        x: CGFloat.random(in: -300...300),
                        y: CGFloat.random(in: -300...300)
                    )
                    .scaleEffect(scale)
                    .opacity(opacity * 0.7)
            }
            
            // 添加跳过提示文字
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("轻触跳过")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(15)
                        .padding(.trailing, 20)
                        .padding(.bottom, 50)
                        .opacity(opacity)
                }
            }
        }
        .preferredColorScheme(.dark)
        .statusBarHidden()
        .onTapGesture {
            // 点击屏幕跳过动画
            withAnimation(.easeOut(duration: 0.2)) {
                isPresented = false
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            
            // 备用动画在3秒后自动关闭
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                withAnimation(.easeOut(duration: 0.3)) {
//                    isPresented = false
//                }
//            }
        }
    }
}

#Preview {
    RarityAnimationView(rarity: "Aurora", isPresented: .constant(true))
} 
