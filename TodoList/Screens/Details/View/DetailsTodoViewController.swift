//
//  DetailsTodoViewController.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class DetailsTodoViewController: UIViewController {
    
    var presenter: DetailsTodoPresenter?
    private lazy var debounce = Debouncer(interval: 0.5)
    private var timer: Timer?
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 22, weight: .bold)
        textView.backgroundColor = .black
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        tapGesture()
        presenter?.startTodoItem()
    }
}

extension DetailsTodoViewController: DetailsTodoView {
    
    func configure(with state: TodoListItemState) {
        guard case let .update(item) = state else { return }
        
        let fullText = "\(item.title)\n\(item.subtitle)"
        updateTextStyles(text: fullText)
    }
}

extension DetailsTodoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextStyles(text: textView.text)
        debounce.debonce { [weak self] in
            guard let self = self else { return }
           
            self.presenter?.saveTodo(titleTextView.text)
        }
    }
}

extension DetailsTodoViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

private extension DetailsTodoViewController {
    
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleTextView)
        setupTextViews()
        setupNavigationBar()
    }
    
    func setupConstraints() {
        titleTextView.addConstraint(constraints: [
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNavigationBar() {
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
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupTextViews() {
        titleTextView.delegate = self
    }
    
    func updateTextStyles(text: String) {
        guard !text.isEmpty else { return }
        
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
