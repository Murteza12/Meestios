//
//  addPostVC.swift
//  meestApp
//
//  Created by Yash on 8/19/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit


class addPostVC: RootBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "homeVC") as! homeVC
        addChild(controller)
        self.view.addSubview(controller.view)
        controller.view.frame = self.view.bounds
        controller.view.layoutIfNeeded()
        controller.didMove(toParent: self)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "popup", sender: self)
    }
}

