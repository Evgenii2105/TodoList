//
//  TodoListPresenter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

final class TodoListPresenterimpl {
    
    weak var view: TodoListView?
    
    private let interactor: TodoListInteractor?
    private let router: TodoListRouter?

    init(view: TodoListView? = nil, interactor: TodoListInteractor, router: TodoListRouter?) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TodoListPresenterimpl: TodoListPresenter {
   
    func didTapAddNewTodo(_ todo: TodoListItem) {
        router?.navigateToDetails(with: todo)
    }
    
    func fetchTodos() {
        interactor?.fetchTodos()
    }
    
    func didFetchTodos(_ items: [TodoListItem]) {
        DispatchQueue.main.async {
            self.view?.showTodos(items)
        }
    }
    
    func didFailToFetchTodos(with error: Error) {
        print("error")
    }
    
    func remove(at index: Int) {
        interactor?.removeTodo(at: index)
    }
    
    func didRemoveTodo(at index: Int) {
        view?.removeTodo(index: index)
    }
}
