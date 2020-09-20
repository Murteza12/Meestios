//
//  otpVC.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import KWVerificationCodeView
import CountdownLabel

class otpVC: RootBaseVC {

   
    var mobile = ""
    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var sendBtn:UIButton!
    @IBOutlet weak var countdownLabel:CountdownLabel!
    @IBOutlet weak var txt1:UITextField!
    @IBOutlet weak var txt2:UITextField!
    @IBOutlet weak var txt3:UITextField!
    @IBOutlet weak var txt4:UITextField!
    @IBOutlet weak var errorLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
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
    @IBAction func submitBtn(_ sender:UIButton) {
        guard let mobile = UserDefaults.standard.string(forKey: "mobile") else { return }
        self.loadAnimation()
        let otp1 = self.txt1.text! + self.txt2.text!
        APIManager.sharedInstance.verifyOTPForgotPass(vc: self, mobile:"+91" + mobile, otp: otp1 + self.txt3.text! + self.txt4.text!) { (str) in
            if str ==  "Otp mismatch" {
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
            } else if str == "Otp verified successfully" {
                self.performSegue(withIdentifier: "proceed", sender: self)
            }
        }
        
    }

    @IBAction func resentBtn(_ sender:UIButton) {
        guard let mobile = UserDefaults.standard.string(forKey: "mobile") else { return }
        APIManager.sharedInstance.verifyEmail(vc: self, email: "+91" + mobile) { (str) in
            if str == "Otp sent" {
                self.countdownLabel.font = UIFont.systemFont(ofSize: 11)
                self.countdownLabel.setCountDownTime(minutes: 59)
                self.countdownLabel.timeFormat = "ss"
                self.countdownLabel.countdownAttributedText = CountdownAttributedText(text: "code expires in HERE Seconds", replacement: "HERE")
                self.countdownLabel.start()
                self.countdownLabel.textAlignment = .center
                self.countdownLabel.delegate = self
            } else if str == "Mobile does not exist" {
                
            }
        }
    }
}
extension otpVC:LTMorphingLabelDelegate {
    
}
extension otpVC:UITextFieldDelegate {
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
