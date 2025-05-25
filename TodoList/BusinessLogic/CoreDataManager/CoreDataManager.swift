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
        appDelegate.persistentContainer.viewContext
    }
    
    // create
    // read
    // update
    // delete
    
    public func createTodo(title: String, subtitle: String, userId: Int, ptiority: Int16 = 0) {
        // let newItem = TodoItem(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>)
    }
}
