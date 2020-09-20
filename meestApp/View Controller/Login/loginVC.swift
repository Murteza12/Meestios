//
//  loginVC.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material


class loginVC: RootBaseVC {

    @IBOutlet weak var txtEmail:TextField!
    @IBOutlet weak var txtPassword:TextField!
    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var forgotBtn:UIButton!
    
    @IBOutlet weak var dividerViewEmail:UIView!
    @IBOutlet weak var dividerViewPassword:UIView!
    
    @IBOutlet weak var mailImg:UIImageView!
    @IBOutlet weak var lockImg:UIImageView!
    @IBOutlet weak var emailView:UIView!
    @IBOutlet weak var passwordView:UIView!
    @IBOutlet weak var errorLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.continueBtn.cornerRadius(radius: 10)
        
        self.txtEmail.dividerActiveColor = .clear
        self.txtEmail.dividerNormalColor = .clear
        self.txtEmail.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.txtPassword.dividerActiveColor = .clear
        self.txtPassword.dividerNormalColor = .clear
        self.txtPassword.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.dividerViewEmail.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.dividerViewPassword.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        
        self.mailImg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.lockImg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.emailView.isHidden = false
        self.passwordView.isHidden = true
        
        self.forgotBtn.setTitleColor(UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.8), for: .normal)
        
        self.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
        
        self.errorLbl.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    @IBAction func contnueBtn(_ sender:UIButton) {
        if self.continueBtn.titleLabel?.text == "Continue" {
            if (self.txtEmail.text?.contains("@"))! {
                APIManager.sharedInstance.verifyEmail(vc: self, email: self.txtEmail.text ?? "") { (str) in
                    if str == "Email exists" {
                        self.emailView.isHidden = true
                        self.passwordView.isHidden = false
                        if !self.errorLbl.isHidden {
                            self.errorLbl.isHidden = true
                        }
                        self.continueBtn.setTitle("Login", for: .normal)
                    } else if str == "Email does not exist" {
                        self.errorLbl.isHidden = false
                        self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                        self.errorLbl.text = "Email doesn’t exist"
                        self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                    }
                }
                
            } else {
                if self.txtEmail.text == "" {
                    self.showAlert(with: "Message", message: "Mobile no. field cannot be blank")
                    return
                }
                APIManager.sharedInstance.verifyMobile(vc: self, mobile:( "+91" + self.txtEmail.text! )) { (str) in
                    if str == "Mobile number exists" {
                        self.emailView.isHidden = true
                        self.passwordView.isHidden = false
                        if !self.errorLbl.isHidden {
                            self.errorLbl.isHidden = true
                        }
                        UserDefaults.standard.set(self.txtEmail.text!, forKey: "mobile")
                        self.continueBtn.setTitle("Login", for: .normal)
                    } else if str == "Mobile does not exist" {
                        self.errorLbl.isHidden = false
                        self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                        self.errorLbl.text = "Mobile doesn’t exist"
                        self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                    }
                }
            }
        } else {
            if self.txtPassword.text == "" {
                self.errorLbl.isHidden = false
                self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                self.errorLbl.text = "Please Enter Password"
                self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                return
            }
            APIManager.sharedInstance.login(vc: self, username: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "") { (str) in
                if str == "success" {
                    self.performSegue(withIdentifier: "login", sender: self)
                } else {
                    self.errorLbl.isHidden = false
                    self.dividerViewPassword.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                    self.errorLbl.text = str
                    self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                }
            }
        }
    }
    
    @IBAction func showPassword(_ sender:UIButton) {
        if self.txtPassword.isSecureTextEntry  {
            self.txtPassword.isSecureTextEntry = false
            
        } else {
            self.txtPassword.isSecureTextEntry = true
            
        }
    }
}
extension loginVC:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtEmail {
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mailImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            if !self.errorLbl.isHidden {
                self.errorLbl.isHidden = true
            }
        } else if textField == self.txtPassword {
            self.dividerViewPassword.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.lockImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            if !self.errorLbl.isHidden {
                self.errorLbl.isHidden = true
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
