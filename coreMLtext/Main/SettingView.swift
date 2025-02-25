import SwiftUI
import AVFoundation
import CoreLocation

struct SettingView: View {
    @EnvironmentObject var audioManager: AudioManager
    @StateObject private var privacyManager = PrivacyManager()
    
    @State private var volume: Double = 0.5 // 背景音樂音量
    @State private var soundEffectsEnabled = true // 音效開關
    @State private var notificationsEnabled = true // 通知設定
    @State private var isDarkMode = false // 深色模式
    @State private var isPrivacyExpanded = false // 隱私展開收起
    @State private var selectedTab: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient with snow effect
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.white.opacity(0.3),
                        Color.blue.opacity(0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Snow particles effect
                SnowfallView()
                    .opacity(0.6)
                
                VStack(spacing: 25) {
                    // Title with ice effect and centered alignment
                    Text("Settings")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.7), .white],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(maxWidth: .infinity, alignment: .center) // Center the title
                        .padding(.top, 40)
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    // Settings sections using custom card style
                    VStack(spacing: 20) {
                        // Audio Settings Card
                        SettingsCard {
                            VStack(spacing: 15) {
                                // Volume Control
                                HStack {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundColor(.blue)
                                    Text("Background Music")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("\(Int(audioManager.volume * 100))%")
                                        .foregroundColor(.gray)
                                }
                                
                                Slider(value: $audioManager.volume, in: 0...1, step: 0.01)
                                    .tint(.blue)
                                
                                // Sound Effects Toggle
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
                                        Image(systemName: "music.note")
                                            .foregroundColor(.blue)
                                        Text("Sound Effects")
                                            .foregroundColor(.primary)
                                    }
                                }
                                .toggleStyle(IceToggleStyle())
                            }
                        }
                        
                        // Notification and Theme Card
                        SettingsCard {
                            VStack(spacing: 15) {
                                Toggle(isOn: $notificationsEnabled) {
                                    HStack {
                                        Image(systemName: "bell.fill")
                                            .foregroundColor(.blue)
                                        Text("Notifications")
                                            .foregroundColor(.primary)
                                    }
                                }
                                .toggleStyle(IceToggleStyle())
                                
                                Toggle(isOn: $isDarkMode) {
                                    HStack {
                                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                            .foregroundColor(.blue)
                                        Text("Dark Mode")
                                            .foregroundColor(.primary)
                                    }
                                }
                                .toggleStyle(IceToggleStyle())
                            }
                        }
                        
                        // Privacy Settings Card
                        SettingsCard {
                            VStack {
                                DisclosureGroup(
                                    isExpanded: $isPrivacyExpanded,
                                    content: {
                                        VStack(spacing: 15) {
                                            PrivacySettingRow(
                                                icon: "camera.fill",
                                                title: "Camera Access",
                                                status: privacyManager.permissionStatusText(for: privacyManager.cameraPermissionStatus),
                                                action: privacyManager.requestCameraPermission
                                            )
                                            
                                            PrivacySettingRow(
                                                icon: "mic.fill",
                                                title: "Microphone Access",
                                                status: privacyManager.permissionStatusText(for: privacyManager.microphonePermissionStatus),
                                                action: privacyManager.requestMicrophonePermission
                                            )
                                            
                                            PrivacySettingRow(
                                                icon: "location.fill",
                                                title: "Location Access",
                                                status: privacyManager.permissionStatusText(for: privacyManager.locationPermissionStatus),
                                                action: privacyManager.requestLocationPermission
                                            )
                                        }
                                        .padding(.top, 10)
                                    },
                                    label: {
                                        HStack {
                                            Image(systemName: "lock.fill")
                                                .foregroundColor(.blue)
                                            Text("Privacy Settings")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            privacyManager.updatePermissionsStatus()
        }
    }
}

// Custom Toggle Style with Ice Theme
struct IceToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? Color.blue.opacity(0.7) : Color.gray.opacity(0.3))
                    .frame(width: 50, height: 30)
                    .overlay(
                        Image("icecube")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .opacity(0.7)
                    )
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 26, height: 26)
                    .shadow(radius: 1)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

// Custom Card View for Settings
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

// Snowfall Effect View
struct SnowfallView: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<50) { i in
                SnowflakeView()
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
    
    var body: some View {
        Image(systemName: "snowflake")
            .foregroundColor(.white.opacity(0.7))
            .font(.system(size: CGFloat.random(in: 10...20)))
            .offset(y: isAnimating ? 1000 : -100)
            .animation(
                Animation.linear(duration: Double.random(in: 5...10))
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

