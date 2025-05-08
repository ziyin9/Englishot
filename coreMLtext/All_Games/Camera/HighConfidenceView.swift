//
//  HighConfidenceView.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/16/25.
//

import SwiftUI

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
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Success header
                Text("辨識成功!")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                // Confidence information
                HStack {
                    Text("辨識度：\(String(format: "%.1f", confidenceLevel * 100))%")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                
                // Image preview
                if let capturedImage = image {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green, lineWidth: 3)
                        )
                        .shadow(color: .green.opacity(0.5), radius: 5)
                        .scaleEffect(isAnimating ? 1.0 : 0.9)
                }
                
                // Word recognized
                VStack {
                    Text("辨識單字")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(recognizedWord.components(separatedBy: " - ").first ?? recognizedWord)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 5)
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(12)
                
                // 顯示儲存成功訊息
                if isSaved {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("單字已儲存至背包庫")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(10)
                }
                
                // Buttons - 移除儲存按鈕，只保留關閉和再試一次
                HStack(spacing: 20) {
                    Button(action: {
                        showHighConfidenceView = false
                    }) {
                        Text("關閉")
                            .frame(width: 300, height: 40)
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
//                    Button(action: {
//                        showingCamera = true
//                        showHighConfidenceView = false
//                    }) {
//                        Text("再試一次")
//                            .frame(width: 120, height: 40)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
                }
            }
            .padding(25)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
            .shadow(radius: 15)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    scale = 1.0
                    isAnimating = true
                }
                
                // 自動儲存，不需要用戶點擊儲存按鈕
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onSave()
                    // 顯示儲存成功訊息
                    withAnimation {
                        isSaved = true
                    }
                }
            }
        }
    }
} 
