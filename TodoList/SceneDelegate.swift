//
//  SceneDelegate.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let view = TodoListViewController()
        let interactor = TodoListInteractorimpl()
        let router = TodoListRouterimpl()
        let presenter = TodoListPresenterimpl(
            view: view,
            interactor: interactor
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.router = router
        router.viewController = view
        
        window?.rootViewController = UINavigationController(rootViewController: view)
        window?.makeKeyAndVisible()
    }
}
