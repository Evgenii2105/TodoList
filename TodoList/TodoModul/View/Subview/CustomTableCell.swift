//
//  CustomTableCell.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

protocol CustomTableDelegate: AnyObject {
    func tapStatusButton(cell: CustomTableCell, isSelected: Bool)
}

class CustomTableCell: UITableViewCell {
    
    static let celIdentifire = "CustomTableCell"
    
    weak var delegate: CustomTableDelegate?
    
    private let statusButton: UIButton = {
       let statusButton = UIButton()
        statusButton.setTitle("", for: .normal)
        statusButton.tintColor = .yellow
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        return statusButton
    }()
    
    private let dateLabel: Date = {
        let dateLabel = Date()
      //  dateLabel.
        return dateLabel
    }()
    
    private let titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .clear
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
       let subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .light)
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()
    
    private let container: UIView = {
       let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        return container
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(container)
        contentView.addSubview(statusButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        setupConstraints()
        contentView.backgroundColor = .black
        
        statusButton.addTarget(self, action: #selector(changeStateDone), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            statusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusButton.widthAnchor.constraint(equalToConstant: 50),
            statusButton.heightAnchor.constraint(equalToConstant: 50),
            
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            subtitleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
        ])
    }
    
    @objc
    private func changeStateDone(_ sender: UIButton) {
        sender.isSelected.toggle()
        let imageName = sender.isSelected ? "checkmark.circle.fill" : "circle"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        
        delegate?.tapStatusButton(cell: self, isSelected: sender.isSelected)
    }
    
    func configure(todos: TodoListItem) {
        titleLabel.text = todos.title
        subtitleLabel.text = todos.subtitle
        statusButton.isSelected = todos.isCompleted
        
        let imageName = todos.isCompleted ? "checkmark.circle.fill" : "circle"
        statusButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
