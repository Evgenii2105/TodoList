//
//  DetailsTodoPresenterImpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

class DetailsTodoPresenterImpl: DetailsTodoPresenter {
    
    weak var view: DetailsTodoView?
    private let todoDetails: TodoListItem?
    private let interactor: DetailsTodoInteractor?
    private let router: DetailsTodoRouter?
    
    init(view: DetailsTodoView? = nil, todoDetails: TodoListItem?, interactor: DetailsTodoInteractor?, router: DetailsTodoRouter?) {
        self.view = view
        self.todoDetails = todoDetails
        self.interactor = interactor
        self.router = router
    }
    
    func showDetails(_ todosDetails: TodoListItem) {
        interactor?.showDetailsTodo(todosDetails)
    }
}
