//
//  NotificationsManager.swift
//  iRead
//
//  Created by Ahmed M. Hassan on 10/10/19.
//  Copyright © 2019 VictoryLink. All rights reserved.
//

import UIKit
import UserNotifications

struct NotificationManager {
    
    typealias OKCompletionHandler = (UIAlertAction)->()
    typealias AuthorizedCompletionHandler = ()->()
    
    func checkNotificationPermission(authorized: AuthorizedCompletionHandler? = nil, okAction: OKCompletionHandler? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Already authorized
                if let authorized = authorized { authorized() }
            }
            else {
                // Either denied or notDetermined
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
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
    
}
