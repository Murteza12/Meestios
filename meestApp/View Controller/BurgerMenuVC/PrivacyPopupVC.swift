//
//  PrivacyPopupVC.swift
//  BurgerMenuModule
//
//  Created by Murteza on 10/10/2020.
//  Copyright © 2020 Murteza. All rights reserved.
//

import UIKit

class PrivacyPopupVC: UIViewController {
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var checkBoxOutlet:UIButton!{
        didSet{
            checkBoxOutlet.setImage(UIImage(named:"unchecked"), for: .normal)
            checkBoxOutlet.setImage(UIImage(named:"checked"), for: .selected)
        }
    }

    
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
    @IBAction func checkBox(_ sender: UIButton) {
        sender.checkboxAnimation {
                   print("I'm done")
                   //here you can also track the Checked, UnChecked state with sender.isSelected
                   print(sender.isSelected)
                   
               }
    }
    
  

}



extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}
