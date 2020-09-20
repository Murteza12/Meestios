//
//  campaignPayVC.swift
//  meestApp
//
//  Created by Yash on 9/9/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class campaignPayVC: RootBaseVC {

    @IBOutlet weak var payBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.payBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
}
