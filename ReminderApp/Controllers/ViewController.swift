//
//  ViewController.swift
//  ReminderApp
//
//  Created by Ahmed M. Hassan on 12/31/19.
//  Copyright © 2019 Victory Mac Mini. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dateTimeTextField: UITextField!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(pickerValueChanged(_:)), for: .valueChanged)
//        picker.minimumDate = Date()
        return picker
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    private var selectedDate: Date?
    
    private var selectedTime: Date? {
        didSet { dateTimeTextField.text = timeFormatter.string(from: selectedTime!) }
    }
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    private lazy var notificationManager = NotificationManager()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateTimeTextField.inputView = datePicker
        
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        
        // Calendar
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.select(Date())
//        self.view.addGestureRecognizer(self.scopeGesture)
        self.calendar.scope = .month
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.allowsSelection = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    deinit {
        print(#function)
    }
    
    // MARK: - IB Handlers
    @objc private func pickerValueChanged(_ sender: UIDatePicker) {
        self.selectedTime = sender.date
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        validateInputs()
    }
    
    @IBAction func listTapped(_ sender: UIBarButtonItem) {
        let listVC = ListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    // MARK: - Handlers
    
    private func validateInputs() {
        guard let sDate = selectedDate, let sTime = selectedTime else {
            SVProgressHUD.showInfo(withStatus: "Date & Time must be selected")
            return
        }
        
        guard let date = combineDateFrom(date: sDate, time: sTime),
            let title = nameTextField.text, let location = locationTextField.text else {
                SVProgressHUD.showInfo(withStatus: "Data are not valid")
                return
        }
        
        notificationManager.checkNotificationPermission(authorized: {
            // Notifications permission authorized
            let notification = NotificationModel(id: UUID().uuidString, title: title, body: location, date: date)
            self.addNotification(notification)
        })
    }
    
    private func addNotification(_ notification: NotificationModel) {
        // Add notification using or Notifications Manager
        let error = notificationManager.addNotification(notification)
        // Check for success or failure
        DispatchQueue.main.async {
            if error == nil  {
                let date = self.dateFormatter.string(from: notification.date)
                SVProgressHUD.showSuccess(withStatus: "Added on \(date)")
                self.nameTextField.text = ""
                self.locationTextField.text = ""
                self.dateTimeTextField.text = ""
                self.calendar.select(Date())
            }
            else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    private func combineDateFrom(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = timeComponents.second
        
        return calendar.date(from: components)
    }
    
}

// MARK:- UIGestureRecognizerDelegate

extension ViewController: UIGestureRecognizerDelegate {
        
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        let shouldBegin = self.view.contentOffset.y <= -self.view.contentInset.top
//        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                return false
            }
//        }
//        return shouldBegin
    }
    
}

// MARK: - FSCalendar Delegate
extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

}
