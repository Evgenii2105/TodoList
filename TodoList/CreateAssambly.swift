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
        let interactor = TodoListInteractorimpl()
        let router = TodoListRouterimpl()
        let presenter = TodoListPresenterimpl(view: view,
                                              interactor: interactor,
                                              router: router)
        
        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        
        return view
    }
}
