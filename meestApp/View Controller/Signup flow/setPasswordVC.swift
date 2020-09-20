//
//  setPasswordVC.swift
//  meestApp
//
//  Created by Yash on 8/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class setPasswordVC: RootBaseVC {

    @IBOutlet weak var txtPass1:TextField!
    @IBOutlet weak var txtPass2:TextField!
    @IBOutlet weak var continueBtn:UIButton!
    
    
    @IBOutlet weak var dividerViewEmail:UIView!
    @IBOutlet weak var dividerViewPassword:UIView!
    
    @IBOutlet weak var mailImg:UIImageView!
    @IBOutlet weak var lockImg:UIImageView!
    @IBOutlet weak var emailView:UIView!
    
    @IBOutlet weak var errorLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.continueBtn.cornerRadius(radius: 10)
        
        self.txtPass1.dividerActiveColor = .clear
        self.txtPass1.dividerNormalColor = .clear
        self.txtPass1.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.txtPass2.dividerActiveColor = .clear
        self.txtPass2.dividerNormalColor = .clear
        self.txtPass2.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.dividerViewEmail.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.dividerViewPassword.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.txtPass1.delegate = self
        self.txtPass2.delegate = self
        
        self.mailImg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.lockImg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.emailView.isHidden = false
        
        
        self.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
        
        self.errorLbl.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "password") != nil {
            self.txtPass1.text = UserDefaults.standard.string(forKey: "password")
            self.txtPass2.text = UserDefaults.standard.string(forKey: "password")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    @IBAction func showPassword(_ sender:UIButton) {
        if self.txtPass1.isSecureTextEntry  {
            self.txtPass1.isSecureTextEntry = false
            
        } else {
            self.txtPass1.isSecureTextEntry = true
           
        }
    }
    @IBAction func showPassword2(_ sender:UIButton) {
        if self.txtPass2.isSecureTextEntry {
            
            self.txtPass2.isSecureTextEntry = false
        } else {
            
            self.txtPass2.isSecureTextEntry = true
        }
    }
    @IBAction func continueBtn(_ sender:UIButton) {
        if self.txtPass1.text == "" {
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Please enter Password"
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            return
        }
        
        if self.txtPass2.text == "" {
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Please enter Confirm Password"
            self.dividerViewPassword.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            return
        }
        
        self.loadAnimation()
        if self.txtPass1.text == self.txtPass2.text {
            if self.txtPass2.text!.count >= 8 {
                self.removeAnimation()
                UserDefaults.standard.set(self.txtPass2.text, forKey: "password")
                self.performSegue(withIdentifier: "proceed", sender: self)
            } else {
                self.removeAnimation()
                self.errorLbl.isHidden = false
                self.errorLbl.text = "Password must contain at least 8 Characters"
                self.dividerViewPassword.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            }
            
        } else {
            self.removeAnimation()
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Password Does Not Match"
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            self.dividerViewPassword.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            
            self.lockImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
        }
    }
}
extension setPasswordVC:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorLbl.isHidden = true
        if textField == self.txtPass1 {
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mailImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == self.txtPass2 {
            self.dividerViewPassword.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.lockImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
