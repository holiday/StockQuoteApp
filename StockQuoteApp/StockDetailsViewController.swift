//
//  StockDetailsViewController.swift
//  StockQuoteApp
//
//  Created by Darko on 9/8/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import UIKit

class StockDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var stockDetailsTableView: UITableView!
    
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
            cell.valueLabel.text = self.stockDetails[key]
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        return cell
    }
}
