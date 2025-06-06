//
//  DataManager.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

protocol DataManagerService: AnyObject {
    func getTodos(completion: @escaping (Result<[TodoListModel], NetworkError>) -> Void)
}

final class DataManagerServiceImpl: DataManagerService {
  
    private let client = NetworkImpl()
    
    func getTodos(completion: @escaping (Result<[TodoListModel], NetworkError>) -> Void) {
        client.request(endPoint: .todos) { (result: Result<TodoModels, NetworkError>) in
            switch result {
            case .success(let todosResponse):
                completion(.success(todosResponse.todos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
