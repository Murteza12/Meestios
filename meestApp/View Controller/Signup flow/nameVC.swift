//
//  nameVC.swift
//  meestApp
//
//  Created by Yash on 8/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class nameVC: RootBaseVC {

    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    @IBOutlet weak var txtFName:TextField!
    @IBOutlet weak var txtLName:TextField!
    
    @IBOutlet weak var continueBtn:UIButton!
    
    
    @IBOutlet weak var dividerViewFname:UIView!
    @IBOutlet weak var dividerViewLname:UIView!
    
    
    @IBOutlet weak var mailImg:UIImageView!
    @IBOutlet weak var mail2Img:UIImageView!
    
    @IBOutlet weak var fnameView:UIView!
    @IBOutlet weak var lnameView:UIView!
    
    @IBOutlet weak var errorLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.continueBtn.cornerRadius(radius: 10)
        
        self.txtFName.dividerActiveColor = .clear
        self.txtFName.dividerNormalColor = .clear
        self.txtFName.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.txtLName.dividerActiveColor = .clear
        self.txtLName.dividerNormalColor = .clear
        self.txtLName.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.dividerViewFname.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.dividerViewLname.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.txtFName.delegate = self
        self.txtLName.delegate = self
        
        self.mailImg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.mail2Img.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.fnameView.isHidden = false
        self.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
        
        self.errorLbl.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "fname") != nil {
            self.txtFName.text = UserDefaults.standard.string(forKey: "fname")
        }
        if UserDefaults.standard.string(forKey: "lname") != nil {
            self.txtLName.text = UserDefaults.standard.string(forKey: "lname")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    @IBAction func submitData(_ sender:UIButton) {
        self.loadAnimation()
        if self.txtFName.text == "" {
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Please Enter First Name"
            self.removeAnimation()
            return
        }
        if self.txtLName.text == "" {
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Please Enter Last Name"
            self.removeAnimation()
            return
        }
        UserDefaults.standard.set(self.txtFName.text, forKey: "fname")
        UserDefaults.standard.set(self.txtLName.text, forKey: "lname")
        self.removeAnimation()
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
}
extension nameVC:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtFName {
            self.dividerViewFname.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mailImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == self.txtLName {
            self.dividerViewLname.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mail2Img.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")

        return (string == filtered)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
