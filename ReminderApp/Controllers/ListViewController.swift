//
//  ListViewController.swift
//  ReminderApp
//
//  Created by Victory Mac Mini on 1/1/20.
//  Copyright © 2020 Victory Mac Mini. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    fileprivate var notificationsList = [NotificationModel]() {
        didSet { tableView.reloadData() }
    }
    
    private lazy var notificationManager = NotificationManager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
        
    // MARK: - Init
    override func loadView() {
        super.loadView()
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view

        self.view.addSubview(tableView)
        updateLayoutConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotifications()
    }
    
    private func updateLayoutConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: - Handlers
    private func loadNotifications() {
        notificationManager.getPendingNotifications { (notifications) in
            self.notificationsList = notifications
        }
    }
    
    fileprivate func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        // 1
        let notification = notificationsList[indexPath.row]
        // 2
        let contextualAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // 3
            self.notificationManager.removeLocalNotificationWithID(notification.id)
            self.notificationsList.remove(at: indexPath.row)
            completion(true)
        }
        // 4
        return contextualAction
    }
}

// MARK: - TableView Delegate Methods

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = notificationsList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
}
