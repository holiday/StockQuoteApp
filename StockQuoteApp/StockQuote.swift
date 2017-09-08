//
//  StockQuote.swift
//  StockQuoteApp
//
//  Created by Darko on 9/7/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import Foundation
import SwiftyJSON

struct StockQuote {
    
    var keyValue:[String:String?] = [String:String?]()
    
    var symbol:String?
    var name:String?
    var lastTradePriceOnly:String?
    var prevClose:String?
    var rawData:JSON?
    
    init(data:JSON) {
        
        guard let symbol = data["symbol"].string else {
            print("Skipping, no symbol detected")
            return
        }

        guard let name = data["Name"].string else {
            print("Skipping, no name detected")
            return
        }

        guard let lastTradePrice = data["LastTradePriceOnly"].string else{
            print("Skipping, no last trade price detected")
            return
        }
        
        self.symbol = symbol
        self.name = name
        self.lastTradePriceOnly = lastTradePrice
        self.rawData = data
    }
    
    func getValueForKey(key:String) -> String? {
        if let value = self.rawData?[key].string {
            return value
        }
        
        return nil
    }
    
}
