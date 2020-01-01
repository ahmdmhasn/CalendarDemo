//
//  NotificationsManager.swift
//
//  Created by Ahmed M. Hassan on 10/10/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import UserNotifications

struct NotificationManager {
    
    enum NotificationError: String, Error {
        case dateNotValid = "Date is not valid."
    }
    
    typealias OKCompletionHandler = (UIAlertAction)->()
    typealias AuthorizedCompletionHandler = ()->()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func checkNotificationPermission(authorized: AuthorizedCompletionHandler? = nil, okAction: OKCompletionHandler? = nil) {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Already authorized
                if let authorized = authorized {
                    DispatchQueue.main.async {
                        authorized()
                    }
                }
            }
            else {
                // Either denied or notDetermined
                self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) {
                    (granted, error) in
                    // add your own
//                    UNUserNotificationCenter.current().delegate = self
                    self.showNotificationsAlert(completion: okAction)
                }
            }
        }
    }
    
    private func showNotificationsAlert(completion: OKCompletionHandler?) {
        let alertController = UIAlertController(title: "Attention", message: "We need to enable notifications to be able to receive notifications.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Add/ Remove Notification
    
    func addNotification(_ notification: NotificationModel) -> Error? {
        // Prepare content
        let content = UNMutableNotificationContent()
//        content.title = NSString.localizedUserNotificationString(forKey: notification.title, arguments: nil)
//        content.body = NSString.localizedUserNotificationString(forKey: notification.body, arguments: nil)
        content.title = notification.title
        content.body = notification.body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = notification.id
        // add notification time
        guard let timeInSeconds = Calendar.current.dateComponents([.second], from: Date(), to: notification.date).second, timeInSeconds > 0 else {
            return NotificationError.dateNotValid
        }
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(timeInSeconds), repeats: false)
        let request = UNNotificationRequest.init(identifier: notification.id, content: content, trigger: trigger)
        notificationCenter.add(request)
        return nil
    }
    
    func getPendingNotifications(completion: @escaping ([NotificationModel])->()) {
        return notificationCenter.getPendingNotificationRequests { (requestsList) in
            let content = requestsList.map{NotificationModel(id: $0.identifier,
                                                             title: $0.content.title, body: $0.content.body,
                                                             date: Date())}
            DispatchQueue.main.async {
                completion(content)
            }
        }
    }
    
    func removeLocalNotificationWithID(_ id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
}
