//
//  CustomTableCell.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

protocol TodoCellDelegate: AnyObject {
    func tapStatusButton(cell: TodoCell, isSelected: Bool)
}

class TodoCell: UITableViewCell {
    
    private enum Constants {
        static let padding: CGFloat = 8
        static let statusButtonFrame = CGRect(x: 16, y: 16, width: 50, height: 50)
    }
    
    static let celIdentifier = "TodoCell"
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
    
    weak var delegate: TodoCellDelegate?
    
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
            statusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.statusButtonFrame.origin.y),
            statusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.statusButtonFrame.origin.x),
            statusButton.widthAnchor.constraint(equalToConstant: Constants.statusButtonFrame.width),
            statusButton.heightAnchor.constraint(equalToConstant: Constants.statusButtonFrame.height)
        ])
                
        titleLabel.addConstraint(constraints: [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding)
        ])
        
        subtitleLabel.addConstraint(constraints: [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding),
            subtitleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: Constants.padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding)
        ])
        
        dateLabel.addConstraint(constraints: [
            dateLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Constants.padding),
            dateLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: Constants.padding),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    @objc
    private func changeStateDone(_ sender: UIButton) {
        sender.isSelected.toggle()
        let imageName = sender.isSelected ? "checkmark.circle.fill" : "circle"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        
        updateTitleLabel(todoTitle: titleLabel.text ?? "", isCompleted: sender.isSelected)
        delegate?.tapStatusButton(cell: self, isSelected: sender.isSelected)
    }
    
    func configure(todos: TodoListItem) {
        statusButton.isSelected = todos.isCompleted
        dateLabel.text = Self.formatter.string(from: todos.date)
        
        let imageName = todos.isCompleted ? "checkmark.circle.fill" : "circle"
        statusButton.setImage(UIImage(systemName: imageName), for: .normal)
        updateTitleLabel(todoTitle: todos.title, isCompleted: todos.isCompleted)
        subtitleLabel.text = todos.subtitle.isEmpty ? "Текст отсутвует" : todos.subtitle
    }
    
    private func  updateTitleLabel(todoTitle: String, isCompleted: Bool) {
            let attributedString = NSMutableAttributedString(string: todoTitle)
            
            if isCompleted {
                attributedString.addAttributes([
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: UIColor.white,
                    .foregroundColor: UIColor.white
                ], range: NSRange(location: 0, length: attributedString.length))
            }
            titleLabel.attributedText = attributedString
    }
}
