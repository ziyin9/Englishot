//
//  UnlockCardSheet.swift
//  Englishot
//
//  Created by 李庭宇 on 2025/6/18.
//

import SwiftUI
import CoreData

struct UnlockCardSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var refreshTrigger: Bool
    @ObservedObject var gachaSystem: GachaSystem
    
    @FetchRequest(
        entity: PenguinCardWord.entity(),
        sortDescriptors: []
    ) private var collectedPenguinWords: FetchedResults<PenguinCardWord>
    
    private var unCollectedCards: [PenguinCard] {
        
        let existingPenguinWords = Set(collectedPenguinWords.compactMap { $0.penguinword })
        
        let allCardWords = Set(gachaSystem.availableCards.map { $0.englishWord })
        
        let missingWords = allCardWords.subtracting(existingPenguinWords)
        
        return gachaSystem.availableCards.filter { card in
            missingWords.contains(card.englishWord)
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                    List {
                        ForEach(unCollectedCards) { card in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(card.cardName)
                                        .font(.system(size: 16, weight: .medium))
                                    Text(card.englishWord)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    unlockCard(card: card)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 24))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                
            }
            .navigationTitle("Developer Add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func unlockCard(card: PenguinCard) {
        addPenguinWord(word: card.englishWord)
        refreshTrigger.toggle()
    }
}
