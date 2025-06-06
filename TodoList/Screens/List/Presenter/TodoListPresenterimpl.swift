//
//  TodoListPresenter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

final class TodoListPresenterImpl {
    
    weak var view: TodoListView?
    private let interactor: TodoListInteractor

    init(view: TodoListView, interactor: TodoListInteractor) {
        self.view = view
        self.interactor = interactor
    }
}

extension TodoListPresenterImpl: TodoListPresenter {
    
    func showDetails(state: TodoListItemState) {
        interactor.showDetails(state: state)
    }
    
    func fetchTodos() {
        interactor.fetchTodos()
    }
    
    func remove(at index: Int) {
        interactor.removeTodo(at: index)
    }
    
    func searchTodo(with query: String?) {
        interactor.searchTodo(with: query)
    }
}

extension TodoListPresenterImpl: TodoListInteractorOutput {
    
    func didFetchTodos(_ items: [TodoListItem]) {
        view?.showTodos(items)
    }
    
    func didUpdateTodoListItem(with todo: TodoListItem) {
        view?.insertTodos(todo)
    }
    
    func didRemoveTodo(at index: Int) {
        view?.removeTodo(index: index)
    }
    
    func didFailToFetchTodos(with error: Error) {
        view?.showError(message: error.localizedDescription)
    }
}
