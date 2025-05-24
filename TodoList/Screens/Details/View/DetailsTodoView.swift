//
//  DetailsTodoView.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

protocol DetailsTodoView: AnyObject {
    func configure(with state: TodoListItemState)
}
