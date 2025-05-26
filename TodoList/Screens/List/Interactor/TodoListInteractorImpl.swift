//
//  TodoListInteractorimpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit
import CoreData

import UIKit

final class TodoListInteractorImpl: TodoListInteractor {
    
    weak var presenter: TodoListInteractorOutput?
    private let dataManager: DataManagerService = DataManagerServiceImpl()
    private let coreDataManager: CoreDataManager = .shared
    private var todos: [TodoListItem] = []
    var router: TodoListRouter?
    
    // MARK: - Interfaces
    func fetchTodos() {
        dataManager.getTodos { [weak self] result in
            switch result {
            case .success(let response):
                let items = response.todos.map({ $0.toCellTodo() })
                self?.todos = items
                DispatchQueue.main.async {
                    self?.presenter?.didFetchTodos(items)
                }
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
    
    func searchTodo(with query: String?) {
        guard let query = query, !query.isEmpty else {
            presenter?.didFetchTodos(todos)
            return
        }
        
        let queryLow = query.lowercased()
        
        let filteredTodos = todos.filter({
            $0.title.lowercased().contains(queryLow) ||
            $0.subtitle.lowercased().contains(queryLow)
        })
        presenter?.didFetchTodos(filteredTodos)
    }
    
    func showDetails(state: TodoListItemState) {
        router?.navigateToDetails(with: state, listener: self)
    }
}

extension TodoListInteractorImpl: DetailsTodoListener {
    
    func saveTodo(_ todoListItem: TodoListItem) {
        
        if let index = self.todos.firstIndex(where: { $0.id == todoListItem.id }) {
            todos[index] = todoListItem
        } else {
            self.todos.insert(todoListItem, at: self.todos.startIndex)
        }
        presenter?.didUpdateTodoListItem(with: todoListItem)
    }
}

