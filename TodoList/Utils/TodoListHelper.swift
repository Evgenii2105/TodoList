//
//  TodoListHelper.swift
//  TodoList
//
//  Created by Евгений Фомичев on 25.05.2025.
//

import Foundation

enum TodoListHelper {
    
    static let array: [Date] = {
        var array = [Date]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.date(from: "2020-01-01")!
        let endDate = formatter.date(from: "2025-05-23")!
        for date in 0..<40 {
            array.append(Date.randomBetween(start: startDate, end: endDate))
        }
        return array
    }()
}

extension Date {
    static func randomBetween(start: Date, end: Date) -> Date {
        let date1 = min(start, end)
        var date2 = max(start, end)
        if date1 == date2 {
            date2 = date1.addingTimeInterval(120) 
        }
        let timeIntervalRange = date1.timeIntervalSince1970...date2.timeIntervalSince1970
        let randomTimeInterval = TimeInterval.random(in: timeIntervalRange)
        return Date(timeIntervalSince1970: randomTimeInterval)
    }
}
