//
//  StockDataController.swift
//  StockQuoteApp
//
//  Created by Darko on 9/8/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import UIKit
import SwiftyJSON

class StockDataController: NSObject {
    
    static let shared = StockDataController()
    
    var stockQuotes:[StockQuote] = [StockQuote]()
    
    func resetData() {
        self.stockQuotes = [StockQuote]()
    }
    
    func updateStockQuotes(symbols:[String], completion: @escaping ((Bool?) -> Void)) {
        
        self.resetData()
        
        Services.shared.getStockData(symbols: symbols) { (json, error) in
            
            if json != nil {
                
                if let quotes = json?["query"]["results"]["quote"].array {
                    //loop over multiple quotes
                    for quote in quotes {
                        
                        self.addQuote(quote: quote)
                    }
                }else if let quote = json?["query"]["results"]["quote"].dictionary {
                    //parse one quote
                    
                    self.addQuote(quote: JSON(quote))
                }
                
                completion(true)
                return

                
            }
            
            completion(false)
            
        }
    }
    
    func addQuote(quote:JSON) {
        
        let quoteObj = StockQuote(data: quote)
        self.stockQuotes.append(quoteObj)
        
    }
    
}
