//
//  editProfileVC.swift
//  meestApp
//
//  Created by Yash on 9/2/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class editProfileVC: RootBaseVC {

    @IBOutlet weak var nameTxT:TextField!
    @IBOutlet weak var usernaemTxT:TextField!
    @IBOutlet weak var bioTxT:TextField!
    @IBOutlet weak var emailTxT:TextField!
    @IBOutlet weak var mobileTxT:TextField!
    @IBOutlet weak var genderTxT:TextField!
    
    @IBOutlet weak var dividerNameView:UIView!
    @IBOutlet weak var dividerUsernaemView:UIView!
    @IBOutlet weak var dividerBioView:UIView!
    @IBOutlet weak var divideremailView:UIView!
    @IBOutlet weak var dividermobileView:UIView!
    @IBOutlet weak var dividergenderView:UIView!
    
    @IBOutlet weak var nameimg:UIImageView!
    @IBOutlet weak var usernaemimg:UIImageView!
    @IBOutlet weak var bioimg:UIImageView!
    @IBOutlet weak var emailimg:UIImageView!
    @IBOutlet weak var mobileimg:UIImageView!
    @IBOutlet weak var genderimg:UIImageView!
    
    @IBOutlet weak var profileImg:UIImageView!
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.nameTxT.delegate = self
        self.usernaemTxT.delegate = self
        self.bioTxT.delegate = self
        self.emailTxT.delegate = self
        self.mobileTxT.delegate = self
        self.genderTxT.delegate = self
        
        
        self.nameTxT.dividerActiveColor = .clear
        self.nameTxT.dividerNormalColor = .clear
        self.nameTxT.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.usernaemTxT.dividerActiveColor = .clear
        self.usernaemTxT.dividerNormalColor = .clear
        self.usernaemTxT.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.bioTxT.dividerActiveColor = .clear
        self.bioTxT.dividerNormalColor = .clear
        self.bioTxT.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.emailTxT.dividerActiveColor = .clear
        self.emailTxT.dividerNormalColor = .clear
        self.emailTxT.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.mobileTxT.dividerActiveColor = .clear
        self.mobileTxT.dividerNormalColor = .clear
        self.mobileTxT.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.genderTxT.dividerActiveColor = .clear
        self.genderTxT.dividerNormalColor = .clear
        self.genderTxT.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.dividerNameView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.dividerUsernaemView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.dividerBioView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.divideremailView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.dividermobileView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.dividergenderView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        
        
        self.nameimg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.usernaemimg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.bioimg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.emailimg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.mobileimg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.genderimg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.profileImg.cornerRadius(radius: self.profileImg.frame.height / 2)
        
        self.registerForKeyboardWillHideNotification(self.scrollView)
        self.registerForKeyboardWillShowNotification(self.scrollView)
    }
}
extension editProfileVC:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.nameTxT {
            self.dividerNameView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.nameimg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == self.usernaemTxT {
            self.dividerUsernaemView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.usernaemimg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == self.bioTxT {
            self.dividerBioView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.bioimg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == self.emailTxT {
            self.divideremailView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.emailimg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == self.mobileTxT {
            self.dividermobileView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mobileimg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == self.genderTxT {
            self.dividergenderView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.genderimg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
