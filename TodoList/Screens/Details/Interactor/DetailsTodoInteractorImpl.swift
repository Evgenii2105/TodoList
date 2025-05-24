//
//  DetailsTodoInteractorImpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class DetailsTodoInteractorImpl: DetailsTodoInteractor {
   
    weak var presenter: DetailsTodoPresenter?
    weak var view: TodoListView?
    var router: DetailsTodoRouter?
    weak var listener: DetailsTodoListener?
    
    func saveTodo(item todo: TodoListItem?) {
        guard let todo = todo else { return }
        listener?.saveTodo(todo)
    }
}
