//
//  ClearChatVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 30/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class ClearChatVC: RootBaseVC {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var optionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    var isBlock: Bool?
    var isSelected: Bool = false
    var userID = ""
    var chatHeadID = ""
    
    
    var clearCompletion : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.font = UIFont.init(name: APPFont.bold, size: 17)
        confirmLabel.font = UIFont.init(name: APPFont.bold, size: 17)
        clearButton.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 19)
        cancelButton.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 19)
        backgroundView.backgroundColor = UIColor.init(red: 56, green: 56, blue: 56, alpha: 0.4)
        checkBoxButton.setImage(UIImage(named: "Deselect"), for: .normal)
        let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        self.backgroundView.addGestureRecognizer(tapOnScreen)
    }
    
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userID = UserDefaults.standard.string(forKey: "UserId") ?? ""
        self.chatHeadID = UserDefaults.standard.string(forKey: "ChatHeadId") ?? ""
        optionView.cornerRadius(radius: 15)
    }
    
    @IBAction func checkBoxButtonAction(_ sender: Any) {
        
        isSelected = !isSelected
        
        if isSelected{
            checkBoxButton.setImage(UIImage(named: "Select"), for: .normal)
        }else{
            checkBoxButton.setImage(UIImage(named: "Deselect"), for: .normal)
        }
        
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
            self.clearCompletion?()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismissView()
    }
}
