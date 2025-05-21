//
//  TodoListRouter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class TodoListRouterimpl: TodoListRouter, DetailsTodoRouter {
    
    weak var viewController: UIViewController?
    
    func navigateToDetails(with todo: TodoListItem) {
        let view = DetailsTodoViewController()
        let interactor = DetailsTodoInteractorImpl()
        let router = DetailsTodoRouterImpl()
        let presenter = DetailsTodoPresenterImpl(
            view: view,
            todoDetails: todo,
            interactor: interactor,
            router: router 
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
    
    func showTodoDetails(_ todo: TodoListItem) {
        
    }
    
    func showAddTodo() {
        
    }
}
