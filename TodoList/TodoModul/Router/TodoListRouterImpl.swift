//
//  TodoListRouter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class TodoListRouterimpl: TodoListRouter {
    
    weak var viewController: UIViewController?
    
    func navigateToDetails(with todo: TodoListItem?, listener: DetailsTodoListener) {
        let view = DetailsTodoViewController()
        let interactor = DetailsTodoInteractorImpl()
        let router = DetailsTodoRouterImpl()
        let presenter = DetailsTodoPresenterImpl(
            view: view,
            todoDetails: todo,
            interactor: interactor,
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.router = router
        interactor.listener = listener
        router.viewController = view
        
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}
