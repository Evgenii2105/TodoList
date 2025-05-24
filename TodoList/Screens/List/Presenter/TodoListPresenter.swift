//
//  TodoListPresenter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

protocol TodoListPresenter: AnyObject {
    func fetchTodos()
    func remove(at index: Int)
    func searchTodo(with query: String?)
    func showDetails(state: TodoListItemState)
}

protocol TodoListInteractorOutput: AnyObject {
    func didFetchTodos(_ items: [TodoListItem])
    func didRemoveTodo(at index: Int)
    func didUpdateTodoListItem(with todo: TodoListItem)
    func didFailToFetchTodos(with error: Error)
}
