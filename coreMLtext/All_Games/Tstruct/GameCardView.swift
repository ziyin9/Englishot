//
//  GameCardView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 2/12/25.
//

//在關卡裡收集的可顯示的card

import SwiftUI

struct GameCardView: View {
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>

    @EnvironmentObject var uiState: UIState
    var vocabulary: [Vocabulary] // 傳入的單字陣列
    
    @State private var isCardVisible: Bool = true
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isDragging = false

    var body: some View {
        ZStack {
            // Semi-transparent background overlay
//            if isCardVisible {
            

            if uiState.showGameCardView {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            uiState.showGameCardView = false
                        }
                    }
                

                VStack(spacing: 20) {

                    TabView(selection: $currentIndex) {
                        ForEach(Array(vocabulary.enumerated()), id: \.element.id) { index, item in
                            VStack(spacing: 15) {
                                // Image section
                                if let wordEntity = findMatchingWordEntity(for: item),
                                   let itemImageData = wordEntity.itemimage,
                                   let itemImage = UIImage(data: itemImageData) {
                                    Image(uiImage: itemImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)
//                                        .clipShape(Circle())
//                                        .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 2))
                                        .shadow(color: .blue.opacity(0.3), radius: 8)
                                    Text(item.E_word)
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary)
                                    
                                    Text(item.C_word)
                                        .font(.system(size: 20, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                                
//                                // Word and definition
//                                Text(item.E_word)
//                                    .font(.system(size: 28, weight: .bold, design: .rounded))
//                                    .foregroundColor(.primary)
//                                
//                                Text(item.C_word)
//                                    .font(.system(size: 20, design: .rounded))
//                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 300, height: 280)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .blue.opacity(0.2), radius: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.white.opacity(0.6), .blue.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .tag(index)
//                            .rotation3DEffect(.degrees(isDragging ? (offset > 0 ? -5 : 5) : 0), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .frame(height: 300)
                    

                }
                .padding(.vertical, 30)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    offset = value.translation.width
                }
                .onEnded { value in
                    isDragging = false
                    offset = 0
                }
        )
    }

    // 查找匹配的 wordEntity
    private func findMatchingWordEntity(for item: Vocabulary) -> Word? {
        return wordEntities.first { $0.word == item.E_word }
    }
    
}
//
//#Preview {
//    GameCardView(vocabulary: [Vocabulary(E_word: "Apple", C_word: "蘋果"), Vocabulary(E_word: "Banana", C_word: "香蕉")])
//}


//
//#Preview {
//    GameCardView(vocabulary:[vocabularyList[0],vocabularyList[15]])
//}
