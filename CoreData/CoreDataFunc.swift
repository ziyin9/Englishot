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





//
//  CoinFunc


func initializeCoinIfNeeded() {
    let context = CoreDataManager.shared.context
    let fetchRequest: NSFetchRequest<Coin> = Coin.fetchRequest()

    do {
        let coins = try context.fetch(fetchRequest)
        if coins.isEmpty {
            let newCoin = Coin(context: context)
            newCoin.amount = 0
            CoreDataManager.shared.saveContext()
        }
    } catch {
        print("Failed to fetch Coin: \(error)")
    }
}

func fetchCoin() -> Coin? {
    let context = CoreDataManager.shared.context
    let fetchRequest: NSFetchRequest<Coin> = Coin.fetchRequest()

    do {
        let coins = try context.fetch(fetchRequest)
        return coins.first
    } catch {
        print("Failed to fetch Coin: \(error)")
        return nil
    }
}

func addCoin(by amountToAdd: Int64) {
    let context = CoreDataManager.shared.context
    let fetchRequest: NSFetchRequest<Coin> = Coin.fetchRequest()

    do {
        let coins = try context.fetch(fetchRequest)
        if let coin = coins.first {
            coin.amount += amountToAdd
        } else {
            let newCoin = Coin(context: context)
            newCoin.amount = amountToAdd
        }
        CoreDataManager.shared.saveContext()
    } catch {
        print("Failed to fetch Coin: \(error)")
    }
}

func deductCoin(by amountToDeduct: Int64) {
    let context = CoreDataManager.shared.context
    let fetchRequest: NSFetchRequest<Coin> = Coin.fetchRequest()

    do {
        let coins = try context.fetch(fetchRequest)
        if let coin = coins.first {
            coin.amount = max(0, coin.amount - amountToDeduct)
            CoreDataManager.shared.saveContext()
        }
    } catch {
        print("Failed to fetch Coin: \(error)")
    }
}



//Penguin

func addPenguinWord(word: String) {
    let context = CoreDataManager.shared.context

    // 先檢查資料庫內是否已經存在這個 word
    let fetchRequest: NSFetchRequest<PenguinCardWord> = PenguinCardWord.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "penguinword == %@", word)

    do {
        let results = try context.fetch(fetchRequest)
        if results.isEmpty {
            // 沒有重複，可以新增
            let newEntry = PenguinCardWord(context: context)
            newEntry.penguinword = word

            CoreDataManager.shared.saveContext()
            print("成功新增 penguinword: \(word)")
        } else {
            // 已經存在，不重複加入
            print("已存在 penguinword: \(word)，不重複加入")
        }
    } catch {
        print("檢查失敗: \(error)")
    }
}


func deletePenguinWord(wordString: String) {

    let context = CoreDataManager.shared.context
    
    // 查找是否有相同的單字
    let fetchRequest: NSFetchRequest<PenguinCardWord> = PenguinCardWord.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "penguinword == %@", wordString)
    
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


