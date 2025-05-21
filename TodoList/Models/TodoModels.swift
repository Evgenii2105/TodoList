//
//  TodoModels.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import Foundation

struct TodoModels: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case todos = "todos"
        case total = "total"
        case skip = "skip"
        case limit = "limit"
    }
    
    let todos: [TodoListModel]
    let total: Int
    let skip: Int
    let limit: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        todos = try container.decodeIfPresent([TodoListModel].self, forKey: .todos) ?? []
        total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        skip = try container.decodeIfPresent(Int.self, forKey: .skip) ?? 0
        limit = try container.decodeIfPresent(Int.self, forKey: .limit) ?? 0
    }
}
