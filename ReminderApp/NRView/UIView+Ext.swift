//
//  NoResultView+Ext.swift
//  ExampleApp
//
//  Created by Ahmed M. Hassan on 10/28/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

extension UIView {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }

    /**
     For NRView: Add custom shodow for views
     */
    func shadow() {
        layer.shadowRadius = 2.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }
}
