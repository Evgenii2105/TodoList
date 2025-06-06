//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Евгений Фомичев on 22.05.2025.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case entityNotFound(String)
    case contextNotAvailable
    case saveFailed(Error)
}

public final class CoreDataManager: NSObject {
    
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String)
            container.loadPersistentStores(completionHandler: { _, error in
                if let error {
                    fatalError("Unresolved error \(error)")
                }
            })
            print(container.persistentStoreCoordinator.persistentStores.first!.url!)
            return container
        }()

    func entityDescription(name: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: name, in: context)
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func write(handler: (NSManagedObjectContext) -> Void) {
        handler(context)
    }
    
    func read(fetchRequest: NSFetchRequest<TodoItem>) -> [TodoItem] {
        return (try? context.fetch(fetchRequest)) ?? []
    }

    func delete(object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
