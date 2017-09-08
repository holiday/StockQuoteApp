//
//  BaseViewController.swift
//  StockQuoteApp
//
//  Created by Darko on 9/8/17.
//  Copyright © 2017 RocketFuse. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable  {

    override func viewDidLoad() {
        super.viewDidLoad()

        NVActivityIndicatorView.DEFAULT_TYPE = .ballTrianglePath
        
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor(hexaString: "#4BAE44", alpha: 1.0)
    }

}
