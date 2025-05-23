//
//  DetailsTodoPresenterImpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

class DetailsTodoPresenterImpl: DetailsTodoPresenter {
    
    weak var view: DetailsTodoView?
    private var todoDetails: TodoListItem?
    private let interactor: DetailsTodoInteractor?
    
    init(view: DetailsTodoView? = nil, todoDetails: TodoListItem?, interactor: DetailsTodoInteractor?) {
        self.view = view
        self.todoDetails = todoDetails
        self.interactor = interactor
    }
    
    func saveTodo(_ text: String?) {
        guard let text = text, !text.isEmpty else { return }
        
        let components = text.components(separatedBy: .newlines)
        let title = components.first ?? ""
        let subtitle = components.dropFirst().joined(separator: "\n")
        
        if let detailItem = todoDetails {
            let updatedItem = TodoListItem(
                id: detailItem.id,
                userId: detailItem.userId,
                title: title,
                subtitle: subtitle,
                isCompleted: detailItem.isCompleted
            )
            self.todoDetails = updatedItem
        } else {
            let newTodo = TodoListItem(
                id: Int.random(in: 0..<Int.max),
                userId: 1,
                title: title,
                subtitle: subtitle,
                isCompleted: false
            )
            self.todoDetails = newTodo
        }
        interactor?.saveTodo(item: todoDetails)
    }
    
    func startTodoItem() {
        view?.configure(with: todoDetails)
    }
}
