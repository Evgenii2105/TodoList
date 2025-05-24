//
//  TodoListRouter.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class TodoListRouterimpl: TodoListRouter {
    
    weak var viewController: UIViewController?
    
    func navigateToDetails(with state: TodoListItemState, listener: DetailsTodoListener) {
        let view = DetailsTodoViewController()
        let interactor = DetailsTodoInteractorImpl()
        let router = DetailsTodoRouterImpl()
        let presenter = DetailsTodoPresenterImpl(
            view: view,
            state: state,
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
