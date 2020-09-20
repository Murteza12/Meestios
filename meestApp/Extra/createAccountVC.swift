//
//  createAccountVC.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class createAccountVC: RootBaseVC {

    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var tablView:customTbl!
    @IBOutlet weak var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.continueBtn.cornerRadius(radius: 10)
        
        self.tablView.delegate = self
        self.tablView.dataSource = self
        
        self.registerForKeyboardWillHideNotification(self.scrollView)
        self.registerForKeyboardWillShowNotification(self.scrollView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tablView.invalidateIntrinsicContentSize()
        }
    }
    @objc func textShow(_ sender:UIButton) {
        let cell4 = self.tablView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! createAccCell
        if cell4.txt.isSecureTextEntry {
            cell4.txt.isSecureTextEntry = false
        } else {
            cell4.txt.isSecureTextEntry = true
        }
    }
    
    @IBAction func continueBtn(_ sender:UIButton) {
        let cell1 = self.tablView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! createAccCell
        let cell2 = self.tablView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! createAccCell
        let cell3 = self.tablView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! createAccCell
        let cell4 = self.tablView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! createAccCell
        
        if cell1.txt.text == "" {
            self.showAlert(title: "Message", message: "Please Enter Username")
            return
        }
        if cell2.txt.text == "" {
            self.showAlert(title: "Message", message: "Please Enter Email")
            return
        }
        if cell3.txt.text == "" {
            self.showAlert(title: "Message", message: "Please Enter Mobile Number")
            return
        }
        if cell4.txt.text == "" {
            self.showAlert(title: "Message", message: "Please Enter Password")
            return
        }
        APIManager.sharedInstance.registerUser(vc: self, username: cell1.txt.text ?? "", mobile: cell3.txt.text ?? "", email: cell2.txt.text ?? "", password: cell4.txt.text ?? "") { (str) in
            if str == "success" {
                self.performSegue(withIdentifier: "proceed", sender: self)
                UserDefaults.standard.set(cell1.txt.text ?? "", forKey: "username")
            }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
extension createAccountVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! createAccCell
        cell.txt.dividerActiveColor = .clear
        cell.txt.dividerNormalColor = .clear
        cell.txt.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        cell.img.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        cell.dividerView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        cell.txt.delegate = self
        cell.errorLbl.isHidden = true
        if indexPath.row == 0 {
            cell.txt.placeholder = "Create your username"
            cell.img.image = UIImage.init(named: "user")
            cell.showBtn.isHidden = true
            cell.txt.isSecureTextEntry = false
        } else if indexPath.row == 1 {
            cell.txt.placeholder = "Enter your e-mail"
            cell.img.image = UIImage.init(named: "email")
            cell.showBtn.isHidden = true
            cell.txt.isSecureTextEntry = false
            cell.txt.keyboardType = .emailAddress
        } else if indexPath.row == 2 {
            cell.txt.placeholder = "Enter your mobile number"
            cell.img.image = UIImage.init(named: "phone 1")
            cell.showBtn.isHidden = true
            cell.txt.isSecureTextEntry = false
        } else if indexPath.row == 3 {
            cell.txt.placeholder = "Create your password"
            cell.img.image = UIImage.init(named: "lock")
            cell.showBtn.isHidden = false
            cell.showBtn.addTarget(self, action: #selector(textShow(_:)), for: .touchUpInside)
            cell.txt.isSecureTextEntry = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
}
extension createAccountVC:TextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let cell1 = self.tablView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! createAccCell
        let cell2 = self.tablView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! createAccCell
        let cell3 = self.tablView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! createAccCell
        let cell4 = self.tablView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! createAccCell
        
        if textField == cell1.txt {
            if !cell1.errorLbl.isHidden {
                cell1.errorLbl.isHidden = true
            }
            cell1.dividerView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            cell1.img.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == cell2.txt {
            if !cell2.errorLbl.isHidden {
                cell2.errorLbl.isHidden = true
            }
            cell2.dividerView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            cell2.img.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == cell3.txt {
            if !cell3.errorLbl.isHidden {
                cell3.errorLbl.isHidden = true
            }
            cell3.dividerView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            cell3.img.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == cell4.txt {
            if !cell4.errorLbl.isHidden {
                cell4.errorLbl.isHidden = true
            }
            cell4.dividerView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            cell4.img.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell1 = self.tablView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! createAccCell
        let cell2 = self.tablView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! createAccCell
        let cell3 = self.tablView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! createAccCell
        let cell4 = self.tablView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! createAccCell
        
        if textField == cell1.txt {
            cell1.dividerView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            cell1.img.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == cell2.txt {
            if !self.isValidEmail(cell2.txt.text ?? "") {
                cell2.errorLbl.isHidden = false
                cell2.errorLbl.text = "Enter a valid Email"
                cell2.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                cell2.dividerView.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                cell2.img.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
            } else {
                APIManager.sharedInstance.verifyEmail(vc: self, email: cell2.txt.text ?? "") { (str) in
                    if str == "Email exists" {
                        cell2.errorLbl.isHidden = false
                        cell2.errorLbl.text = "Email Already Exsist"
                        cell1.dividerView.backgroundColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                        cell1.img.tintColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
                    }
                }
            }
        } else if textField == cell3.txt {
            cell3.dividerView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            cell3.img.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == cell4.txt {
            cell4.dividerView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            cell4.img.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        }
    }
}
class createAccCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var dividerView:UIView!
    @IBOutlet weak var txt:TextField!
    @IBOutlet weak var showBtn:UIButton!
    @IBOutlet weak var errorLbl:UILabel!
}
