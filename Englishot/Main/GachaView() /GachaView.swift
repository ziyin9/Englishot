//
//  GachaView.swift
//  Englishot
//
//  Created by 陳姿縈 on 6/11/25.
//


import SwiftUI

struct GachaView: View {
    @State private var showCard = false
    @State private var cardScale: CGFloat = 0.1
    @State private var cardOpacity = 0.0
    
    // 你可以在這裡放入多張抽卡圖片名稱
    let cardPool = ["happy_penguin", "angry_penguin", "sad_penguin", "excited_penguin"]
    
    @State private var currentCard: String = "happy_penguin"  // 預設第一張

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("抽卡")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
                if showCard {
                    Image(currentCard)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .scaleEffect(cardScale)
                        .opacity(cardOpacity)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.5)) {
                                cardScale = 1.2
                                cardOpacity = 1.0
                            }
                            withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                                cardScale = 1.0
                            }
                        }
                } else {
                    Text("點擊按鈕抽卡")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                
                Button(action: {
                    showCard = false
                    cardScale = 0.1
                    cardOpacity = 0.0
                    
                    // 模擬隨機抽卡
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        currentCard = cardPool.randomElement() ?? "happy_penguin"
                        showCard = true
                    }
                }) {
                    Text("抽卡！")
                        .padding()
                        .frame(width: 200)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                }
            }
        }
    }
}
