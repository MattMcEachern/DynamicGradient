//
//  Extensions.swift
//  DynamicGradient
//
//  Created by Matt McEachern on 12/23/15.
//  Copyright © 2015 Matt McEachern. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    // a convenience initializer that accepts a hex values
    convenience init(hexValue: Int){
        self.init(
            red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}