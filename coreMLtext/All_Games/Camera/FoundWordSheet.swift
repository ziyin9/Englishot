import SwiftUI

struct FoundWordPopup: View {
    let image: UIImage?
    var foundWord: String?
    @Binding var showimagePop: Bool
    

    @State private var isAnimating = false
    @State private var snowflakes: [FoundWordSnowflake] = (0..<30).map { _ in FoundWordSnowflake() }
    @State private var scale: CGFloat = 0.5
    @State private var rotation: Double = -10
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {

            Color.black.opacity(0.4)
                .blur(radius: 3)
                .ignoresSafeArea()
            
            // Snow effect
            ForEach(snowflakes) { snowflake in
                FoundWordSnowflakeView(snowflake: snowflake)
            }
            
            // Main popup content
            VStack(spacing: 20) {

                if let image = image {
                    ZStack {

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.9),
                                        .blue.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 220, height: 220)
                            .shadow(color: .blue.opacity(0.3), radius: 10)
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [.white, .blue.opacity(0.5)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                    }
                    .rotation3DEffect(.degrees(isAnimating ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                }
                
                // Celebration text with ice effect
                Text("You found the word!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue.opacity(0.8), .white],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 2)
                    .opacity(opacity)
                

                Text(foundWord ?? "")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .blue.opacity(0.3), radius: 5)
                    )
                    .rotationEffect(.degrees(rotation))
                
                // Close button ice crystal effect
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        scale = 0.5
                        opacity = 0
                        rotation = 10
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showimagePop = false
                    }
                }) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .blue.opacity(0.3), radius: 5)
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                }
                .scaleEffect(isAnimating ? 1 : 0.8)
            }
            .frame(width: 300, height: 450)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.5), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .blue.opacity(0.2), radius: 20)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    scale = 1
                    opacity = 1
                    rotation = 0
                    isAnimating = true
                }
            }
        }
    }
}

// Snowflake model for the popup
struct FoundWordSnowflake: Identifiable {
    let id = UUID()
    let x: CGFloat
    let size: CGFloat
    let speed: Double
    let delay: Double
    
    init() {
        x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        size = CGFloat.random(in: 5...15)
        speed = Double.random(in: 4...8)
        delay = Double.random(in: 0...2)
    }
}

// Snowflake view for the popup
struct FoundWordSnowflakeView: View {
    let snowflake: FoundWordSnowflake
    @State private var isAnimating = false
    
    var body: some View {
        Image(systemName: "snowflake")
            .font(.system(size: snowflake.size))
            .foregroundColor(.white.opacity(0.7))
            .position(x: snowflake.x, y: isAnimating ? UIScreen.main.bounds.height + 50 : -50)
            .animation(
                Animation.linear(duration: snowflake.speed)
                    .repeatForever(autoreverses: false)
                    .delay(snowflake.delay),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}
