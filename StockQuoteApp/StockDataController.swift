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
                        
                        _ = self.addQuote(quote: quote)
                    }
                }else if let quote = json?["query"]["results"]["quote"].dictionary {
                    //parse one quote
                    
                    _ = self.addQuote(quote: JSON(quote))
                }
                
                completion(true)
                return
                
            }
            
            completion(false)
        }
    }
    
    func updateStockQuote(symbol:String, completion: @escaping ((StockQuote?) -> Void)) {
        Services.shared.getStockData(symbols: [symbol]) { (json, error) in
            
            if json != nil {
                
                //parse one quote
                if let quote = json?["query"]["results"]["quote"].dictionary {
                    _ = self.removeQuote(symbol: symbol)
                    let quoteObj = self.addQuote(quote: JSON(quote))
                    completion(quoteObj)
                }
                
                completion(nil)
                return
            }
            
            completion(nil)
            
        }
    }
    
    func getQuote(symbol:String) -> StockQuote? {
        for quote in self.stockQuotes {
            if let quoteSymbol = quote.symbol {
                if quoteSymbol == symbol {
                    return quote
                }
            }
        }
        
        return nil
    }
    
    func removeQuote(symbol:String) -> StockQuote? {
        var i = 0
        for quote in self.stockQuotes {
            if let quoteSymbol = quote.symbol {
                if symbol == quoteSymbol {
                    return self.stockQuotes.remove(at: i)
                }
            }
            i = i + 1
        }
        
        return nil
    }
    
    func addQuote(quote:JSON) -> StockQuote {
        
        let quoteObj = StockQuote(data: quote)
        self.stockQuotes.append(quoteObj)
        
        return quoteObj
        
    }
    
}
