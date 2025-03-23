//
//  CircularProgressView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 2/4/25.
//
import SwiftUI

struct CircularProgressView: View {
    var totalWords: Int  // 總單字數目
    var currentWords: Int  // 目前收集的單字數
    var circlewidth: CGFloat
    var circleheight: CGFloat
    
    @State private var animatedProgress: Double = 0
    @State private var showCelebration: Bool = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var progress: Double {
        Double(currentWords) / Double(totalWords)
    }
    
    var body: some View {
        ZStack {
            // Background ice
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.3),
                            Color.white.opacity(0.6),
                            Color.blue.opacity(0.3)
                        ]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                )
                .frame(width: circlewidth, height: circleheight)
                .opacity(0.6)
            
            // Progress circle with ice crystal effect
            Circle()
                .trim(from: 0.0, to: CGFloat(animatedProgress))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.blue,
                            Color.white,
                            Color.blue.opacity(0.7)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .overlay(
                    // Ice crystals along the progress
                    Circle()
                        .trim(from: 0.0, to: CGFloat(animatedProgress))
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .rotationEffect(Angle(degrees: -90))
                        .blur(radius: 1)
                )
                .frame(width: circlewidth, height: circleheight)
                .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
            
            // Center content
            VStack(spacing: 5) {
                Text("\(currentWords)/\(totalWords)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                
                Text("Words")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            .scaleEffect(scale)
            
            // Celebration effects when complete
            if showCelebration {
                ZStack {
                    ForEach(0..<8) { index in
                        Image(systemName: "snowflake")
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(Double(index) * 45))
                            .offset(y: -80)
                            .scaleEffect(showCelebration ? 1 : 0)
                            .opacity(showCelebration ? 0 : 1)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.7)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.1),
                                value: showCelebration
                            )
                    }
                }
            }
        }
        .frame(width: 150, height: 150)
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
            
            // Check if progress is complete
            if progress >= 1.0 {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCelebration = true
                    rotationAngle = 360
                    scale = 1.1
                }
                
                // Reset scale after celebration
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        scale = 1.0
                    }
                }
            }
        }
        .onChange(of: progress) { newProgress in
            // Animate progress changes when switching categories
            withAnimation(.easeInOut(duration: 0.6)) {
                animatedProgress = newProgress
            }
            
            // Add rotation effect on category change
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                rotationAngle += 180
            }
            
            // Update celebration state
            showCelebration = (newProgress >= 1.0)
        }
    }
}

#Preview {
    CircularProgressView(totalWords: 20, currentWords: 10, circlewidth:100 ,circleheight:100)
}
