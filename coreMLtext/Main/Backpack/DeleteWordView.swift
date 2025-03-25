//
//  DeleteWordView.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/25/25.
//


//
//  DeleteWordView.swift
//  Englishot
//
//  Created by 李庭宇 on 2025/3/25.
//

import SwiftUI
import CoreData

struct DeleteWordView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var wordEntities: [Word]
    @Environment(\.managedObjectContext) private var viewContext // 引用 managedObjectContext
    
    var body: some View {
        NavigationView {
            List {
                ForEach(wordEntities, id: \.self) { word in
                    if let unwrappedWord = word.word { // 解包 word.word
                        Button(action: {
                            deleteWord(word) // 刪除方法
                        }) {
                            Text(unwrappedWord)  // 使用解包後的值
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Select Word to Delete", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }
    
    // 刪除單字的邏輯
    func deleteWord(_ word: Word) {
        // 刪除 Word 實體
        viewContext.delete(word)
        
        // 儲存改動到 Core Data
        do {
            try viewContext.save()  // 將刪除操作保存到 Core Data
            // 刪除後需要從綁定的數組中移除
            if let index = wordEntities.firstIndex(of: word) {
                wordEntities.remove(at: index)
            }
        } catch {
            print("Error deleting word: \(error.localizedDescription)")
        }
    }
}