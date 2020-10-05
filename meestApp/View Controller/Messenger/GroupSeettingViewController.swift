//
//  GroupSeettingViewController.swift
//  meestApp
//
//  Created by Rahul Kashyap on 04/10/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material

class GroupSeettingViewController: RootBaseVC {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var muteNotificationButton: UIButton!
    @IBOutlet weak var mediaVisibilityButton: UIButton!
    @IBOutlet weak var addParticipantButton: UIButton!
    @IBOutlet weak var groupSettingButton: UIButton!
    @IBOutlet weak var exitGroupButton: UIButton!
    @IBOutlet weak var muteNotoficationSwitch: UISwitch!
    
    @IBOutlet weak var muteNotificationImage: UIImageView!
    @IBOutlet weak var mediaVisibilityImage: UIImageView!
    @IBOutlet weak var addParticipantImage: UIImageView!
    @IBOutlet weak var groupSettingImage: UIImageView!
    @IBOutlet weak var exitGroupImage: UIImageView!
    @IBOutlet weak var mainGroupImage: UIImageView!
    @IBOutlet weak var nameImageView: UIImageView!
    @IBOutlet weak var descriptionImageView: UIImageView!
    
    @IBOutlet weak var nameBorderView: UIView!
    @IBOutlet weak var descriptionBorderView: UIView!
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var descriptionTextField: TextField!
    
    var groupName = ""
    var groupImage: UIImage?
    var chatHeadID = ""
    var groupId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameLabel.font = UIFont.init(name: APPFont.bold, size: 20)
        groupNameLabel.textColor = UIColor.white
        groupNameLabel.text = groupName
        mainGroupImage.image = convertToGrayScale(image: groupImage ?? UIImage())
        
        muteNotificationImage.setImage(UIImage(named: "mute")!)
        mediaVisibilityImage.setImage(UIImage(named: "media")!)
        addParticipantImage.setImage(UIImage(named: "AddPeople")!)
        groupSettingImage.setImage(UIImage(named: "setting")!)
        exitGroupImage.setImage(UIImage(named: "Exit")!)
        nameImageView.setImage(UIImage(named: "user-12")!)
        descriptionImageView.setImage(UIImage(named: "user-12")!)
        
        muteNotificationButton.setTitle("Mute Notification", for: .normal)
        mediaVisibilityButton.setTitle("Media Visibility", for: .normal)
        addParticipantButton.setTitle("Add Participants", for: .normal)
        groupSettingButton.setTitle("Group Settings", for: .normal)
        exitGroupButton.setTitle("Exit Group", for: .normal)
        
        muteNotificationButton.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 16)
        mediaVisibilityButton.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 16)
        addParticipantButton.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 16)
        groupSettingButton.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 16)
        exitGroupButton.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 16)
        
        muteNotificationButton.setTitleColor(UIColor.init(hex: 0x383838), for: .normal)
        mediaVisibilityButton.setTitleColor(UIColor.init(hex: 0x383838), for: .normal)
        addParticipantButton.setTitleColor(UIColor.init(hex: 0x383838), for: .normal)
        groupSettingButton.setTitleColor(UIColor.init(hex: 0x383838), for: .normal)
        exitGroupButton.setTitleColor(UIColor.init(hex: 0xFC2447), for: .normal)
        
        nameTextField.font = UIFont.init(name: APPFont.regular, size: 16)
        descriptionTextField.font = UIFont.init(name: APPFont.regular, size: 16)
        nameTextField.textColor = UIColor.init(hex: 0x383838)
        descriptionTextField.textColor = UIColor.init(hex: 0x383838)
        
        self.nameTextField.delegate = self
        self.descriptionTextField.delegate = self
        
        self.nameTextField.text = groupName
        
        if self.nameTextField.text != ""{
            self.nameImageView.setImage(UIImage(named: "usersetting")!)
        }
        
        if self.descriptionTextField.text != ""{
            self.descriptionImageView.setImage(UIImage(named: "usersetting")!)
        }
        
        self.nameTextField.dividerActiveColor = .clear
        self.nameTextField.dividerNormalColor = .clear
        self.nameTextField.placeholder = "Enter Name"
        self.nameTextField.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.descriptionTextField.dividerActiveColor = .clear
        self.descriptionTextField.dividerNormalColor = .clear
        self.descriptionTextField.placeholder = "Enter group description"
        self.descriptionTextField.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.nameBorderView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        self.descriptionBorderView.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.chatHeadID = UserDefaults.standard.string(forKey: "ChatHeadId") ?? ""
    }
    @IBAction func backButtonAction(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func mediaVisibilityButtonAction(_ sender: UIButton){
        
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let mediaAutodownloadVC = stoaryboard.instantiateViewController(withIdentifier: "MediaAutodownloadViewController") as? MediaAutodownloadViewController
        mediaAutodownloadVC?.modalPresentationStyle = .overCurrentContext
        mediaAutodownloadVC?.modalTransitionStyle = .crossDissolve
        self.present(mediaAutodownloadVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func addParticipantsButtonAction(_ sender: UIButton){
        let stoaryboard = UIStoryboard(name: "Main", bundle: nil)
        let addPeopleVC = stoaryboard.instantiateViewController(withIdentifier: "AddPeopleGroupVC") as? AddPeopleGroupVC
        addPeopleVC?.modalPresentationStyle = .overCurrentContext
        addPeopleVC?.modalTransitionStyle = .crossDissolve
        addPeopleVC?.addMember = true
        addPeopleVC?.groupId = groupId
        self.present(addPeopleVC!, animated: true, completion: nil)
    }
    
    @IBAction func groupSettingButtonAction(_ sender: UIButton){
        
    }
    
    @IBAction func exitGroupButtonAction(_ sender: UIButton){
        
    }
    
    @IBAction func muteNotificationSwitchAction(_ sender: UISwitch){
        
        if muteNotoficationSwitch.isOn{
            self.muteNotification(isTrue: true)
        }else{
            self.muteNotification(isTrue: false)
        }
        
    }
    
    func muteNotification(isTrue: Bool){
//        var type = ""
//        if isFromGroup == true{
//            type = "group"
//        }else{
//            type = "chat"
//        }
        
        let parameter = ["chatHeadId": self.chatHeadID, "settingType": "group", "isNotificationMute": isTrue] as [String : Any]
        APIManager.sharedInstance.chatSetting(vc: self, para: parameter) { (str) in
            if str == "success"{
//                self.dismiss(animated: true, completion: nil)
            }else{
                let act = UIAlertController.init(title: "Error", message: "Error while mute notification", preferredStyle: .alert)
                act.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
                    
                }))
                self.present(act, animated: true, completion: nil)
            }
        }
    }

}

extension GroupSeettingViewController:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.nameTextField {
            self.nameBorderView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.nameImageView.setImage(UIImage(named: "usersetting")!)
        } else if textField == self.descriptionTextField {
            self.descriptionBorderView.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.descriptionImageView.setImage(UIImage(named: "usersetting")!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension GroupSeettingViewController{
    
    func convertToGrayScale(image: UIImage) -> UIImage {

        // Create image rectangle with current image width/height
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height

        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        // Create a new UIImage object
        let newImage = UIImage(cgImage: imageRef!)

        return newImage
    }
}

