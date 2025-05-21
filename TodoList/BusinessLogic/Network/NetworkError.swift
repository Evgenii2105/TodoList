//
//  NetworkError.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(String)
    case noData
    case dicodingFailed(Error)
}
