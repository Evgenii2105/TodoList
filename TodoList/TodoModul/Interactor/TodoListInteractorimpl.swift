//
//  TodoListInteractorimpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

class TodoListInteractorimpl: TodoListInteractor {
   
    weak var presenter: TodoListPresenter?
    private let dataManager: DataManagerService = DataManagerServiceImpl()
    private var todos: [TodoListItem] = []
    
    func fetchTodos() {
        dataManager.getTodos { [weak self] result in
            switch result {
            case .success(let response):
                let items = response.todos.map({ $0.toCellTodo() })
                self?.todos = items
                self?.presenter?.didFetchTodos(items)
            case .failure(let error):
                self?.presenter?.didFailToFetchTodos(with: error)
            }
        }
    }
    
    func removeTodo(at index: Int) {
        guard index < todos.count else { return }
        todos.remove(at: index)
        presenter?.didRemoveTodo(at: index)
    }
}
