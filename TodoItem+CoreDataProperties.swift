//
//  TodoItem+CoreDataProperties.swift
//  TodoList
//
//  Created by Евгений Фомичев on 25.05.2025.
//
//

import Foundation
import CoreData

@objc(TodoItem)
public class TodoItem: NSManagedObject {

}

// MARK: - EXTENSION COREDATE
extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var userId: Int64
    @NSManaged public var date: Date
}

extension TodoItem: Identifiable {

}
