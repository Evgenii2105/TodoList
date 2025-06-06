//
//  TodoItemRepository.swift
//  TodoList
//
//  Created by Евгений Фомичев on 02.06.2025.
//

import CoreData

protocol TodoItemRepository: AnyObject {
   func saveTodo(
        title: String,
        subtitle: String,
        userId: Int64,
        id: Int64,
        isCompleted: Bool,
        date: Date
    )
    func deleteTodo(with index: Int)
    func updateTodo(id: Int64, newTitle: String, newSubtitle: String, newIsCompleted: Bool, date: Date)
    func fetchTodos() -> [TodoItem]
    func searchTodos(with query: String?) -> [TodoItem]
}

final class TodoItemRepositoryimpl {
    
    weak var ineractor: TodoListInteractor?
    private static let name = "TodoItem"
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
}

// MARK: - CRUD
extension TodoItemRepositoryimpl: TodoItemRepository {
       
    func searchTodos(with query: String?) -> [TodoItem] {
        guard let query,
              !query.isEmpty else {
            return coreDataManager.read(fetchRequest: TodoItem.fetchRequest)
        }
        let fetchRequest = TodoItem.fetchRequest
        fetchRequest.predicate = NSCompoundPredicate(
            type: .or,
            subpredicates: [
                NSPredicate(format: "%K contains[cd] %@", (\TodoItem.title).string, query),
                NSPredicate(format: "%K contains[cd] %@", (\TodoItem.subtitle).string, query)
            ]
        )
      //  fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)] сортировка массива
        return coreDataManager.read(fetchRequest: fetchRequest)
    }
    
    public func saveTodo(
        title: String,
        subtitle: String,
        userId: Int64,
        id: Int64,
        isCompleted: Bool,
        date: Date
    ) {
        let idPredicate = NSPredicate(format: "%K contains[cd] %d", (\TodoItem.id).string, id)
        let requset = TodoItem.fetchRequest
        requset.predicate = idPredicate
        if let todoItem = coreDataManager.read(fetchRequest: requset).first {
            todoItem.title = title
            todoItem.subtitle = subtitle
            todoItem.userId = userId
            todoItem.id = id
            todoItem.isCompleted = isCompleted
            todoItem.date = Date.now
            coreDataManager.saveContext()
        } else {
            guard let todoEntityDescription = coreDataManager.entityDescription(name: Self.name) else {
                return
            }
            coreDataManager.write { context in
                let todo = TodoItem(entity: todoEntityDescription, insertInto: context)
                todo.title = title
                todo.subtitle = subtitle
                todo.userId = userId
                todo.id = id
                todo.isCompleted = isCompleted
                todo.date = date
                coreDataManager.saveContext()
            }
        }
    }
    
    func deleteTodo(with index: Int) {
        let todos = coreDataManager.read(fetchRequest: TodoItem.fetchRequest)
        guard index < todos.count else { return }
        coreDataManager.delete(object: todos[index])
    }
    
    func updateTodo(id: Int64, newTitle: String, newSubtitle: String, newIsCompleted: Bool, date: Date) {
        let todos = coreDataManager.read(fetchRequest: TodoItem.fetchRequest)
        guard let todo = todos.first(where: { $0.id == id }) else { return }
        todo.title = newTitle
        todo.subtitle = newSubtitle
        todo.isCompleted = newIsCompleted
        todo.date = Date.now
        
        coreDataManager.saveContext()
    }
    
    func fetchTodos() -> [TodoItem] {
        coreDataManager.read(fetchRequest: TodoItem.fetchRequest)
    }
}
