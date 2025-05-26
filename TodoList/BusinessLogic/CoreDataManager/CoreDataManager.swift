//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Евгений Фомичев on 22.05.2025.
//

import UIKit
import CoreData

public final class CoreDataManager: NSObject {
    
    public static let shared = CoreDataManager()
    
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoItem")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error {
                print(error.localizedDescription)
            } else {
                print("DB URL -", storeDescription.url?.absoluteString)
            }
        })
        return container
    }()

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
    
 // MARK: - CRUD
    
    public func createTodo(
        title: String,
        subtitle: String,
        userId: Int64,
        id: Int64,
        isCompleted: Bool,
        date: Date
    ) {
        guard let todoEntityDescription = NSEntityDescription.entity(forEntityName: "TodoItem", in: context) else {
            return
        }
        let todo = TodoItem(entity: todoEntityDescription, insertInto: context)
        todo.title = title
        todo.subtitle = subtitle
        todo.userId = userId
        todo.id = id
        todo.isCompleted = isCompleted
        todo.date = date
        saveContext()
    }
    
    public func fecthTodos() -> [TodoItem] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
            return (try? context.fetch(fetchRequest) as? [TodoItem]) ?? []
    
    }
    
    public func updateTodo(id: Int64, newTitle: String, newSubtitle: String, newIsCompleted: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        guard let todos = try? context.fetch(fetchRequest) as? [TodoItem],
              let todo = todos.first(where: { $0.id == id }) else { return }
        todo.title = newTitle
        todo.subtitle = newSubtitle
        todo.isCompleted = newIsCompleted
        
        saveContext()
    }
    
    public func deleteTodo(with id: Int64) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        guard let todos = try? context.fetch(fetchRequest) as? [TodoItem],
              let todo = todos.first(where: { $0.id == id }) else { return }
        context.delete(todo)
        saveContext()
    }
}
