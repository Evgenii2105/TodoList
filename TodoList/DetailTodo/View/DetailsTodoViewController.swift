//
//  DetailsTodoViewController.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

class DetailsTodoViewController: UIViewController {
    
    var presenter: DetailsTodoPresenter?
    private lazy var debounce = Debouncer(interval: 1)
    private var timer: Timer?
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 22, weight: .bold)
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        tapGesture()
        presenter?.startTodoItem()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleTextView)
        setupTextViews()
        setupNavigationBar()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        
        let image = UIImage(systemName: "chevron.left")
        backButton.setImage(image, for: .normal)
        backButton.setTitle("Назад", for: .normal)
        
        backButton.tintColor = .yellow
        backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        let backBarItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarItem
    }
    
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupTextViews() {
        titleTextView.delegate = self
    }
}

extension DetailsTodoViewController: DetailsTodoView {
    
    func configure(with todo: TodoListItem?) {
        guard let todo = todo else { return }
        
        let fullText = "\(todo.title)\n\(todo.subtitle)"
        titleTextView.text = fullText
        updateTextStyles()
    }
}

extension DetailsTodoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextStyles()
        debounce.debonce { [weak self] in
            guard let self = self else { return }
           
            self.presenter?.saveTodo(titleTextView.text)
        }
    }
    
    private func updateTextStyles() {
        guard let text = titleTextView.text, !text.isEmpty else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: text.utf16.count)
        
        if let newlineRange = text.rangeOfCharacter(from: .newlines) {
            let firstLineEnd = text.distance(from: text.startIndex, to: newlineRange.lowerBound)
            let firstLineRange = NSRange(location: 0, length: firstLineEnd)
            
            attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 22, weight: .bold),
                .foregroundColor: UIColor.white
            ], range: firstLineRange)
            
            let remainingRange = NSRange(location: firstLineEnd, length: text.utf16.count - firstLineEnd)
            attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                .foregroundColor: UIColor.white
            ], range: remainingRange)
        } else {
            attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 22, weight: .bold),
                .foregroundColor: UIColor.white
            ], range: fullRange)
        }
        titleTextView.attributedText = attributedString
    }
}

extension DetailsTodoViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
