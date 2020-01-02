//
//  UIViewController+Ext.swift
//  ReminderApp
//
//  Created by Victory Mac Mini on 1/2/20.
//  Copyright © 2020 Victory Mac Mini. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func bindToKeyboard(withTapGesture: Bool = false) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if withTapGesture {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
            self.view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func keyboardWillChange(_ notification: Notification) {
        
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let cutFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let targetFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let deltaY = ((targetFrame?.cgRectValue.origin.y)! - (cutFrame?.cgRectValue.origin.y)!)
        
        UIView.animateKeyframes(withDuration: duration!, delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            
            self.view.frame.size.height += deltaY
            
        }, completion: nil)
    }
    
    @objc private func handleScreenTap (sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
}
