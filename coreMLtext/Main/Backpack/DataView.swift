//
//  DataView.swift
//  Englishot
//
//  Created by 陳姿縈 on 2/25/25.
//

import SwiftUI

struct DataView: View {
    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
    @Environment(\.dismiss) var dismiss
    
    // Categories and their respective icons
    private let categories = [
        ("Home", "house.fill"),
        ("Zoo", "pawprint.fill"),
        ("School", "book.fill"),
        ("Market", "cart.fill"),
        ("Mall", "bag.fill")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.white.opacity(0.3),
                        Color.blue.opacity(0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Snow effect
                SSnowfallView(intensity: 0.6)
                    .opacity(0.6)
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack{
                            Text("Collection Progress")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.7), .blue.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .padding(.top, 40)
                                .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                            Spacer()

                        }

                        // Total Progress Card
                        SettingsCard (){
                            VStack(spacing: 15) {
                                Text("Total Words")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                CircularProgressView(
                                    totalWords: vocabularyList.count,
                                    currentWords: wordEntities.count,
                                    circlewidth:100 ,
                                    circleheight:100
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Category Progress Cards
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(categories, id: \.0) { category, icon in
                                SettingsCard {
                                    VStack(spacing: 10) {
                                        HStack {
                                            Image(systemName: icon)
                                                .foregroundColor(.blue)
                                            Text(category)
                                                .font(.headline)
                                        }
                                        
                                        CircularProgressView(
                                            totalWords: totalWordsForCategory(category),
                                            currentWords: collectedWordsForCategory(category),
                                            circlewidth:100 ,
                                            circleheight:100
                                        )
                                        
                                        .frame( width: 150,height: 150)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton {
                        dismiss()
                    }
                }
            }
            
            
        }
    }
    
    // Calculate total words for a specific category
    private func totalWordsForCategory(_ bigtopic: String) -> Int {
        vocabularyList.filter { $0.bigtopic.hasPrefix(bigtopic) }.count
    }
    
    // Calculate collected words for a specific category
    private func collectedWordsForCategory(_ bigtopic: String) -> Int {
        wordEntities.filter { word in
            vocabularyList.contains { 
                $0.E_word == word.word && $0.bigtopic.hasPrefix(bigtopic)
            }
        }.count
    }
}

//struct ProgressStatView: View {
//    let label: String
//    let value: Int
//    let total: Int
//    var showPercentage: Bool = false
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(label)
//                .font(.headline)
//                .foregroundColor(.gray)
//            
//            HStack {
//                Text("\(value)\(showPercentage ? "%" : "")")
//                    .font(.system(size: 24, weight: .bold))
//                
//                if !showPercentage {
//                    Text("/ \(total)")
//                        .font(.system(size: 24))
//                        .foregroundColor(.gray)
//                }
//            }
//            
//            GeometryReader { geometry in
//                ZStack(alignment: .leading) {
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(height: 8)
//                        .cornerRadius(4)
//                    
//                    Rectangle()
//                        .fill(
//                            LinearGradient(
//                                colors: [.blue, .cyan],
//                                startPoint: .leading,
//                                endPoint: .trailing
//                            )
//                        )
//                        .frame(width: geometry.size.width * CGFloat(value) / CGFloat(total), height: 8)
//                        .cornerRadius(4)
//                }
//            }
//            .frame(height: 8)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(15)
//        .shadow(color: .gray.opacity(0.2), radius: 10)
//    }
//}

#Preview {
    DataView()
}
