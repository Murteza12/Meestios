//
//  MenuVC.swift
//  BurgerMenuModule
//
//  Created by Murteza on 11/10/2020.
//  Copyright © 2020 Murteza. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet var MAINVIEW: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwiped))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.right
            self.MAINVIEW.addGestureRecognizer(swipeLeft)
        }
        
        @objc func leftSwiped() {
            // handling code
            self.navigateBack()
            self.dismiss(animated: false, completion: nil)
        }
        
    @IBAction func backBtn(_ sender: Any) {
        self.navigateBack()
        self.dismiss(animated: false, completion: nil)
    }
    
        func navigateBack(){
            
            //        dismiss(animated: false)
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: false)
        }
    
    
    @IBAction func activtyBtn(_ sender: Any) {
        self.NextViewController(storybordid: "activityVC")
    }
    
    @IBAction func collection(_ sender: Any) {
        self.NextViewController(storybordid: "CollectionVC")
    }
    
    @IBAction func isightBtn(_ sender: Any) {
        self.NextViewController(storybordid: "InsightVC")
    }
    
    @IBAction func inviteBtn(_ sender: Any) {
        self.Sharelink(message: "Invite to your Friends....!")
    }
    
    @IBAction func settingBtn(_ sender: Any) {
        self.NextViewController(storybordid: "settingVC")
    }
    
    @IBAction func mangeBtn(_ sender: Any) {
        self.NextViewController(storybordid: "ManageVC")
    }
    
    @IBAction func helpBtn(_ sender: Any) {
        self.NextViewController(storybordid: "HelpVC")
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        Alert.showBasic(title: "Logout", message: "It will Not work Now", vc: self)
    }
    
    func Sharelink(message:String)
    {
        
        let activitycontroller = UIActivityViewController(activityItems: ["\(message)"], applicationActivities: nil)
        present(activitycontroller, animated: true, completion:{ () in print("Done🔨")
            
        })
    }

}
