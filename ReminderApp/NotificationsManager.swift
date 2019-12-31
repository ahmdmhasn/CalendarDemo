//
//  NotificationsManager.swift
//
//  Created by Ahmed M. Hassan on 10/10/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import UserNotifications

struct NotificationManager {
    
    typealias OKCompletionHandler = (UIAlertAction)->()
    typealias AuthorizedCompletionHandler = ()->()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func checkNotificationPermission(authorized: AuthorizedCompletionHandler? = nil, okAction: OKCompletionHandler? = nil) {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Already authorized
                if let authorized = authorized { authorized() }
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
    
    func addNotification(id: String, titleLocalizedKey: String, bodyLocalizedKey: String, date: Date) {
        // Prepare content
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: titleLocalizedKey, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: bodyLocalizedKey, arguments: nil)
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = id
        // add notification time
        guard let timeInSeconds = Calendar.current.dateComponents([.second], from: Date(), to: date).second, timeInSeconds > 0 else {
            print("Time must be larger than 0")
            return
        }
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(timeInSeconds), repeats: false)
        let request = UNNotificationRequest.init(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
}
