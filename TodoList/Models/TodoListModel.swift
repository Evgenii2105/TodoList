//
//  TodoListModels.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

struct TodoListModel: Decodable {
    
    let id: Int
    let title: String
    let completed: Bool
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case todo = "todo"
        case completed = "completed"
        case userId = "userId"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .todo)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        self.userId = try container.decode(Int.self, forKey: .userId)
    }
}

extension TodoListModel {
    func toCellTodo() -> TodoListItem {
        return TodoListItem(
            id: id,
            userId: userId,
            title: title,
            subtitle: "",
            isCompleted: completed,
            date: TodoListHelper.array.randomElement() ?? Date.now
        )
    }
}
