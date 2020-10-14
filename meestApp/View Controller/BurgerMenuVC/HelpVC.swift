//
//  HelpVC.swift
//  BurgerMenuModule
//
//  Created by Murteza on 11/10/2020.
//  Copyright © 2020 Murteza. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func senffeedBtn(_ sender: Any) {
        self.ShowPopUp(stroyboard: "sendfeebackVC")
    }
    
    
    @IBAction func blockListBtn(_ sender: Any) {
        self.NextViewController(storybordid: "blockListVC")
    }
    
    @IBAction func privacyBtn(_ sender: Any) {
        self.NextViewController(storybordid: "PrivacypolicyVC")
    }
    
    @IBAction func abouBtn(_ sender: Any) {
        self.NextViewController(storybordid: "aboutusVC")
    }
    
    @IBAction func faqBtn(_ sender: Any) {
        self.NextViewController(storybordid: "faqVC")
        //self.NextViewController(storybordid: )
    }
    
    
    
}
