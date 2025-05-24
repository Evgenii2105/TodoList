//
//  DetailsTodoPresenterImpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class DetailsTodoPresenterImpl: DetailsTodoPresenter {
    
    weak var view: DetailsTodoView?
    private var state: TodoListItemState
    private let interactor: DetailsTodoInteractor?
    
    init(view: DetailsTodoView? = nil, state: TodoListItemState = .create, interactor: DetailsTodoInteractor?) {
        self.view = view
        self.state = state
        self.interactor = interactor
    }
    
    func saveTodo(_ text: String?) {
        guard let text = text, !text.isEmpty else { return }
        
        let components = text.components(separatedBy: .newlines)
        let title = components.first ?? ""
        let subtitle = components.dropFirst().joined(separator: "\n")
        
        var item: TodoListItem
        switch state {
        case .create:
            item = TodoListItem(
                id: Int.random(in: 0..<Int.max),
                userId: 1,
                title: title,
                subtitle: subtitle,
                isCompleted: false
            )
        case .update(let todoListItem):
            item = TodoListItem(
                id: todoListItem.id,
                userId: todoListItem.userId,
                title: title,
                subtitle: subtitle,
                isCompleted: todoListItem.isCompleted
            )
        }
        self.state = .update(item)
        interactor?.saveTodo(item: item)
    }
    
    func startTodoItem() {
        view?.configure(with: state)
    }
}

extension DetailsTodoPresenterImpl: DetailsTodoInteractorOutput {
    // callback from interactor if needed
}
