//
//  DetailsTodoPresenter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

protocol DetailsTodoPresenter: AnyObject {
    func saveTodo(_ text: String?)
    func startTodoItem()
}

protocol DetailsTodoInteractorOutput {
    // calbacks from interactor to Presenter
}
