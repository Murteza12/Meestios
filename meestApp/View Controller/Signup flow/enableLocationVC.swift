//
//  enableLocationVC.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class enableLocationVC: RootBaseVC {

    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var view1:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.continueBtn.cornerRadius(radius: 7)
        
        self.view1.cornerRadius(radius: 8)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
        
    }
    @IBAction func submit(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
