import SwiftUI
import UIKit

struct HighConfidenceView: View {
    let image: UIImage?
    let recognizedWord: String
    let confidenceLevel: Double
    @Binding var showHighConfidenceView: Bool
    @Binding var showingCamera: Bool
    var onSave: () -> Void
    
    // Animation states
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var isSaved = false
    @State private var rotationAngle: Double = 0
    @State private var snowflakesOpacity: Double = 0
    @State private var contentOpacity: Double = 0
    
    // Haptic feedback
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    // Snowflake positions - randomized for visual effect
    let snowflakePositions = (0..<12).map { _ in
        (x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -200...200), size: CGFloat.random(in: 10...25))
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent background to handle taps
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    dismissView()
                }
            
            // Background blur effect
            Color(red: 0.85, green: 0.9, blue: 0.98)
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 2)
            
            // Snowflakes in background
            ForEach(0..<snowflakePositions.count, id: \.self) { index in
                Image(systemName: "snowflake")
                    .font(.system(size: snowflakePositions[index].size))
                    .foregroundColor(.white)
                    .position(
                        x: UIScreen.main.bounds.width/2 + snowflakePositions[index].x,
                        y: UIScreen.main.bounds.height/2 + snowflakePositions[index].y
                    )
                    .opacity(snowflakesOpacity)
                    .rotationEffect(.degrees(rotationAngle + Double(index) * 10))
                    .animation(
                        Animation.linear(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: rotationAngle
                    )
            }
                
                // Additional snowflake accents - reduced number
                ForEach(0..<3, id: \.self) { index in
                    Image(systemName: "snowflake")
                        .font(.system(size: CGFloat.random(in: 15...20)))
                        .foregroundColor(.white.opacity(0.7))
                        .position(
                            x: CGFloat.random(in: 20...140),
                            y: CGFloat.random(in: 20...140)
                        )
                        .rotationEffect(.degrees(rotationAngle + Double(index) * 30))
                
            }
            
            VStack(spacing: 15) {
                // Success header
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                        
                    Text("辨識成功!")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(red: 0.0, green: 0.5, blue: 0.0))
                }
                .padding(.top, 5)
                
                // Confidence information
                HStack {
                    Text("辨識度：\(String(format: "%.1f", confidenceLevel * 100))%")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.7))
                                .shadow(color: Color.green.opacity(0.5), radius: 3)
                        )
                }
                
                // Image preview with frost overlay effect
                if let capturedImage = image {
                    ZStack {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 160)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green, lineWidth: 3)
                            )
                            .shadow(color: Color.green.opacity(0.5), radius: 8)
                            .scaleEffect(isAnimating ? 1.0 : 0.9)
                        
                        // Frost overlay
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                            .blur(radius: 2)
                            .frame(height: 160)
                        
                        
                    }
                }
                
                // Word recognized with frosted look
                VStack(spacing: 6) {
                    Text("辨識單字")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.0))
                    
                    Text(recognizedWord.components(separatedBy: " - ").first ?? recognizedWord)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(red: 0.0, green: 0.5, blue: 0.0))
                        .padding(.top, 2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.1))
                        .shadow(color: Color.green.opacity(0.3), radius: 5)
                )
                
                // 顯示儲存成功訊息
                if isSaved {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("單字已儲存至背包庫")
                            .font(.footnote)
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.0))
                            .padding(.vertical, 3)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.15))
                            .shadow(color: Color.green.opacity(0.2), radius: 3)
                    )
                }
                
                // Buttons
                Button(action: {
                    dismissView()
                }) {
                    Text("關閉")
                        .frame(width: 180, height: 40)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.7, green: 0.8, blue: 0.7))
                                .shadow(color: Color(red: 0.6, green: 0.7, blue: 0.6), radius: 3)
                        )
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.0))
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.top, 5)
                .padding(.bottom, 5)
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.4))
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.85, green: 0.9, blue: 0.98).opacity(0.6))
                            .blur(radius: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.8), lineWidth: 2)
                    )
                    .shadow(color: Color(red: 0.7, green: 0.85, blue: 1.0).opacity(0.7), radius: 15)
            )
            .scaleEffect(scale)
            .opacity(contentOpacity)
            .frame(maxWidth: 320)
            .onAppear {
                // Prepare haptic feedback
                feedbackGenerator.prepare()
                
                // Trigger success haptic feedback
                feedbackGenerator.notificationOccurred(.success)
                
                // Staggered animations for a frosty appearance
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    scale = 1.0
                    isAnimating = true
                }
                
                withAnimation(.easeIn(duration: 0.4).delay(0.2)) {
                    contentOpacity = 1.0
                }
                
                withAnimation(.easeIn(duration: 0.8).delay(0.4)) {
                    snowflakesOpacity = 0.8
                }
                
                // Start rotating snowflakes
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
                
                // 自動儲存，不需要用戶點擊儲存按鈕
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onSave()
                    // 顯示儲存成功訊息
                    withAnimation {
                        isSaved = true
                        // Add haptic feedback when word is saved
                        feedbackGenerator.notificationOccurred(.success)
                    }
                }
            }
        }
        .allowsHitTesting(true)
    }
    
    // Unified dismiss function for better consistency
    private func dismissView() {
        feedbackGenerator.notificationOccurred(.success)
        // Immediately dismiss without animation
        showHighConfidenceView = false
    }
}



