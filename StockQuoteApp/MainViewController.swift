//
//  ViewController.swift
//  StockQuoteApp
//
//  Created by Darko on 9/7/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MainViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var stockSymboltableView: UITableView!
    let symbols = ["AMD","WMT", "CADUSD=X", "FB", "INTC", "NKE"]
    
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stockSymboltableView.register(UINib(nibName: "StockQuoteTableViewCell", bundle: nil), forCellReuseIdentifier: "StockQuoteTableViewCell")
        
        self.updateStockQuotes { (success) in
            print("Performed update...")
        }
        
        self.stockSymboltableView.delegate = self
        self.stockSymboltableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopTimer()
    }
    
    func setupTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: { (timer) in
            self.updateStockQuotes(completion: { (success) in
                print("Performed update...")
            })
        })
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func updateStockQuotes(completion: ((Bool) -> Void)?) {
        
        print("Updating new data...")
        
        StockDataController.shared.updateStockQuotes(symbols: self.symbols) { (error) in
            if completion != nil {
                completion!(true)
            }
            
            self.stockSymboltableView.reloadData()
            self.stopAnimating()
            
        }
    }
}

extension MainViewController {
    /*
     *   TableView delegate methods
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StockDataController.shared.stockQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.stockSymboltableView.dequeueReusableCell(withIdentifier: "StockQuoteTableViewCell", for: indexPath) as! StockQuoteTableViewCell
        
        DispatchQueue.main.async {
            cell.stockSymbolLabel.text = StockDataController.shared.stockQuotes[indexPath.row].symbol
            cell.stockCompanyNameLabel.text = StockDataController.shared.stockQuotes[indexPath.row].name
            
            cell.stockPriceLabel.alpha = 0
            cell.stockPriceLabel.text = StockDataController.shared.stockQuotes[indexPath.row].lastTradePriceOnly
            
            UIView.animate(withDuration: 0.3, animations: { 
                cell.stockPriceLabel.alpha = 1
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selected row
        print("Hello from \(indexPath.row)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sdvc = storyboard.instantiateViewController(withIdentifier: "StockDetailsViewController") as! StockDetailsViewController
        sdvc.stockIndexPath = indexPath
        
        self.navigationController?.pushViewController(sdvc, animated: true)
        
    }
}

