
import SwiftUI
import AVFoundation
import CoreLocation

struct SettingView: View {
    @EnvironmentObject var audioManager: AudioManager
    @StateObject private var privacyManager = PrivacyManager()
    
    @State private var volume: Double = 0.5
    @State private var soundEffectsEnabled = true
    @State private var notificationsEnabled = true
    @State private var isDarkMode = false
    @State private var isPrivacyExpanded = false
    @State private var selectedTab: Int = 0
    @State private var showTutorial = false
    
    // 添加更多視覺效果相關狀態
    @State private var animateBackground = true
    @State private var snowIntensity: Double = 0.6
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 優化背景漸層
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.15),
                        Color.white.opacity(0.4),
                        Color.blue.opacity(0.25)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // 改進雪花效果
                SSnowfallView(intensity: snowIntensity)
                    .opacity(animateBackground ? 0.6 : 0.2)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // 標題區域
                        HStack {
                            Text("Settings")
                                .font(.system(size: 38, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.8), .blue.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .blue.opacity(0.4), radius: 3, x: 0, y: 2)
                            
                            Spacer()
                            
                            // 幫助按鈕
                            Button(action: {
                                showTutorial = true
                            }) {
                                Image(systemName: "questionmark.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                                    .background(Circle().fill(Color.white.opacity(0.7)).shadow(radius: 3))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // 設定區塊
                        VStack(spacing: 22) {
                            // 音頻設定卡片
                            SSSettingsCard(icon: "speaker.wave.3.fill", title: "Audio Settings") {
                                VStack(spacing: 18) {
                                    // 背景音樂音量
                                    HStack {
                                        Image(systemName: "music.note")
                                            .foregroundColor(.blue.opacity(0.8))
                                        Text("Background Music")
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("\(Int(audioManager.volume * 100))%")
                                            .foregroundColor(.gray)
                                            .monospacedDigit()
                                    }
                                    
                                    Slider(value: $audioManager.volume, in: 0...1, step: 0.01)
                                        .tint(.blue)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                                .padding(-2)
                                        )
                                    
                                    // 音效開關
                                    Toggle(isOn: Binding(
                                        get: { soundEffectsEnabled },
                                        set: { newValue in
                                            soundEffectsEnabled = newValue
                                            if soundEffectsEnabled {
                                                audioManager.audioPlayer?.play()
                                            } else {
                                                audioManager.audioPlayer?.pause()
                                            }
                                        }
                                    )) {
                                        HStack {
                                            Image(systemName: "speaker.wave.2.fill")
                                                .foregroundColor(.blue.opacity(0.8))
                                            Text("Sound Effects")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .toggleStyle(EnhancedIceToggleStyle())
                                    
                                    // 新增動畫效果開關
                                    Toggle(isOn: $animateBackground) {
                                        HStack {
                                            Image(systemName: "sparkles")
                                                .foregroundColor(.blue.opacity(0.8))
                                            Text("Animation Effects")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .toggleStyle(EnhancedIceToggleStyle())
                                }
                            }
                            
                            // 通知與主題卡片
                            SSSettingsCard(icon: "bell.badge.fill", title: "Preferences") {
                                VStack(spacing: 18) {
                                    Toggle(isOn: $notificationsEnabled) {
                                        HStack {
                                            Image(systemName: "bell.fill")
                                                .foregroundColor(.blue.opacity(0.8))
                                            Text("Notifications")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .toggleStyle(EnhancedIceToggleStyle())
                                    
                                    Toggle(isOn: $isDarkMode) {
                                        HStack {
                                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                                .foregroundColor(.blue.opacity(0.8))
                                            Text("Dark Mode")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .toggleStyle(EnhancedIceToggleStyle())
                                    
                                    // 新增雪花強度調整
                                    if animateBackground {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Image(systemName: "snow")
                                                    .foregroundColor(.blue.opacity(0.8))
                                                Text("Snow Intensity")
                                                    .foregroundColor(.primary)
                                                Spacer()
                                                Text("\(Int(snowIntensity * 100))%")
                                                    .foregroundColor(.gray)
                                                    .monospacedDigit()
                                            }
                                            
                                            Slider(value: $snowIntensity, in: 0.1...1, step: 0.05)
                                                .tint(.blue)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                                        .padding(-2)
                                                )
                                        }
                                    }
                                }
                            }
                            
                            // 隱私設定卡片
                            SSSettingsCard(icon: "lock.shield.fill", title: "Privacy") {
                                VStack {
                                    DisclosureGroup(
                                        isExpanded: $isPrivacyExpanded,
                                        content: {
                                            VStack(spacing: 18) {
                                                EnhancedPrivacySettingRow(
                                                    icon: "camera.fill",
                                                    title: "Camera Access",
                                                    status: privacyManager.permissionStatusText(for: privacyManager.cameraPermissionStatus),
                                                    action: privacyManager.requestCameraPermission
                                                )
                                                
                                                Divider()
                                                    .background(Color.blue.opacity(0.2))
                                                
                                                EnhancedPrivacySettingRow(
                                                    icon: "mic.fill",
                                                    title: "Microphone Access",
                                                    status: privacyManager.permissionStatusText(for: privacyManager.microphonePermissionStatus),
                                                    action: privacyManager.requestMicrophonePermission
                                                )
                                                
                                                Divider()
                                                    .background(Color.blue.opacity(0.2))
                                                
                                                EnhancedPrivacySettingRow(
                                                    icon: "location.fill",
                                                    title: "Location Access",
                                                    status: privacyManager.permissionStatusText(for: privacyManager.locationPermissionStatus),
                                                    action: privacyManager.requestLocationPermission
                                                )
                                            }
                                            .padding(.top, 12)
                                        },
                                        label: {
                                            HStack {
                                                Image(systemName: "lock.fill")
                                                    .foregroundColor(.blue.opacity(0.8))
                                                Text("Permission Settings")
                                                    .foregroundColor(.primary)
                                                    .fontWeight(.medium)
                                            }
                                        }
                                    )
                                    .accentColor(.blue)
                                }
                            }
                            
                            // 新增關於應用卡片
                            SSSettingsCard(icon: "info.circle.fill", title: "About") {
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Version")
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("1.0.0")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Button(action: {
                                        // 打開應用評分
                                    }) {
                                        HStack {
                                            Text("Rate this App")
                                                .foregroundColor(.blue)
                                            Spacer()
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    
                                    Button(action: {
                                        // 打開分享
                                    }) {
                                        HStack {
                                            Text("Share with Friends")
                                                .foregroundColor(.blue)
                                            Spacer()
                                            Image(systemName: "square.and.arrow.up")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                    }
                }
            }
        }
        .onAppear {
            privacyManager.updatePermissionsStatus()
        }
        .overlay(
            showTutorial ? TutorialView(showTutorial: $showTutorial) : nil
        )
    }
}

// 升級的冰凍風格切換開關
struct EnhancedIceToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                Capsule()
                    .fill(configuration.isOn ?
                          LinearGradient(colors: [.blue.opacity(0.7), .blue.opacity(0.5)],
                                         startPoint: .leading,
                                         endPoint: .trailing) :
                            LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.2)],
                                         startPoint: .leading,
                                         endPoint: .trailing))
                    .frame(width: 52, height: 31)
                    .overlay(
                        Group {
                            if configuration.isOn {
                                HStack(spacing: 5) {
                                    ForEach(0..<3) { _ in
                                        Image(systemName: "snowflake")
                                            .font(.system(size: 8))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                .padding(.leading, 8)
                            }
                        }
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.blue.opacity(configuration.isOn ? 0.2 : 0.1), lineWidth: 1)
                    )
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 27, height: 27)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .offset(x: configuration.isOn ? 10.5 : -10.5)
                    .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

// 改進的設定卡片視圖
struct SSSettingsCard<Content: View>: View {
    let icon: String
    let title: String
    let content: Content
    
    init(icon: String, title: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 卡片標題
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        LinearGradient(
                            colors: [.blue.opacity(0.8), .blue.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            // 分隔線
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.3), .blue.opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            // 卡片內容
            content
                .padding(.vertical, 5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.75))
                .shadow(color: .blue.opacity(0.15), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .white.opacity(0.6), .blue.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
    }
}

// 改進的隱私設定行元件
struct EnhancedPrivacySettingRow: View {
    let icon: String
    let title: String
    let status: String
    let action: () -> Void
    
    var statusColor: Color {
        switch status.lowercased() {
        case "granted": return .green
        case "denied": return .red
        default: return .blue
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(.blue.opacity(0.8))
                .frame(width: 28, height: 28)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: action) {
                Text(status)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: statusColor.opacity(0.3), radius: 2, x: 0, y: 1)
            }
        }
    }
}

// 改進的雪花效果視圖
struct SSnowfallView: View {
    var intensity: Double
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(50 * intensity), id: \.self) { i in
                SnowflakeView(size: CGFloat.random(in: 8...20 * intensity))
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height)
                    )
            }
        }
    }
}

struct SnowflakeView: View {
    @State private var isAnimating = false
    let size: CGFloat
    
    var body: some View {
        Image(systemName: ["snowflake", "snowflake.circle", "snowflake.circle.fill"].randomElement()!)
            .foregroundColor(.white.opacity(CGFloat.random(in: 0.6...0.9)))
            .font(.system(size: size))
            .rotationEffect(.degrees(isAnimating ? Double.random(in: 0...360) : 0))
            .offset(y: isAnimating ? 1200 : -100)
            .animation(
                Animation.linear(duration: Double.random(in: 7...15))
                    .repeatForever(autoreverses: false)
                    .delay(Double.random(in: 0...2)),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}
struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                LinearGradient(
                                    colors: [.blue.opacity(0.3), .white.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .blue.opacity(0.1), radius: 5, x: 0, y: 2)
            )
    }
}

// Privacy Setting Row Component
struct PrivacySettingRow: View {
    let icon: String
    let title: String
    let status: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Button(action: action) {
                Text(status)
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
        }
    }
}

//#Preview{
//    SettingView()
//}
