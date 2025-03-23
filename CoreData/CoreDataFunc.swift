//
//  CoreDataFunc.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 1/22/25.
//

import UIKit
import CoreData


func addNewWord(wordString: String, image: UIImage) {

    let context = CoreDataManager.shared.context
    
    // 查找是否已經有相同的單字
    let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "word == %@", wordString)
    
    do {
        let existingWords = try context.fetch(fetchRequest)
        
        if let existingWord = existingWords.first {
            // 如果找到相同的單字，則更新它的圖片
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                existingWord.itemimage = imageData
                existingWord.controlshow = true
            }
        } else {
            // 如果沒有找到相同的單字，則創建新的單字
            let newWord = Word(context: context)
            newWord.word = wordString
            
            // 將 UIImage 轉換為 Binary Data
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                newWord.itemimage = imageData
                newWord.controlshow = true
            }
        }
        

        CoreDataManager.shared.saveContext()
        
    } catch {
        print("Fetch failed: \(error)")
    }
}



func fetchWords() -> [Word]? {
    let context = CoreDataManager.shared.context
    let request: NSFetchRequest<Word> = Word.fetchRequest()

    do {
        let words = try context.fetch(request)
        return words
    } catch {
        print("Failed to fetch words: \(error)")
        return nil
    }
}



func deleteWord(wordString: String) {

    let context = CoreDataManager.shared.context
    
    // 查找是否有相同的單字
    let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "word == %@", wordString)
    
    do {
        let words = try context.fetch(fetchRequest)
        
        // 如果找到了相應的單字，刪除
        if let wordToDelete = words.first {
            context.delete(wordToDelete)

            CoreDataManager.shared.saveContext()
        } else {
            print("No word found with the given name.")
        }
    } catch {
        print("Fetch failed: \(error)")
    }
}
