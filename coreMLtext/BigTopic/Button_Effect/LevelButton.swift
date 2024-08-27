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
    @State private var isHovered = false
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 15) {
                ZStack {
                    //  background
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
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white, .blue.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
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
                    
                    // Ice crystals effect
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
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
    }
}
