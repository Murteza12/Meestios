//
//  usernameVC.swift
//  meestApp
//
//  Created by Yash on 8/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material
import DatePicker
import DropDown

class usernameVC: RootBaseVC {

    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    @IBOutlet weak var txtFName:TextField!
    
    @IBOutlet weak var continueBtn:UIButton!
    
    @IBOutlet weak var dividerViewFname:UIView!
    
    @IBOutlet weak var mailImg:UIImageView!
    
    @IBOutlet weak var fnameView:UIView!
    
    @IBOutlet weak var errorLbl:UILabel!
    @IBOutlet weak var anchorVIew:UIView!
    
    let dropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.continueBtn.cornerRadius(radius: 10)
        
        self.txtFName.dividerActiveColor = .clear
        self.txtFName.dividerNormalColor = .clear
        self.txtFName.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.dividerViewFname.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        
        self.txtFName.delegate = self
        
        
        self.mailImg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.fnameView.isHidden = false
        
        self.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
        self.errorLbl.isHidden = true
        
        self.dropDown.anchorView = self.anchorVIew
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "username") != nil {
            self.txtFName.text = UserDefaults.standard.string(forKey: "username")
        } else {
            let fname = UserDefaults.standard.string(forKey: "fname") ?? ""
            let lname = UserDefaults.standard.string(forKey: "lname") ?? ""
            self.txtFName.text = fname + "_" + lname
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
            self.errorLbl.text = "Please Enter A Username"
            
            self.removeAnimation()
            return
        }
        APIManager.sharedInstance.verifyUsername(vc: self, username: self.txtFName.text ?? "") { (str,suggestion) in
            if str == "Username does not exist" {
                self.removeAnimation()
                UserDefaults.standard.set(self.txtFName.text, forKey: "username")
                self.performSegue(withIdentifier: "proceed", sender: self)
            } else if str == "Username exists" {
                if suggestion.count > 0 {
                    self.dropDown.dataSource = suggestion
                    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        self.txtFName.text = item
                        self.dropDown.hide()
                    }
                    self.dropDown.width = 200
                    self.dropDown.show()
                }
                
                
                self.removeAnimation()
                self.errorLbl.isHidden = false
                self.dividerViewFname.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                self.errorLbl.text = "Username Not Available"
                self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            }
        }
    }
    @IBAction func resetValues(_ sender:UIButton) {
        APIManager.sharedInstance.verifyUsername(vc: self, username: self.txtFName.text ?? "") { (str,suggestion) in
            if str == "Username does not exist" {
                self.removeAnimation()
                UserDefaults.standard.set(self.txtFName.text, forKey: "username")
                self.performSegue(withIdentifier: "proceed", sender: self)
            } else if str == "Username exists" {
                if suggestion.count > 0 {
                    self.dropDown.dataSource = suggestion
                    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        self.txtFName.text = item
                        self.dropDown.hide()
                    }
                    self.dropDown.width = 200
                    self.dropDown.show()
                }
                
                
                self.removeAnimation()
                self.errorLbl.isHidden = false
                self.dividerViewFname.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                self.errorLbl.text = "Username Not Available"
                self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            }
        }
    }
}
extension usernameVC:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtFName {
            self.dividerViewFname.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mailImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            
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
    func textField(textField: TextField, didChange text: String?) {
        APIManager.sharedInstance.verifyUsername(vc: self, username: text ?? "") { (str,suggestion) in
            if str == "Username does not exist" {
                self.errorLbl.isHidden = false
                
                self.errorLbl.text = "Username Available"
                self.errorLbl.textColor = UIColor(red: 0.437, green: 0.733, blue: 0.333, alpha: 1)
                
            } else if str == "Username exists" {
                if suggestion.count > 0 {
                    self.dropDown.dataSource = suggestion
                    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        self.txtFName.text = item
                        self.dropDown.hide()
                    }
                    self.dropDown.width = 200
                    self.dropDown.show()
                }
                
                
                self.removeAnimation()
                self.errorLbl.isHidden = false
                self.dividerViewFname.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                self.errorLbl.text = "Username Not Available"
                self.mailImg.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            }
        }
    }
}
