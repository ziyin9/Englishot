//
//  LowConfidenceView.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/16/25.
//

import SwiftUI

struct LowConfidenceView: View {
    let image: UIImage?
    let confidenceLevel: Double
    @Binding var showLowConfidenceView: Bool
    @Binding var showingCamera: Bool
    
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Error header
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                    
                    Text("物件未辨識")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                
                // Confidence information
                Text("辨識度：\(String(format: "%.1f", confidenceLevel * 100))%")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                
                // Image preview with crossed out effect
                if let capturedImage = image {
                    ZStack {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 3)
                            )
                            .shadow(color: .red.opacity(0.5), radius: 5)
                            .saturation(0.3) // Reduce saturation to make it look more "failed"
                        
                        // Diagonal cross
                        ZStack {
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 3, height: 250)
                                .rotationEffect(Angle(degrees: 45))
                            
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 3, height: 250)
                                .rotationEffect(Angle(degrees: -45))
                        }
                        .opacity(0.7)
                    }
                }
                
                // Error message
                VStack(spacing: 10) {
                    Text("未能辨識出符合的物件")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("您拍攝的物件辨識度低於30%，可能不是我們預期的物件或拍攝條件不佳")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)
                    
                    Text("建議: 請確認拍攝的是正確的物件，並在良好的光線下拍攝")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(12)
                
                // Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        showLowConfidenceView = false
                    }) {
                        Text("關閉")
                            .frame(width: 100, height: 40)
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showingCamera = true
                        showLowConfidenceView = false
                    }) {
                        Text("再試一次")
                            .frame(width: 100, height: 40)
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
