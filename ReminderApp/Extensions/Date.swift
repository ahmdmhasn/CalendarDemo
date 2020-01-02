//
//  Date.swift
//  ReminderApp
//
//  Created by Victory Mac Mini on 1/2/20.
//  Copyright © 2020 Victory Mac Mini. All rights reserved.
//

import Foundation

extension Date {
    
    func subtract(seconds: Int) -> Date? {
        return Calendar.current.date(byAdding: .second, value: -(seconds), to: self)
    }

}
