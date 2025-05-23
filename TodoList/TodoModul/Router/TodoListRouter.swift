//
//  TodoListRouter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 21.05.2025.
//

import Foundation

protocol TodoListRouter: AnyObject {
    func navigateToDetails(with todo: TodoListItem?, listener: DetailsTodoListener)
}
