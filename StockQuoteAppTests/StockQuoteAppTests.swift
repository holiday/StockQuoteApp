//
//  StockQuoteAppTests.swift
//  StockQuoteAppTests
//
//  Created by Darko on 9/7/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import StockQuoteApp

class StockQuoteAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStockQuoteModel() {
        var jsonString = "{\"quote\":{\"symbol\":\"AMD\",\"LastTradePriceOnly\":\"12.63\",\"Name\":\"Advanced Micro Devices, Inc.\",\"Ask\":\"12.67\",\"AverageDailyVolume\":\"75936704\",\"Bid\":\"12.65\"}}"
        let json = JSON.parse(jsonString)
        let quoteData = json["quote"]
        
        let quote = StockQuote(data: quoteData)
        
        XCTAssertEqual(quote.getValueForKey(key: "symbol")!, "AMD", "StockQuote model did not find symbol value")
        XCTAssertEqual(quote.getValueForKey(key: "Ask")!, "12.67", "StockQuote model did not find Ask value")
        XCTAssertEqual(quote.getValueForKey(key: "AverageDailyVolume")!, "75936704", "StockQuote model did not find AverageDailyVolume value")
        XCTAssertEqual(quote.getValueForKey(key: "Bid")!, "12.65", "StockQuote model did not find Bid value")
    }
    
}
