//
//  StockDetailsViewController.swift
//  StockQuoteApp
//
//  Created by Darko on 9/8/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import UIKit

class StockDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var stockDetailsTableView: UITableView!
    
    var timer:Timer?
    var stockIndexPath:IndexPath!
    var stockQuote:StockQuote?
    
    var stockDetails:[String:String] = [String:String]()
    let dataToDisplay = ["Open", "PreviousClose", "YearLow", "YearHigh", "MarketCapitalization"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stockIndexPath != nil {
            self.stockQuote = StockDataController.shared.stockQuotes[stockIndexPath.row]
        }
        
        self.stockDetailsTableView.register(UINib(nibName: "StockDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "StockDetailsTableViewCell")
        
        self.generateDataToDisplay()
        
        self.stockDetailsTableView.delegate = self
        self.stockDetailsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            if let symbol = self.stockQuote?.symbol {
                self.stockSymbolLabel.text = symbol
            }
            
            if let price = self.stockQuote?.lastTradePriceOnly {
                self.stockPriceLabel.text = price
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            print("Updating stock quote \(String(describing: self.stockQuote?.symbol))")
            self.updateStockQuote()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopTimer()
    }
    
    func stopTimer() {
        print("Stopping Stock Details Timer...")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func updateStockQuote() {
        if let symbol = self.stockQuote?.symbol {
            StockDataController.shared.updateStockQuote(symbol: symbol, completion: { (stockQuote) in
                
                if stockQuote != nil {
                    self.stockQuote = stockQuote
                    self.generateDataToDisplay()
                    self.stockDetailsTableView.reloadData()
                    
                    //Update the stock price as well
                    DispatchQueue.main.async {
                        if let price = self.stockQuote?.lastTradePriceOnly {
                            self.stockPriceLabel.text = price
                        }
                    }
                }
                
            })
        }
        
    }
    
    func generateDataToDisplay() {
        
        for key in self.dataToDisplay {
            if let value = self.stockQuote?.getValueForKey(key: key) {
                self.stockDetails[key] = value
            }
        }
    }

}

extension StockDetailsViewController {
    /*
     *   TableView delegate methods
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.stockDetailsTableView.dequeueReusableCell(withIdentifier: "StockDetailsTableViewCell", for: indexPath) as! StockDetailsTableViewCell
        
        let key:String = Array(self.stockDetails.keys)[indexPath.row]
        
        DispatchQueue.main.async {
            cell.titleLabel.text = key
            
            cell.valueLabel.alpha = 0
            cell.valueLabel.text = self.stockDetails[key]
            
            UIView.animate(withDuration: 0.3, animations: { 
                cell.valueLabel.alpha = 1
            })
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        return cell
    }
}
