//
//  String+Extension.swift
//  StockQuoteApp
//
//  Created by Darko on 9/8/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import Foundation


extension String {
    
    func quoted() -> String  {
        return "\"\(self)\""
    }
    
}
