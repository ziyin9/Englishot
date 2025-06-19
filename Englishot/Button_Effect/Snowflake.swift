//
//  HomeSnowflake.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 2/14/25.
//


import SwiftUI

// 雪花模型
struct Snowflake: Identifiable {
    let id = UUID()
    let x: CGFloat
    let size: CGFloat
    let speed: Double
    let delay: Double
    
    init() {
        x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        size = CGFloat.random(in: 5...10)
        speed = Double.random(in: 10...15)
        delay = Double.random(in: 0...4)
    }
}

// 雪花動畫 View
struct Snowflake_View: View {
    let snowflake: Snowflake
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
