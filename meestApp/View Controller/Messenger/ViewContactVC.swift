//
//  ViewContactVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 29/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher

protocol ViewContactVCDeleagte {
    func showWallpaperOptions()
}

class ViewContactVC: RootBaseVC {

    @IBOutlet weak var nameHeaderLabel: UILabel!
    @IBOutlet weak var displayPictureImaegView: UIImageView!
    @IBOutlet weak var viewContactCollectionView: UICollectionView!
    @IBOutlet weak var viewContactTableView: UITableView!
    @IBOutlet weak var mediaLinkLabel: UILabel!
    var allChatMessage = [MockMessage]()
    var chatHeadImage = ""
    var isMuted: Bool = false
    var options = ["Change Wallpaper", "Mute Notification", "Media Autodownload", "Block Contact"]
    var delegate: ViewContactVCDeleagte?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContactTableView.delegate = self
        self.viewContactTableView.dataSource = self
        self.viewContactTableView.separatorStyle = .none
        self.viewContactCollectionView.delegate = self
        self.viewContactCollectionView.dataSource = self
        self.mediaLinkLabel.text = "Media Links and Docs"
        self.mediaLinkLabel.textColor = UIColor.init(hex: 0x151624)
        self.mediaLinkLabel.font = UIFont.init(name: APPFont.regular, size: 16)
        viewContactCollectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.chatHeadImage = UserDefaults.standard.string(forKey: "ChatHeadId") ?? ""
        self.loadImage()
        self.getChatSetting()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func videoCallAction(_ sender: Any) {
    }
    
    @IBAction func audioCallAction(_ sender: Any) {
    }
    
    func loadImage(){
        let parameter = ["chatHeadId": self.chatHeadImage, "attachmentType": "Image"]
        APIManager.sharedInstance.getMediaLinksAndDocs(vc: self, para: parameter) { (message, str) in
            if str == "success"{
                self.allChatMessage.append(contentsOf: message)
                self.viewContactCollectionView.reloadData()
            }else{
                let act = UIAlertController.init(title: "Error", message: "Error in getting data", preferredStyle: .alert)
                act.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
                    
                }))
                self.present(act, animated: true, completion: nil)
            }
        }
    }
}

extension ViewContactVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ViewContactTableViewCell", for: indexPath) as! ViewContactTableViewCell
        cell.delegate = self
        cell.onOffSwitch.isHidden = false
        cell.selectionStyle = .none
        cell.optionLabel.text = self.options[indexPath.row]
        cell.optionLabel.textColor = UIColor.init(hex: 0x151624)
        if indexPath.row == (self.options.count - 1){
            cell.optionLabel.textColor = UIColor.init(hex: 0xF93F4F)
            cell.onOffSwitch.isHidden = true
        }
        if indexPath.row == 0{
            cell.onOffSwitch.isHidden = true
        }
        
        if cell.optionLabel.text == "Mute Notification"{
            cell.onOffSwitch.isOn = isMuted
        }
        cell.optionLabel.font = UIFont.init(name: APPFont.regular, size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.openWallpaper()
            
        case 3:
            self.blockContact()
        default:
            print("Default Called")
        }
    }
    
    func openWallpaper(){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true) {
            //self.delegate?.showWallpaperOptions()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showWallpaper"), object: nil)
            
        }
    }
    
    func blockContact(){
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true) {
            //self.delegate?.showWallpaperOptions()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "blockContact"), object: nil)
        }
    }
    
    func muteNotification(isTrue: Bool, sender: UISwitch){
        /*{
            "chatHeadId": "ae382bba-10d3-42e5-a4be-b53584fe5aec",
            "settingType": "aaaaaa",
            "isNotificationMute": false,
            "isReported": false,
            "reportText": "aa",
            "markPriority": true
        }*/
        let parameter = ["chatHeadId": self.chatHeadImage, "isNotificationMute": isTrue] as [String : Any]
        APIManager.sharedInstance.chatSetting(vc: self, para: parameter) { (str) in
            if str == "success"{
                 
            }else{
                if sender.isOn == true{
                    sender.isOn = false
                }else{
                    sender.isOn = true
                }
            }
        }
    }
    
    func getChatSetting(){
        
        APIManager.sharedInstance.getChatSetting(vc: self) { (chat, str) in
            if str == "success"{
                self.isMuted = chat[0].isNotificationMute ?? false
                self.viewContactTableView.reloadData()
            }else{
                
            }
        }
        
    }
}

extension ViewContactVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allChatMessage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewContactCollectionViewCell", for: indexPath) as! ViewContactCollectionViewCell
        let message = allChatMessage[indexPath.row]
        if message.attachment == 1{
            if message.attachmentType == "Image"{
//                cell.imageView.kf.setImage(with: URL(string: message.fileURL))
                cell.imageView.kf.indicatorType = .activity
                cell.imageView.kf.setImage(with: URL(string: message.fileURL),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print(message.fileURL)
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }

            }else if message.attachmentType == "Video"{
                cell.imageView.kf.setImage(with: URL(string: message.videothumbnail))
            }else if message.attachmentType == "Audio"{
                cell.imageView.image = UIImage(named: "Headphone")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 90, height: floor(90))
    }
    
}

extension ViewContactVC: ViewContactTableViewCellDeleagte{
    func toggleAction(sender: UISwitch, cell: ViewContactTableViewCell) {
        
        let indexPath = viewContactTableView.indexPath(for: cell)
        if options[indexPath!.row] == "Mute Notification"{
            if sender.isOn{
                muteNotification(isTrue: true, sender: sender)
            }else{
                muteNotification(isTrue: false, sender: sender)
            }
        }else if options[indexPath!.row] == "Media Autodownload"{
            
        }
    }
    
    
}

protocol ViewContactTableViewCellDeleagte {
    func toggleAction(sender: UISwitch, cell: ViewContactTableViewCell)
}

class ViewContactTableViewCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    var delegate: ViewContactTableViewCellDeleagte?
    
    @IBAction func switchToggleAction(_ sender: UISwitch) {
        delegate?.toggleAction(sender: sender, cell: self)
    }
}

class ViewContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
}
