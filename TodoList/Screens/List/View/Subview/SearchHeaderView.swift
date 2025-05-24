//
//  SearchHeaderView.swift
//  TodoList
//
//  Created by Евгений Фомичев on 21.05.2025.
//

import UIKit

protocol SearchHeaderViewListener: AnyObject {
    func searchHeaderView(_ headerView: SearchHeaderView, didUpdateSearchText text: String)
}

class SearchHeaderView: UITableViewHeaderFooterView {
    
    static let headerIdentifier = "SearchHeaderView"
    weak var listener: SearchHeaderViewListener?
    
    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.white]
        )
        
        searchTextField.borderStyle = .roundedRect
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.layer.cornerRadius = 8
        searchTextField.backgroundColor = .black
        searchTextField.textColor = .white
        
        // Левая иконка
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImageView.tintColor = .gray
        searchImageView.contentMode = .scaleAspectFit
        
        let imageContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        searchImageView.frame = CGRect(x: 8, y: 0, width: 24, height: 30)
        imageContainer.addSubview(searchImageView)
        
        searchTextField.leftView = imageContainer
        searchTextField.leftViewMode = .always
        
        // Правая иконка
        let voiceButton = UIButton(type: .custom)
        voiceButton.setImage(UIImage(systemName: "microphone.fill"), for: .normal)
        voiceButton.tintColor = .gray
        voiceButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        
        let voiceContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        voiceButton.center = voiceContainer.center
        voiceContainer.addSubview(voiceButton)
        
        searchTextField.rightView = voiceContainer
        searchTextField.rightViewMode = .always
        
        return searchTextField
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        searchTextField.addConstraint(constraints: [
            searchTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupUI() {
        contentView.addSubview(searchTextField)
        searchTextField.delegate = self
    }
}

extension SearchHeaderView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == searchTextField,
              let text = textField.text,
              let textRange = Range(range, in: text) else { return true }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        listener?.searchHeaderView(self, didUpdateSearchText: updatedText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
