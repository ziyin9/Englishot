import SwiftUI

struct LeaveGameView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showLeaveGameView: Bool
    
    var message: String
    
    var button1Title: String
    var button1Action: () -> Void
    
    var button2Title: String
    var button2Action: () -> Void
    
    // Ice theme colors
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(#colorLiteral(red: 0.8, green: 0.9, blue: 0.98, alpha: 1)), // Light ice blue
            Color(#colorLiteral(red: 0.7, green: 0.85, blue: 0.95, alpha: 1))  // Slightly deeper ice blue
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let borderGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(#colorLiteral(red: 0.6, green: 0.8, blue: 0.95, alpha: 1)),
            Color(#colorLiteral(red: 0.4, green: 0.7, blue: 0.9, alpha: 1))
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let textColor = Color(#colorLiteral(red: 0.2, green: 0.4, blue: 0.7, alpha: 1)) // Deep ice blue
    let button1Color = Color(#colorLiteral(red: 0.85, green: 0.3, blue: 0.3, alpha: 1)) // Cool red
    let button2Color = Color(#colorLiteral(red: 0.3, green: 0.6, blue: 0.8, alpha: 1)) // Ice blue
    
    var body: some View {
        ZStack {
            // Frosted background
            Color.black.opacity(0.3)
                .blur(radius: 2)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Snowflake icon
                Image(systemName: "snowflake")
                    .font(.system(size: 40))
                    .foregroundColor(textColor)
                    .padding(.top, 20)
                
                Text(message)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                HStack(spacing: 20) {
                    // Leave button
                    Button(action: {
                        button1Action()
                    }) {
                        Text(button1Title)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .frame(minWidth: 120)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(button1Color)
                                    
                                    // Snow-like highlights
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                        .blur(radius: 0.5)
                                }
                            )
                            .foregroundColor(.white)
                            .shadow(color: button1Color.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    
                    // Continue button
                    Button(action: {
                        button2Action()
                    }) {
                        Text(button2Title)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .frame(minWidth: 120)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(button2Color)
                                    
                                    // Snow-like highlights
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                        .blur(radius: 0.5)
                                }
                            )
                            .foregroundColor(.white)
                            .shadow(color: button2Color.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: 350)
            .background(
                ZStack {
                    // Main background
                    RoundedRectangle(cornerRadius: 25)
                        .fill(backgroundGradient)
                    
                    // Frosted glass effect
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(borderGradient, lineWidth: 2)
                    
                    // Snowflake decorations
                    ForEach(0..<8) { i in
                        Image(systemName: "snowflake")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.7))
                            .position(
                                x: CGFloat.random(in: 30...320),
                                y: CGFloat.random(in: 30...170)
                            )
                    }
                }
            )
            .overlay(
                // Ice crystal border effect
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    .blur(radius: 0.5)
            )
            .shadow(color: Color(#colorLiteral(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.5)), radius: 15)
        }
    }
}

struct LeaveGameView_Previews: PreviewProvider {
    static var previews: some View {
        LeaveGameView(
            showLeaveGameView: .constant(true),
            message: "不會保留遊戲紀錄確定要離開嗎？",
            button1Title: "離開遊戲",
            button1Action: { print("離開遊戲") },
            button2Title: "繼續遊戲",
            button2Action: { print("繼續遊戲") }
        )
    }
}
