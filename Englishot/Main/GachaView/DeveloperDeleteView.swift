//
//  DeveloperDeleteView.swift
//  Englishot
//
//  Created by 陳姿縈 on 6/17/25.
//
import SwiftUI
import CoreData


struct DeveloperDeleteView: View {
    @Environment(\.dismiss) var dismiss
    @State private var words: [PenguinCardWord] = []
    @Binding var refreshTrigger: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(words, id: \.self) { word in
                    HStack {
                        Text(word.penguinword ?? "")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Button(action: {
                            deleteWord(word: word)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Developer Delete")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadWords()
        }
    }
    
    private func loadWords() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<PenguinCardWord> = PenguinCardWord.fetchRequest()
        
        do {
            words = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch words: \(error)")
        }
    }
    
    private func deleteWord(word: PenguinCardWord) {
        let context = CoreDataManager.shared.context
        context.delete(word)
        
        do {
            try context.save()
            if let index = words.firstIndex(of: word) {
                words.remove(at: index)
            }
            refreshTrigger.toggle()
        } catch {
            print("Failed to delete word: \(error)")
        }
    }
}
