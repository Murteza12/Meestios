//
//  phoneotpVC.swift
//  meestApp
//
//  Created by Yash on 8/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import CountdownLabel

class phoneotpVC: RootBaseVC {

    
    @IBOutlet weak var txt1:UITextField!
    @IBOutlet weak var txt2:UITextField!
    @IBOutlet weak var txt3:UITextField!
    @IBOutlet weak var txt4:UITextField!
    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var sendBtn:UIButton!
    @IBOutlet weak var countdownLabel:CountdownLabel!
    @IBOutlet weak var errorLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.continueBtn.cornerRadius(radius: 10)
        
        self.sendBtn.cornerRadius(radius: 10)
        
        countdownLabel.font = UIFont.systemFont(ofSize: 11)
        countdownLabel.setCountDownTime(minutes: 59)
        countdownLabel.timeFormat = "ss"
        countdownLabel.countdownAttributedText = CountdownAttributedText(text: "code expires in 00:HERE Seconds", replacement: "HERE")
        countdownLabel.start()
        countdownLabel.textAlignment = .center
        countdownLabel.delegate = self
        
        self.txt1.delegate = self
        self.txt2.delegate = self
        self.txt3.delegate = self
        self.txt4.delegate = self
        self.txt1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txt2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txt3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txt4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        self.txt1.cornerRadius(radius: 10)
        self.txt1.layer.borderColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6).cgColor
        self.txt1.layer.borderWidth = 1
        
        self.txt2.cornerRadius(radius: 10)
        self.txt2.layer.borderColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6).cgColor
        self.txt2.layer.borderWidth = 1
        
        self.txt3.cornerRadius(radius: 10)
        self.txt3.layer.borderColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6).cgColor
        self.txt3.layer.borderWidth = 1
        
        self.txt4.cornerRadius(radius: 10)
        self.txt4.layer.borderColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6).cgColor
        self.txt4.layer.borderWidth = 1
        
        self.errorLbl.isHidden = true
        self.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    @IBAction func submitBtn(_ sender:UIButton) {
        self.loadAnimation()
        let fname = UserDefaults.standard.string(forKey: "fname")
        let lname = UserDefaults.standard.string(forKey: "lname")
        let password = UserDefaults.standard.string(forKey: "password")
        let username = UserDefaults.standard.string(forKey: "username")
        let gender = UserDefaults.standard.string(forKey: "gender")
        let mobile = UserDefaults.standard.string(forKey: "mobile")
        let email = UserDefaults.standard.string(forKey: "email")
        let dob = UserDefaults.standard.string(forKey: "dob")
        let fcm = UserDefaults.standard.string(forKey: "fcm")
        
        if self.txt1.text == "" {
            self.removeAnimation()
            self.txt1.cornerRadius(radius: 10)
            self.txt1.layer.borderColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1).cgColor
            self.txt1.layer.borderWidth = 1
            return
        }
        if self.txt2.text == "" {
            self.removeAnimation()
            self.txt2.cornerRadius(radius: 10)
            self.txt2.layer.borderColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1).cgColor
            self.txt2.layer.borderWidth = 1
            return
        }
        if self.txt3.text == "" {
            self.removeAnimation()
            self.txt3.cornerRadius(radius: 10)
            self.txt3.layer.borderColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1).cgColor
            self.txt3.layer.borderWidth = 1
            return
        }
        if self.txt4.text == "" {
            self.removeAnimation()
            self.txt4.cornerRadius(radius: 10)
            self.txt4.layer.borderColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1).cgColor
            self.txt4.layer.borderWidth = 1
            return
        }
        
        let otp1 = self.txt1.text! + self.txt2.text!
        APIManager.sharedInstance.verifyotp(vc: self, mobile: mobile ?? "", otp: otp1  + self.txt3.text! + self.txt4.text!) { (str) in
            if str == "Otp verified successfully" {
                APIManager.sharedInstance.registerUserNew(vc: self, firstName: fname ?? "", lastName: lname ?? "", password: password ?? "", username: username ?? "" , gender: gender ?? "", mobile: mobile ?? "", email: email ?? "\(fname ?? "")@\(lname ?? "").com", status: true, dob: dob ?? "", fcm: fcm ?? "") { (str) in
                    if str == "success" {
                        self.removeAnimation()
                       // self.clearUserdefaults()
                        self.performSegue(withIdentifier: "proceed", sender: self)
                    }
                }
            } else {
                self.removeAnimation()
                self.txt1.cornerRadius(radius: 10)
                self.txt1.layer.borderColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1).cgColor
                self.txt1.layer.borderWidth = 1
                
                self.txt2.cornerRadius(radius: 10)
                self.txt2.layer.borderColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1).cgColor
                self.txt2.layer.borderWidth = 1
                
                self.txt3.cornerRadius(radius: 10)
                self.txt3.layer.borderColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1).cgColor
                self.txt3.layer.borderWidth = 1
                
                self.txt4.cornerRadius(radius: 10)
                self.txt4.layer.borderColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1).cgColor
                self.txt4.layer.borderWidth = 1
                
                self.errorLbl.isHidden = false
                self.errorLbl.text = "Invalid Code!"
            }
        }
        
    }
    func clearUserdefaults() {
        UserDefaults.standard.removeObject(forKey: "fname")
        UserDefaults.standard.removeObject(forKey: "lname")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "gender")
        UserDefaults.standard.removeObject(forKey: "mobile")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "dob")
        UserDefaults.standard.removeObject(forKey: "fcm")
    }
    @IBAction func resentBtn(_ sender:UIButton) {
        let mobile = UserDefaults.standard.string(forKey: "mobile")
        self.loadAnimation()
        APIManager.sharedInstance.verifyMobilesignup(vc: self, mobile: mobile ?? "" ) { (str) in
            if str == "OTP sent successfully" {
                self.removeAnimation()
                self.countdownLabel.font = UIFont.systemFont(ofSize: 11)
                self.countdownLabel.setCountDownTime(minutes: 59)
                self.countdownLabel.timeFormat = "ss"
                self.countdownLabel.countdownAttributedText = CountdownAttributedText(text: "code expires in HERE Seconds", replacement: "HERE")
                self.countdownLabel.start()
                self.countdownLabel.textAlignment = .center
                self.countdownLabel.delegate = self
            } else if str == "Mobile exists" {
                self.removeAnimation()
            }
        }
    }
}
extension phoneotpVC:LTMorphingLabelDelegate,CountdownLabelDelegate {
    func countdownStarted() {
        self.sendBtn.isEnabled = false
    }
    
    func countdownFinished() {
        self.sendBtn.isEnabled = true
        self.countdownLabel.text = ""
    }
}
extension phoneotpVC:UITextFieldDelegate {
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if (text?.utf16.count)! >= 1{
            switch textField{
            case self.txt1:
                self.txt2.becomeFirstResponder()
            case self.txt2:
                self.txt3.becomeFirstResponder()
            case self.txt3:
                self.txt4.becomeFirstResponder()
            case self.txt4:
                self.txt4.resignFirstResponder()
            default:
                break
            }
        } else {
            
        }
    }
}
