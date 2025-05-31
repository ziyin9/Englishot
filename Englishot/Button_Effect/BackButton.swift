//
//  BackButton.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 2/14/25.
//


import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    @State private var isBackButtonHovered = false
    @State private var isArrowGlowing = false
    @State private var arrowPhase: Double = 0
    
    var body: some View {
        Button(action: {
                action()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.9),
                                Color(red: 0.8, green: 0.9, blue: 1.0).opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.white, .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(
                        color: .blue.opacity(0.3),
                        radius: isBackButtonHovered ? 8 : 4
                    )
                
                ZStack {
                    ForEach(0..<3) { i in
                        Image(systemName: "hexagon.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .blue.opacity(0.8),
                                        .white.opacity(0.4)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .rotationEffect(.degrees(Double(i) * 60))
                            .blur(radius: 5)
                            .opacity(isArrowGlowing ? 0.6 : 0.3)
                    }
                    
                    ForEach(0..<6) { i in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .blue.opacity(0.9),
                                        .white.opacity(0.8)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 12, height: 3)
                            .rotationEffect(.degrees(Double(i) * 60))
                            .blur(radius: 0.5)
                            .opacity(isArrowGlowing ? 0.9 : 0.6)
                    }
                    
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .blue.opacity(0.9),
                                    Color(red: 0.3, green: 0.6, blue: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .white, radius: isArrowGlowing ? 4 : 2)
                        .overlay(
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            .white,
                                            .white.opacity(0.8)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .blur(radius: 2)
                                .offset(x: -1, y: -1)
                        )
                    
                    ForEach(0..<4) { i in
                        Image(systemName: "sparkle")
                            .font(.system(size: 6))
                            .foregroundStyle(.white)
                            .offset(
                                x: sin(arrowPhase + Double(i) * .pi / 2) * 12,
                                y: cos(arrowPhase + Double(i) * .pi / 2) * 12
                            )
                            .opacity(isArrowGlowing ? 0.8 : 0.4)
                    }
                }
                .offset(x: isBackButtonHovered ? -2 : 0)
                .rotationEffect(.degrees(isBackButtonHovered ? -5 : 0))
            }
            .scaleEffect(isBackButtonHovered ? 1.1 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
    }
}

// 使用方式
struct ContentView: View {
    var body: some View {
        BackButton {
            print("Back button tapped!")
        }
    }
}
