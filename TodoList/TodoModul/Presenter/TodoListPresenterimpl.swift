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

    init(view: TodoListView? = nil, interactor: TodoListInteractor) {
        self.view = view
        self.interactor = interactor
    }
}

extension TodoListPresenterimpl: TodoListPresenter {
    
    func didUpdateTodoListItem(with todo: TodoListItem) {
        view?.insertTodos(todo)
    }
    
    func makeTodoDetailPresenter(todo: TodoListItem?) {
        interactor?.makeTodoDetailInteractor(todo: todo)
    }
   
    func didTapAddNewTodo(_ todo: TodoListItem) {
        view?.insertTodos(todo)
    }
    
    func fetchTodos() {
        interactor?.fetchTodos()
    }
    
    func didFetchTodos(_ items: [TodoListItem]) {
        self.view?.showTodos(items)
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
    
    func searchTodo(with query: String?) {
        interactor?.searchTodo(with: query)
    }
}
