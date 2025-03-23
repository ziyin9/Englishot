//
//  ErrorView.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/16/25.
//


//
//  ErrorView.swift
//  Englishot
//
//  Created by 李庭宇 on 2025/3/16.
//

import SwiftUI

struct ErrorView: View {
    @Binding var showRecognitionErrorView: Bool
    @Binding var showingCamera: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("辨識錯誤")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Text("未能成功辨識物品，請再試一次")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                HStack {
                    Button(action: {
                        showRecognitionErrorView = false // 關閉視圖
                    }) {
                        Text("Close")
                            .frame(width: 100, height: 40)
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        showRecognitionErrorView = false
                        showingCamera = true // 再試一次，打開相機
                    }) {
                        Text("Try Again")
                            .frame(width: 100, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(20)
        }
    }
}