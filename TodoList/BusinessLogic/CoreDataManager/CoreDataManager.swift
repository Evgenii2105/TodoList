//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Евгений Фомичев on 22.05.2025.
//

import UIKit
import CoreData

public final class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createTodo(_ todo: String) {
        
    }
}
