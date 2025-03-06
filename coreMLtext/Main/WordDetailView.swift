//
//  WordDetailView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 1/20/25.
//


//
//  Untitled.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/1/20.
//
import SwiftUI
import AVFoundation

struct WordDetailView: View {
    var vocabulary: Vocabulary
    var showimage: Data?
    @StateObject private var audioPlayer = AudioPlayer()
    @Environment(\.presentationMode) var presentationMode

    @State private var isBackButtonHovered = false
    @State private var isArrowGlowing = false
    @State private var arrowPhase = 0.0
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                HStack {
                                   Button(action: {
                                       presentationMode.wrappedValue.dismiss()
                                   }) {
                                       ZStack {
                                           // Background
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
                                           
                                           // Enhanced Ice Arrow Effect
                                           ZStack {
                                               // Magical glow effect
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
                                               
                                               // Ice crystal frame
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
                                               
                                               // Main arrow with ice effect
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
                                               
                                               // Floating ice crystals
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
                                   }
                                   .buttonStyle(PlainButtonStyle())
                                   .onAppear {
                                       withAnimation(
                                           .easeInOut(duration: 2)
                                           .repeatForever(autoreverses: true)
                                       ) {
                                           isArrowGlowing = true
                                       }
                                       
                                       withAnimation(
                                           .linear(duration: 3)
                                           .repeatForever(autoreverses: false)
                                       ) {
                                           arrowPhase = 2 * .pi
                                       }
                                   }
                                   .onHover { hovering in
                                       withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                           isBackButtonHovered = hovering
                                       }
                                   }
                                   Spacer()
                               }
                               .padding()

                VStack(spacing: 20) {
                    HStack {
                        Text(vocabulary.E_word.capitalized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(vocabulary.C_word)
                            .font(.title3)
                        
                        
                        Button(action: {
                            if let url = URL(string: vocabulary.audioURL) {
                                audioPlayer.playSound(from: url)
                            }
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                    }

//                    Image(vocabulary.assetName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 200)

//                    Image(uiImage: vocabulary.shotImage ?? UIImage(systemName: "photo") ?? UIImage())
//                           .resizable()
//                           .scaledToFit()
//                           .cornerRadius(10)
                    
                    if let imageData = showimage, let image = UIImage(data: imageData) {
                        // image 是轉換後的 UIImage 物件
                        // 在這裡可以使用 image 來顯示在界面上
                        Image(uiImage: image)  // 使用 uiImage 來顯示
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    }
                    
                            
                    
                    
                    Text("例句: \(vocabulary.exSentence)")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}




#Preview {
    WordDetailView(vocabulary: Vocabulary(category: "Kitchen", E_word: "fork", C_word: "叉子", exSentence: "I use a fork to eat.", audioURL: "https://www.example.com/fork.mp3"))}




