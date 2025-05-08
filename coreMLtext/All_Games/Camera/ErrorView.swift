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
    
    var errorMessage: String = "未能成功辨識物品，請再試一次"
    var recognizedWord: String? = nil
    var isWrongLevel: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image(systemName: isWrongLevel ? "exclamationmark.triangle.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(isWrongLevel ? .orange : .red)
                
                Text(isWrongLevel ? "辨識到錯誤關卡物品" : "辨識錯誤")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                if isWrongLevel, let word = recognizedWord?.components(separatedBy: " - ").first {
                    VStack(spacing: 5) {
                        Text("辨識到的單字：")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(word)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.orange.opacity(0.3))
                            .cornerRadius(8)
                        
                        Text("此單字不屬於當前關卡")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                }

                HStack {
                    Button(action: {
                        showRecognitionErrorView = false // 關閉視圖
                    }) {
                        Text("關閉")
                            .frame(width: 100, height: 40)
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        showingCamera = true // 再試一次，打開相機
                        showRecognitionErrorView = false
                    }) {
                        Text("再試一次")
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
