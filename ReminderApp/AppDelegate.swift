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

        return true
    }


}

