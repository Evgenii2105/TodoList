//
//  DetailsTodoPresenter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

protocol DetailsTodoPresenter: AnyObject {
    func showDetails(_ todosDetails: TodoListItem)
}
