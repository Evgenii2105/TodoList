//
//  Extension.swift
//  TodoList
//
//  Created by Евгений Фомичев on 21.05.2025.
//

import UIKit

extension UIView {
    
    func addConstraint(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            constraints
        )
    }
}
