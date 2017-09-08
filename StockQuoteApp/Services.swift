//
//  Services.swift
//  StockQuoteApp
//
//  Created by Darko on 9/7/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Services: NSObject, URLSessionTaskDelegate, NSURLConnectionDelegate {
    
    static let shared = Services()
    
    var alamoFireManager:SessionManager!
    
    override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8 // seconds
        configuration.timeoutIntervalForResource = 10
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func getStockData(symbols:[String], completion: @escaping((JSON?, Error?) -> Void)) {
        
        var symbolString = symbols.joined(separator: "\",\"")
        symbolString = symbolString.quoted().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let urlString:String = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(\(symbolString))&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
        
        self.alamoFireManager.request(urlString).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    completion(JSON(value), nil)
                case .failure(let error):
                    completion(nil, error)
                    return
            }
            
        }
        
    }
    
}

