//
//  UIColor+Extension.swift
//  StockQuoteApp
//
//  Created by Darko on 9/8/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.characters)
        self.init(red:   CGFloat(strtoul(String(chars[1...2]),nil,16))/255,
                  green: CGFloat(strtoul(String(chars[3...4]),nil,16))/255,
                  blue:  CGFloat(strtoul(String(chars[5...6]),nil,16))/255,
                  alpha: alpha)
    }
    
    static func random() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
