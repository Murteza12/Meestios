//
//  adharVerifVC.swift
//  meestApp
//
//  Created by Yash on 9/2/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class adharVerifVC: RootBaseVC {

    @IBOutlet weak var nameTxT:TextField!
    @IBOutlet weak var usernaemTxT:TextField!
    
    @IBOutlet weak var dividerNameView:UIView!
    @IBOutlet weak var dividerUsernaemView:UIView!
    
    @IBOutlet weak var nameimg:UIImageView!
    @IBOutlet weak var usernaemimg:UIImageView!
    
    @IBOutlet weak var continueBtn:UIButton!
    
    @IBOutlet weak var view1:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view1.cornerRadius(radius: 23)
        
        self.nameTxT.delegate = self
        self.usernaemTxT.delegate = self
        
        self.nameTxT.dividerActiveColor = .clear
        self.nameTxT.dividerNormalColor = .clear
        self.nameTxT.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.usernaemTxT.dividerActiveColor = .clear
        self.usernaemTxT.dividerNormalColor = .clear
        self.usernaemTxT.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        
        self.dividerNameView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.dividerUsernaemView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        
        self.nameimg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.usernaemimg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.continueBtn.cornerRadius(radius: 10)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
}
extension adharVerifVC:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.nameTxT {
            self.dividerNameView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.nameimg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else if textField == self.usernaemTxT {
            self.dividerUsernaemView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.usernaemimg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } 
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
