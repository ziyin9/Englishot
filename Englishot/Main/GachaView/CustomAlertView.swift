import SwiftUI

// 弹窗类型枚举
enum AlertType {
    case insufficientCoins
    case confirmDraw
}

// 自定义美观弹窗
struct CustomAlertView: View {
    let type: AlertType
    let requiredCoins: Int64
    let gachaType: GachaType
    @Binding var isPresented: Bool
    let onConfirm: (() -> Void)?
    
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0.0
    @State private var backgroundOpacity: Double = 0.0
    @State private var snowflakeOffset: CGFloat = 0
    @State private var shimmerOffset: CGFloat = -300
    
    init(type: AlertType, requiredCoins: Int64 = 0, gachaType: GachaType = .normal, isPresented: Binding<Bool>, onConfirm: (() -> Void)? = nil) {
        self.type = type
        self.requiredCoins = requiredCoins
        self.gachaType = gachaType
        self._isPresented = isPresented
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        ZStack {
            // 冰雪背景
            icyBackground
                .ignoresSafeArea()
                .onTapGesture {
                    dismissAlert()
                }
            
            // 雪花粒子效果
            snowflakeParticles
            
            // 弹窗内容
            VStack(spacing: 0) {
                // 顶部装饰
                topDecoration
                
                // 主要内容
                VStack(spacing: 20) {
                    // 图标和标题
                    iconAndTitle
                    
                    // 消息内容
                    messageContent
                    
                    // 按钮区域
                    buttonArea
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .background(
                    ZStack {
                        // 冰晶背景
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.95, green: 0.97, blue: 1.0),
                                        Color(red: 0.90, green: 0.94, blue: 0.98),
                                        Color(red: 0.85, green: 0.92, blue: 0.97)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.8),
                                                Color(red: 0.8, green: 0.9, blue: 1.0).opacity(0.6)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: Color(red: 0.7, green: 0.8, blue: 1.0).opacity(0.3), radius: 25, x: 0, y: 15)
                        
                        // 閃光效果
                        shimmerEffect
                    }
                )
            }
            .frame(maxWidth: 340)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            showAlert()
        }
    }
    
    // 冰雪背景
    private var icyBackground: some View {
        RadialGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.4),
                Color(red: 0.05, green: 0.15, blue: 0.35),
                Color.black.opacity(0.8)
            ],
            center: .center,
            startRadius: 100,
            endRadius: 400
        )
        .opacity(backgroundOpacity)
    }
    
    // 雪花粒子效果
    private var snowflakeParticles: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                Text("❄️")
                    .font(.system(size: CGFloat.random(in: 12...20)))
                    .opacity(0.7)
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -300...300) + snowflakeOffset
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...2)),
                        value: snowflakeOffset
                    )
            }
        }
    }
    
    // 閃光效果
    private var shimmerEffect: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .rotationEffect(.degrees(30))
            .offset(x: shimmerOffset)
            .mask(RoundedRectangle(cornerRadius: 25))
    }
    
    // 顶部装饰
    private var topDecoration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: icyGradientColors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
            
            // 冰晶装饰
            HStack(spacing: 15) {
                ForEach(0..<3, id: \.self) { _ in
                    Text("❄️")
                        .font(.system(size: 12))
                        .opacity(0.8)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // 图标和标题
    private var iconAndTitle: some View {
        VStack(spacing: 15) {
            // 图标背景
            ZStack {
                // 外圈冰晶效果
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color(red: 0.7, green: 0.85, blue: 1.0).opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                
                // 內圈冰晶
                Circle()
                    .fill(
                        LinearGradient(
                            colors: icyGradientColors.map { $0.opacity(0.3) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 85, height: 85)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.7), Color(red: 0.8, green: 0.9, blue: 1.0).opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                
                // 图标
                ZStack {
                    if type == .insufficientCoins {
                        // 金幣不足使用系統圖標
                        Image(systemName: iconName)
                            .font(.system(size: 36, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: icyGradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.white.opacity(0.5), radius: 2)
                    } else {
                        // 確認抽卡使用自定義圖片
                        Image(iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.white.opacity(0.5), radius: 3)
                    }
                    
                    // 閃亮效果
                    Image(systemName: "sparkles")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white.opacity(0.8))
                        .offset(x: 25, y: -25)
                }
            }
            
            // 标题
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.2, green: 0.4, blue: 0.7),
                            Color(red: 0.3, green: 0.5, blue: 0.8)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.white.opacity(0.5), radius: 1)
                .multilineTextAlignment(.center)
        }
    }
    
    // 消息内容
    private var messageContent: some View {
        Text(message)
            .font(.system(size: 17, weight: .medium, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.3, green: 0.4, blue: 0.6),
                        Color(red: 0.4, green: 0.5, blue: 0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .shadow(color: Color.white.opacity(0.3), radius: 1)
    }
    
    // 按钮区域
    private var buttonArea: some View {
        VStack(spacing: 12) {
            if type == .confirmDraw {
                // 确认抽卡按钮
                Button(action: {
                    onConfirm?()
                    dismissAlert()
                    SoundPlayer.shared.playSound(named: "pop")

                }) {
                    HStack(spacing: 8) {
                        Image("fishcoin")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .shadow(color: Color.yellow.opacity(0.5), radius: 2)
                        
                        Text("確認抽卡")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        ZStack {
                            // 主背景
                            LinearGradient(
                                colors: [
                                    Color(red: 0.3, green: 0.6, blue: 1.0),
                                    Color(red: 0.2, green: 0.5, blue: 0.9),
                                    Color(red: 0.1, green: 0.4, blue: 0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            
                            // 冰晶光澤
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.clear,
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(IcyButtonStyle())
            }
            
            // 取消/确定按钮
            Button(action: {
                dismissAlert()
            }) {
                Text(type == .confirmDraw ? "取消" : "我知道了")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.5, blue: 0.7),
                                Color(red: 0.3, green: 0.4, blue: 0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.96, green: 0.97, blue: 0.99),
                                            Color(red: 0.92, green: 0.94, blue: 0.97)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.8, green: 0.85, blue: 0.95).opacity(0.5),
                                                    Color(red: 0.7, green: 0.75, blue: 0.85).opacity(0.3)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                        }
                    )
                    .shadow(color: Color(red: 0.6, green: 0.7, blue: 0.8).opacity(0.2), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(IcyButtonStyle())
        }
    }
    
    // 计算属性
    private var icyGradientColors: [Color] {
        switch type {
        case .insufficientCoins:
            return [
                Color(red: 1.0, green: 0.6, blue: 0.2),
                Color(red: 0.9, green: 0.4, blue: 0.3),
                Color(red: 0.8, green: 0.3, blue: 0.4)
            ]
        case .confirmDraw:
            switch gachaType {
            case .normal:
                return [
                    Color(red: 0.4, green: 0.7, blue: 1.0),
                    Color(red: 0.3, green: 0.6, blue: 0.9),
                    Color(red: 0.2, green: 0.5, blue: 0.8)
                ]
            case .emotion:
                return [
                    Color(red: 1.0, green: 0.4, blue: 0.7),
                    Color(red: 0.9, green: 0.3, blue: 0.6),
                    Color(red: 0.8, green: 0.5, blue: 0.8)
                ]
            case .profession:
                return [
                    Color(red: 0.4, green: 0.8, blue: 0.5),
                    Color(red: 0.3, green: 0.7, blue: 0.4),
                    Color(red: 0.5, green: 0.9, blue: 0.6)
                ]
            case .activity:
                return [
                    Color(red: 1.0, green: 0.7, blue: 0.3),
                    Color(red: 0.9, green: 0.6, blue: 0.2),
                    Color(red: 1.0, green: 0.8, blue: 0.4)
                ]
            case .festival:
                return [
                    Color(red: 0.9, green: 0.3, blue: 0.4),
                    Color(red: 0.8, green: 0.2, blue: 0.3),
                    Color(red: 1.0, green: 0.5, blue: 0.3)
                ]
            }
        }
    }
    
    private var iconName: String {
        switch type {
        case .insufficientCoins:
            return "exclamationmark.triangle.fill"
        case .confirmDraw:
            switch gachaType {
            case .normal:
                return "Normal"
            case .emotion:
                return "Emotion"
            case .profession:
                return "Profession"
            case .activity:
                return "Activity"
            case .festival:
                return "Festival"
            }
        }
    }
    
    private var title: String {
        switch type {
        case .insufficientCoins:
            return "金幣不足"
        case .confirmDraw:
            return "確認抽卡"
        }
    }
    
    private var message: String {
        switch type {
        case .insufficientCoins:
            return "您需要 \(requiredCoins) 枚金幣才能抽卡\n快去賺取更多金幣吧！"
        case .confirmDraw:
            return "花費 \(requiredCoins) 枚金幣\n抽取\(gachaType.title)卡片？"
        }
    }
    
    // 动画方法
    private func showAlert() {
        withAnimation(.easeOut(duration: 0.4)) {
            backgroundOpacity = 0.5
        }
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // 雪花動畫
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            snowflakeOffset = 600
        }
        
        // 閃光動畫
        withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
            shimmerOffset = 300
        }
    }
    
    private func dismissAlert() {
        withAnimation(.easeIn(duration: 0.2)) {
            scale = 0.7
            opacity = 0.0
            backgroundOpacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
        }
    }
}

// 冰晶按钮效果
struct IcyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .brightness(configuration.isPressed ? -0.1 : 0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CustomAlertView(
            type: .confirmDraw,
            requiredCoins: 100,
            gachaType: .normal,
            isPresented: .constant(true)
        )
    }
} 
