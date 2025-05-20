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
        let todoListViewController = TodoListViewController()
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = todoListViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
