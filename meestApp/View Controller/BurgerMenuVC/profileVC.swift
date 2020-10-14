//
//  profileVC.swift
//  BurgerMenuModule
//
//  Created by Murteza on 11/10/2020.
//  Copyright © 2020 Murteza. All rights reserved.
//

import UIKit

class profileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func menuBtn(_ sender: Any) {
        self.showMenu()
    }
    func showMenu(){
           let myMenu = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC")
        myMenu?.hidesBottomBarWhenPushed = true
           let transition = CATransition()
           transition.duration = 0.4
           transition.type = CATransitionType.push
           transition.subtype = CATransitionSubtype.fromRight
           transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           view.window!.layer.add(transition, forKey: kCATransition)
           self.navigationController?.view?.layer.add(transition, forKey: nil)
           // self.navigationController?.pushViewController(myMenu, animated: false)
        myMenu?.modalPresentationStyle = .overCurrentContext
        present(myMenu!, animated: false, completion: nil)
          
       }
    
}
