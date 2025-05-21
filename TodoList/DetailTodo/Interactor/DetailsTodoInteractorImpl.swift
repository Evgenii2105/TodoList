//
//  DetailsTodoInteractorImpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

class DetailsTodoInteractorImpl: DetailsTodoInteractor {
   
    weak var presenter: DetailsTodoPresenter?
    
    func showDetailsTodo(_ detailsTodos: TodoListItem) {
        presenter?.showDetails(detailsTodos)
    }
}
