//
//  boostPostDetailVC.swift
//  meestApp
//
//  Created by Yash on 9/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class boostPostDetailVC: RootBaseVC {

    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var objeTxt:TextField!
    @IBOutlet weak var audTxt:TextField!
    @IBOutlet weak var budTxt:TextField!
    @IBOutlet weak var durTxt:TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.audTxt.dividerActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.audTxt.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.objeTxt.dividerActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.objeTxt.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.budTxt.dividerActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.budTxt.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.durTxt.dividerActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.durTxt.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.btn1.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
}
