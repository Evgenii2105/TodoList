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
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
    
    weak var delegate: CustomTableDelegate?
    
    private let statusButton: UIButton = {
       let statusButton = UIButton()
        statusButton.setTitle("", for: .normal)
        statusButton.tintColor = .yellow
        return statusButton
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 12, weight: .light)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.backgroundColor = .clear
        return dateLabel
    }()
    
    private let titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .clear
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
       let subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .light)
        subtitleLabel.backgroundColor = .clear
        return subtitleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statusButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(dateLabel)
        setupConstraints()
        contentView.backgroundColor = .black
        
        statusButton.addTarget(self, action: #selector(changeStateDone), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        statusButton.addConstraint(constraints: [
            statusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusButton.widthAnchor.constraint(equalToConstant: 50),
            statusButton.heightAnchor.constraint(equalToConstant: 50),
        ])
                
        titleLabel.addConstraint(constraints: [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        subtitleLabel.addConstraint(constraints: [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        dateLabel.addConstraint(constraints: [
            dateLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
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
        statusButton.isSelected = todos.isCompleted
        dateLabel.text = Self.formatter.string(from: todos.date)
        
        let imageName = todos.isCompleted ? "checkmark.circle.fill" : "circle"
        statusButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        subtitleLabel.text = todos.subtitle.isEmpty ? "Текст отсутвует" : todos.subtitle
        
        if todos.isCompleted {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(todos.title)")
            attributeString.addAttributes([
                .strikethroughStyle: 2,
                .foregroundColor: UIColor.white
            ], range: NSRange(location: 0, length: attributeString.length))
            titleLabel.attributedText = attributeString
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = todos.title
        }
    }
} 
