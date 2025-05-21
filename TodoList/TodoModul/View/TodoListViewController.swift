//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

final class TodoListViewController: UIViewController {
  
    var presenter: TodoListPresenter?
    private var todos: [TodoListItem] = []
    
    private let todoTable: UITableView = {
        let todoTable = UITableView()
        todoTable.backgroundColor = .black
        todoTable.translatesAutoresizingMaskIntoConstraints = false
        todoTable.separatorStyle = .singleLine
        todoTable.separatorColor = .gray
        return todoTable
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
        toolBar.setItems([.flexibleSpace(), addNewTodoButton], animated: false)
        toolBar.isTranslucent = false
        toolBar.barTintColor = .black
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
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
    
    private func setupUI() {
        view.addSubview(todoTable)
        view.addSubview(toolBar)
        view.backgroundColor = .black
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            todoTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            toolBar.topAnchor.constraint(equalTo: todoTable.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    private func addNewTodo() {
        let newTodo = TodoListItem(
            id: 0,
            userId: 1,
            title: "",
            subtitle: "",
            isCompleted: false
        )
        presenter?.didTapAddNewTodo(newTodo)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Задачи"
    }
    
    private func setupAppearance() {
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
    
    private func createListFilmsTable() {
        todoTable.register(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchHeaderView.headerIdentifier)
        todoTable.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.celIdentifire)
        todoTable.dataSource = self
        todoTable.delegate = self
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchHeaderView.headerIdentifier)  else { return nil }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.celIdentifire, for: indexPath) as? CustomTableCell else { return UITableViewCell() }
        
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
}

extension TodoListViewController: TodoListView {
    
    func removeTodo(index: Int) {
        todos.remove(at: index)
        
        todoTable.performBatchUpdates {
            todoTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }

    func showTodos(_ todos: [TodoListItem]) {
        self.todos = todos
        todoTable.reloadData() // ИСПРАВИТЬ
    }
}
