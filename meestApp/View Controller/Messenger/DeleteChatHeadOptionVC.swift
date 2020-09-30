//
//  DeleteChatHeadOptionVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 24/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class DeleteChatHeadOptionVC: RootBaseVC {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var optionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confrimButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var isBlock: Bool?
    
    var userID = ""
    var chatHeadID = ""
    
    var deleteCompletion : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.font = UIFont.init(name: APPFont.regular, size: 22)
        confrimButton.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 18)
        cancelButton.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 18)
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
        if isBlock == true{
            descriptionLabel.text = "You really want to Block this person ?"
        }else{
            descriptionLabel.text = "You really want to delete this chat ?"
        }
        optionView.cornerRadius(radius: 15)
        confrimButton.cornerRadius(radius: 8)
        cancelButton.cornerRadius(radius: 8)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        if isBlock == true{
            
        }else{
        self.dismiss(animated: true) {
            self.deleteCompletion?()
        }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismissView()
    }
    
    func blockContact(){
        let parameter = ["userID": self.userID, "chatHeadID": self.chatHeadID]
        APIManager.sharedInstance.blockUser(vc: self, para: parameter) { (str) in
            if str == "success"{
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }else{
                let act = UIAlertController.init(title: "Error", message: "Error while blocking user", preferredStyle: .alert)
                act.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
                    
                }))
                self.present(act, animated: true, completion: nil)
            }
        }
    }
    
}
