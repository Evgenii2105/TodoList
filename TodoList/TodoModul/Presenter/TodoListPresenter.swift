//
//  TodoListPresenter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

protocol TodoListPresenter: AnyObject {
    func didFetchTodos(_ items: [TodoListItem])
    func didFailToFetchTodos(with error: Error)
    func fetchTodos()
    func remove(at index: Int)
    func didRemoveTodo(at index: Int)
    func searchTodo(with query: String?)
    func makeTodoDetailPresenter(todo: TodoListItem?)
    func didUpdateTodoListItem(with todo: TodoListItem)
}
