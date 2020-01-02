//
//  AppDelegate.swift
//  ReminderApp
//
//  Created by Victory Mac Mini on 12/31/19.
//  Copyright © 2019 Victory Mac Mini. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificationManager().checkNotificationPermission()

        addToolbarToTextFields()
        
        return true
    }

    private func addToolbarToTextFields() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: window?.bounds.width ?? 0, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneWithKeyboard))
        ]
        toolbar.sizeToFit()
        UITextField.appearance().inputAccessoryView = toolbar
    }
    
    @objc func doneWithKeyboard() {
        //Done with number pad
        window?.endEditing(true)
    }

}

