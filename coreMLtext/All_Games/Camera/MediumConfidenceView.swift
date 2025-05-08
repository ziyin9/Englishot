//
//  MediumConfidenceView.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/16/25.
//

import SwiftUI

struct MediumConfidenceView: View {
    let image: UIImage?
    let recognizedWord: String
    let confidenceLevel: Double
    @Binding var showMediumConfidenceView: Bool
    @Binding var showingCamera: Bool
    var onSaveAnyway: () -> Void
    
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Warning header
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    
                    Text("辨識度不佳")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                
                // Confidence information
                Text("辨識度：\(String(format: "%.1f", confidenceLevel * 100))%")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                
                // Image preview
                if let capturedImage = image {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.yellow, lineWidth: 3)
                        )
                        .shadow(color: .yellow.opacity(0.5), radius: 5)
                }
                
                // Suggestion text
                VStack(spacing: 10) {
                    Text("可能的問題:")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("• 拍攝角度不佳\n• 畫面中有多個物件\n• 光線不足")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                    
                    Text("建議: 嘗試只拍攝單一物件，調整角度或改善光線")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)
                }
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(12)
                
                // Buttons - 移除儲存按鈕，只保留關閉和再試一次
                HStack(spacing: 20) {
                    Button(action: {
                        showMediumConfidenceView = false
                    }) {
                        Text("關閉")
                            .frame(width: 120, height: 40)
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showingCamera = true
                        showMediumConfidenceView = false
                    }) {
                        Text("再試一次")
                            .frame(width: 120, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
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
                }
            }
        }
    }
} 
