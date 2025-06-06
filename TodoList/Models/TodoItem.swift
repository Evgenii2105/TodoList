//
//  TodoItem.swift
//  TodoList
//
//  Created by Евгений Фомичев on 02.06.2025.
//

import CoreData

protocol TodoItemProtocol: AnyObject {
    func todoListItem() -> TodoListItem
}

@objc(TodoItem)
public class TodoItem: NSManagedObject, Identifiable {

    @nonobjc static var fetchRequest: NSFetchRequest<TodoItem> {
        .init(entityName: String(describing: Self.self))
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var userId: Int64
    @NSManaged public var date: Date
    
    convenience init(
        id: Int64,
        title: String?,
        subtitle: String?,
        isCompleted: Bool,
        userId: Int64,
        date: Date,
        context: NSManagedObjectContext
    ) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: TodoItem.self), in: context) else {
            throw CoreDataError.entityNotFound("TodoItem")
        }
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.userId = userId
        self.date = date
    }
}

extension TodoItem: TodoItemProtocol {
    
    func todoListItem() -> TodoListItem {
        return TodoListItem(
            id: Int(self.id),
            userId: Int(self.userId),
            title: self.title ?? "",
            subtitle: self.subtitle ?? "",
            isCompleted: self.isCompleted,
            date: self.date
        )
    }
}
