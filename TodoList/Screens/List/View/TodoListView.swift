//
//  TodoListView.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

protocol TodoListView: AnyObject {
    func showTodos(_ todos: [TodoListItem])
    func removeTodo(index: Int)
    func insertTodos(_ todo: TodoListItem)
}
