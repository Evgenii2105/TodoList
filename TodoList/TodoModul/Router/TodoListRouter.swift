//
//  TodoListRouter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 21.05.2025.
//

import Foundation

protocol TodoListRouter: AnyObject {
    func showTodoDetails(_ todo: TodoListItem)
    func showAddTodo()
    func navigateToDetails(with todo: TodoListItem)
}
