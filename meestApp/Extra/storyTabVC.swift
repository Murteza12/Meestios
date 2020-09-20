//
//  storyTabVC.swift
//  meestApp
//
//  Created by Yash on 9/4/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class storyTabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -16)
    }

}
