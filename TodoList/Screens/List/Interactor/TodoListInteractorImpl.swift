//
//  TodoListInteractorimpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit
import CoreData

final class TodoListInteractorImpl: TodoListInteractor {

    weak var presenter: TodoListInteractorOutput?
    private let dataManager: DataManagerService = DataManagerServiceImpl()
    private let todoItemRepository: TodoItemRepository
    var router: TodoListRouter?
    
    init(todoItemRepository: TodoItemRepository) {
        self.todoItemRepository = todoItemRepository
    }

    // MARK: - Interfaces
    func fetchTodos() {
        let coreDataItems = todoItemRepository.fetchTodos()
        if coreDataItems.isEmpty {
            dataManagerGetTodos { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    for todo in success {
                        self.todoItemRepository.saveTodo(
                            title: todo.title,
                            subtitle: "",
                            userId: Int64(todo.userId),
                            id: Int64(todo.id),
                            isCompleted: todo.completed,
                            date: TodoListHelper.array.randomElement() ?? Date.now
                        )
                    }
                    self.presenter?.didFetchTodos(self.todoItemRepository.fetchTodos().map({ $0.todoListItem() }))
                case .failure(let failure):
                    self.presenter?.didFailToFetchTodos(with: failure)
                }
            }
        } else {
            dataManagerGetTodos { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let remote):
                    for todo in remote {
                        if let item = coreDataItems.first(where: { $0.id == todo.id }) {
                            self.todoItemRepository.updateTodo(
                                id: Int64(todo.id),
                                newTitle: todo.title,
                                newSubtitle: item.subtitle ?? "",
                                newIsCompleted: todo.completed,
                                date: TodoListHelper.array.randomElement() ?? Date.now
                            )
                        } else {
                            self.todoItemRepository.saveTodo(
                                title: todo.title,
                                subtitle: "",
                                userId: Int64(todo.userId),
                                id: Int64(todo.id),
                                isCompleted: todo.completed,
                                date: TodoListHelper.array.randomElement() ?? Date.now
                            )
                        }
                    }
                    self.presenter?.didFetchTodos(self.todoItemRepository.fetchTodos().map({ $0.todoListItem() }))
                case .failure(let failure):
                    self.presenter?.didFailToFetchTodos(with: failure)
                }
            }
        }
    }

    func removeTodo(at index: Int) {
        todoItemRepository.deleteTodo(with: index)
        presenter?.didRemoveTodo(at: index)
    }

    func searchTodo(with query: String?) {
       let filteredTodos = todoItemRepository.searchTodos(with: query)
        presenter?.didFetchTodos(filteredTodos.map({ $0.todoListItem() }))
    }

    func showDetails(state: TodoListItemState) {
        router?.navigateToDetails(with: state, listener: self)
    }
    
    private func dataManagerGetTodos(completion: @escaping (Result<[TodoListModel], NetworkError>) -> Void) {
        dataManager.getTodos { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    completion(.success(success))
                case .failure(let failure):
                    completion(.failure(.dicodingFailed(failure)))
                }
            }
        }
    }
}

extension TodoListInteractorImpl: DetailsTodoListener {

    func saveTodo(_ todoListItem: TodoListItem) {
        todoItemRepository.saveTodo(
            title: todoListItem.title,
            subtitle: todoListItem.subtitle,
            userId: Int64(todoListItem.userId),
            id: Int64(todoListItem.id),
            isCompleted: todoListItem.isCompleted,
            date: todoListItem.date
        )
       presenter?.didUpdateTodoListItem(with: todoListItem)
    }
}
