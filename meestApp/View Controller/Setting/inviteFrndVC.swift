//
//  inviteFrndVC.swift
//  meestApp
//
//  Created by Yash on 9/9/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class inviteFrndVC: RootBaseVC {

    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var btn1:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn1.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
        self.btn1.cornerRadius(radius: 10)
        self.lbl1.cornerRadius(radius: 8)
    }
}
