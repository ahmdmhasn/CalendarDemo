//
//  ViewController.swift
//  ReminderApp
//
//  Created by Ahmed M. Hassan on 12/31/19.
//  Copyright © 2019 Victory Mac Mini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dateTimeTextField: UITextField!
    
    // MARK: - Properties
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.addTarget(self, action: #selector(pickerValueChanged(_:)), for: .valueChanged)
        picker.minimumDate = Date(timeIntervalSinceNow: 0)
        return picker
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private var selectedDate: Date? {
        didSet { dateTimeTextField.text = dateFormatter.string(from: selectedDate!) }
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationManager().checkNotificationPermission()
        
        dateTimeTextField.inputView = datePicker
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }

    // MARK: - IB Handlers
    @objc private func pickerValueChanged(_ sender: UIDatePicker) {
        self.selectedDate = sender.date
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        addNotification()
    }
    
    @IBAction func listTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    // MARK: - Handlers
    
    private func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "notify-test"

        let timeInSeconds = Calendar.current.dateComponents([.second], from: Date(timeIntervalSinceNow: 0), to: selectedDate!).second ?? 0
        print(timeInSeconds)
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(timeInSeconds), repeats: false)
        let request = UNNotificationRequest.init(identifier: "notify-test", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
}

