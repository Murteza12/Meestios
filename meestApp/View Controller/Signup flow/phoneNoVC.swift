//
//  phoneNoVC.swift
//  meestApp
//
//  Created by Yash on 8/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class phoneNoVC: RootBaseVC {

    @IBOutlet weak var txtEmail:TextField!
    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var dividerViewEmail:UIView!
    @IBOutlet weak var mailImg:UIImageView!
    @IBOutlet weak var emailView:UIView!
    @IBOutlet weak var errorLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        self.txtEmail.keyboardType = .numberPad
        
        self.txtEmail.text = "+91"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "mobile") != nil {
            
            
            self.txtEmail.text?.append(contentsOf: (UserDefaults.standard.string(forKey: "mobile")?.replacingOccurrences(of: "+91", with: ""))!)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    @IBAction func contnueBtn(_ sender:UIButton) {
        self.loadAnimation()
        if self.txtEmail.text == "" {
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Please enter Mobile Number"
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            self.removeAnimation()
            return
        } else if self.txtEmail.text!.count < 10 {
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Please enter Correct Mobile Number"
            self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            self.removeAnimation()
            return
        }
        APIManager.sharedInstance.verifyMobilesignup(vc: self, mobile: self.txtEmail.text! ) { (str) in
            if str == "OTP sent successfully" {
                UserDefaults.standard.set(self.txtEmail.text!, forKey: "mobile")
                self.removeAnimation()
                self.performSegue(withIdentifier: "proceed", sender: self)
            } else if str == "Mobile number exists" {
                self.removeAnimation()
                self.errorLbl.isHidden = false
                self.dividerViewEmail.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                self.errorLbl.text = str
                self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            }
        }
    }
}
extension phoneNoVC:TextFieldDelegate {
    
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
