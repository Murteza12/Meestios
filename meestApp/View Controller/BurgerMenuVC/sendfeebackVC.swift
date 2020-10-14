//
//  sendfeebackVC.swift
//  BurgerMenuModule
//
//  Created by Murteza on 11/10/2020.
//  Copyright © 2020 Murteza. All rights reserved.
//

import UIKit

class sendfeebackVC: UIViewController {

    @IBOutlet var myView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
           self.myView.addGestureRecognizer(gesture)
    }
    
   

    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        self.dismiss(animated: false, completion: nil)
    }
  

}
