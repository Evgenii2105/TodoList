//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class TodoListViewController: UIViewController {
    
    var presenter: TodoListPresenter?
    private var todos: [TodoListItem] = [] {
        didSet {
            showPlacholderIfNeeded()
        }
    }
    
    private let todoTable: UITableView = {
        let todoTable = UITableView()
        todoTable.backgroundColor = .black
        todoTable.separatorStyle = .singleLine
        todoTable.separatorColor = .gray
        return todoTable
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.textColor = .white
        return statusLabel
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        let addNewTodoButton = UIBarButtonItem(
            image: UIImage(systemName: "bubble.and.pencil"),
            primaryAction: UIAction { [weak self] _ in
                self?.addNewTodo()
            }
        )
        addNewTodoButton.tintColor = .yellow

        let statusBarButton = UIBarButtonItem(customView: statusLabel)
        toolBar.setItems(
            [.flexibleSpace(), statusBarButton, .flexibleSpace(), addNewTodoButton],
            animated: false
        )
        toolBar.isTranslucent = false
        toolBar.barTintColor = .black
        return toolBar
    }()

    
    private let placeHolderLabel: UILabel = {
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = "Нет записей"
        placeHolderLabel.font = .systemFont(ofSize: 24, weight: .bold)
        placeHolderLabel.textColor = .white
        
        return placeHolderLabel
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupAppearance()
        setupNavigationBar()
        createListFilmsTable()
        presenter?.fetchTodos()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
    }
}

private extension TodoListViewController {
    func setupUI() {
        view.addSubview(todoTable)
        view.addSubview(toolBar)
        view.backgroundColor = .black
        todoTable.addSubview(placeHolderLabel)
        todoTable.refreshControl = refreshControl
    }
    
    func setupConstraints() {
        
        todoTable.addConstraint(constraints: [
            todoTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        toolBar.addConstraint(constraints: [
            toolBar.topAnchor.constraint(equalTo: todoTable.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        placeHolderLabel.addConstraint(constraints: [
            placeHolderLabel.centerXAnchor.constraint(equalTo: todoTable.centerXAnchor),
            placeHolderLabel.centerYAnchor.constraint(equalTo: todoTable.centerYAnchor)
        ])
    }
    
    @objc
    func addNewTodo() {
        presenter?.showDetails(state: .create)
    }
    
    @objc
    func pullToRefresh() {
        refreshControl.beginRefreshing()
        presenter?.fetchTodos()
        refreshControl.endRefreshing()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Задачи"
    }
    
    func showPlacholderIfNeeded() {
        placeHolderLabel.isHidden = !todos.isEmpty
    }
    
    func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func updateTasksCount()  {
        statusLabel.text = "\(todos.count) задач"
        self.statusLabel.sizeToFit()
    }
    
    func createListFilmsTable() {
        todoTable.register(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchHeaderView.headerIdentifier)
        todoTable.register(TodoCell.self, forCellReuseIdentifier: TodoCell.celIdentifier)
        todoTable.dataSource = self
        todoTable.delegate = self
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                guard let self else { return nil }
                
                let editAction = UIAction(title: "Редактировать") { _ in
                    self.presenter?.showDetails(state: .update(self.todos[indexPath.row]))
                }
                
                let shareAction = UIAction(title: "Поделиться") { _ in
                    print("Редактировать")
                }
                
                let removeAction = UIAction(title: "Удалить") { _ in
                    self.presenter?.remove(at: indexPath.row)
                }
                return UIMenu(children: [editAction, shareAction, removeAction])
            }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchHeaderView.headerIdentifier) as? SearchHeaderView else { return nil }
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.celIdentifier, for: indexPath) as? TodoCell else { return UITableViewCell() }
        
        let todo = todos[indexPath.row]
        cell.configure(todos: todo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.presenter?.remove(at: indexPath.row)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showDetails(state: .update(todos[indexPath.row]))
    }
}

extension TodoListViewController: TodoListView {
    
    func insertTodos(_ todo: TodoListItem) {
        if let index = self.todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            updateTasksCount()
            todoTable.performBatchUpdates {
                todoTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        } else {
            self.todos.insert(todo, at: self.todos.startIndex)
            updateTasksCount()
            todoTable.performBatchUpdates {
                todoTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func removeTodo(index: Int) {
        todos.remove(at: index)
        updateTasksCount()
        
        todoTable.performBatchUpdates {
            todoTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func showTodos(_ todos: [TodoListItem]) {
        self.todos = todos
        updateTasksCount()
        todoTable.reloadData()
        
        if !todos.isEmpty {
            todoTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

extension TodoListViewController: SearchHeaderViewDelegate {
    
    func searchHeaderView(didUpdateSearchText text: String) {
        presenter?.searchTodo(with: text)
    }
}
