//
//  forgotPassVC.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class forgotPassVC: RootBaseVC {

    @IBOutlet weak var txtEmail:TextField!
    
    @IBOutlet weak var continueBtn:UIButton!
    
    
    @IBOutlet weak var dividerViewEmail:UIView!
    
    
    @IBOutlet weak var mailImg:UIImageView!
    
    @IBOutlet weak var emailView:UIView!
    
    @IBOutlet weak var errorLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
        self.continueBtn.cornerRadius(radius: 10)
        
        self.txtEmail.dividerActiveColor = .clear
        self.txtEmail.dividerNormalColor = .clear
        self.txtEmail.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        
        
        self.dividerViewEmail.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        
        self.txtEmail.delegate = self
        
        self.mailImg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.emailView.isHidden = false
        self.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
        
        self.errorLbl.isHidden = true
    }
    @IBAction func contnueBtn(_ sender:UIButton) {
        if self.txtEmail.text == "" {
            self.errorLbl.isHidden = false
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            self.errorLbl.text = "Please Enter Mobile Number"
            return
            
        } else if self.txtEmail.text!.count > 10 || self.txtEmail.text!.count < 10 {
            self.errorLbl.isHidden = false
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            self.errorLbl.text = "Please Enter Correct Mobile Number"
            return
        }
        APIManager.sharedInstance.forgotpassword(vc: self, email: "+91" + self.txtEmail.text!) { (str) in
            if str == "Otp sent" {
                self.emailView.isHidden = true
                if !self.errorLbl.isHidden {
                    self.errorLbl.isHidden = true
                }
                self.performSegue(withIdentifier: "proceed", sender: self)
            } else if str == "Mobile does not exist" {
                self.errorLbl.isHidden = false
                self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                self.errorLbl.text = str
                self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            }
        }
    }
    
    @IBAction func back(_ sender:UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
extension forgotPassVC:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtEmail {
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mailImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
