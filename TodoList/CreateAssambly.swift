//
//  CreateAssambly.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class TodoListModuleBuilder {
    
    static func build() -> UIViewController {
        let view = TodoListViewController()
        let interactor = TodoListInteractorImpl(todoItemRepository: TodoItemRepositoryimpl(coreDataManager: CoreDataManager.shared))
        let router = TodoListRouterimpl()
        let presenter = TodoListPresenterImpl(view: view, interactor: interactor)
        
        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        interactor.router = router
        router.viewController = view
        
        return view
    }
}
