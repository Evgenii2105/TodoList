//
//  Debounce.swift
//  TodoList
//
//  Created by Евгений Фомичев on 22.05.2025.
//

import UIKit

final class Debouncer {
    
    private var timer: Timer?
    private let interval: TimeInterval
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    func debounce(action: @escaping () -> Void) {
        cancel()
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: false,
            block: { _ in action() }
        )
    }
    
    func cancel() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        cancel()
    }
}
