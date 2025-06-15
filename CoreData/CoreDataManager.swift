//
//  CoreDataManager.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 1/22/25.
//


import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    // NSPersistentContainer 用來管理 CoreData 堆疊
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    // NSManagedObjectContext
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // save
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}
