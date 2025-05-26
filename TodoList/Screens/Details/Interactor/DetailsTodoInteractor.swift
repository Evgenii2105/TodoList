//
//  DetailsTodoInteractor.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

protocol DetailsTodoListener: AnyObject {
    func saveTodo(_ todoListItem: TodoListItem)
}

protocol DetailsTodoInteractor: AnyObject {
    func saveTodo(item todo: TodoListItem)
}
