//
//  LevelButton.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 2/14/25.
//

import SwiftUI


// Level Button Component
struct LevelButton<Destination: View>: View {
    let index: Int
    let icon: String
    let name: String
    let destination: Destination
    let isSelected: Bool
    let progress: CGFloat
    
    @State private var isHovered = false
    @State private var isWaving = false
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 15) {
                ZStack {
                    // Background circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.9),
                                    .blue.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    // Water wave effect
                    WaterWave(progress: progress, isWaving: isWaving)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.3),
                                    Color.blue.opacity(0.5)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    // Ice crystal border
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white, .blue.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .shadow(color: .blue.opacity(0.2), radius: isHovered ? 10 : 5)
                    
                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Progress percentage
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.blue.opacity(0.6))
                        .clipShape(Capsule())
                        .offset(y: 30)
                    
                    // Ice crystals effect when hovered
                    if isHovered {
                        ForEach(0..<6) { i in
                            Image(systemName: "snowflake")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                                .offset(
                                    x: CGFloat(cos(Double(i) * .pi / 3)) * 40,
                                    y: CGFloat(sin(Double(i) * .pi / 3)) * 40
                                )
                                .rotationEffect(.degrees(Double(i) * 60))
                        }
                    }
                }
                
                Text(name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.blue.opacity(0.8))
            }
            .scaleEffect(isHovered ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                isWaving = true
            }
        }
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
    }
}

// Water wave shape for filling effect
struct WaterWave: Shape {
    var progress: CGFloat
    var isWaving: Bool
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let progressHeight = (1 - progress) * rect.height
        let waveHeight: CGFloat = 5
        
        path.move(to: CGPoint(x: 0, y: progressHeight))
        
        for x in stride(from: 0, through: rect.width, by: 2) {
            let relativeX = x / rect.width
            let sine = sin(relativeX * .pi * 4 + (isWaving ? Date().timeIntervalSince1970 : 0))
            let y = progressHeight + sine * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}
