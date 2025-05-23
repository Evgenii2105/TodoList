//
//  TodoListInteractor.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

protocol TodoListInteractor: AnyObject {
    func fetchTodos()
    func removeTodo(at index: Int)
    func searchTodo(with query: String?)
    func saveTodo(_ todo: TodoListItem)
    func makeTodoDetailInteractor(todo: TodoListItem?)
}
