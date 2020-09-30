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

class ViewContactVC: UIViewController {

    @IBOutlet weak var nameHeaderLabel: UILabel!
    @IBOutlet weak var displayPictureImaegView: UIImageView!
    @IBOutlet weak var viewContactCollectionView: UICollectionView!
    @IBOutlet weak var viewContactTableView: UITableView!
    @IBOutlet weak var mediaLinkLabel: UILabel!
    var allChatMessage = [MockMessage]()
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
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func videoCallAction(_ sender: Any) {
    }
    
    @IBAction func audioCallAction(_ sender: Any) {
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
        default:
            print("Default Called")
        }
    }
    
    func openWallpaper(){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true) {
            self.delegate?.showWallpaperOptions()
        }
    }
}

extension ViewContactVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allChatMessage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewContactCollectionViewCell", for: indexPath) as! ViewContactCollectionViewCell
        let message = allChatMessage[indexPath.row]
        if message.attachment == 1{
            if message.attachmentType == "Image"{
                cell.imageView.kf.setImage(with: URL(string: message.fileURL))
            }else if message.attachmentType == "Video"{
                cell.imageView.kf.setImage(with: URL(string: message.videothumbnail))
            }else{
                cell.imageView.image = UIImage(named: "Headphone")
            }
        }
        
        return cell
    }
}

extension ViewContactVC: ViewContactTableViewCellDeleagte{
    func toggleAction(sender: UISwitch) {
        if sender.isOn{
            
        }else{
            
        }
    }
    
    
}

protocol ViewContactTableViewCellDeleagte {
    func toggleAction(sender: UISwitch)
}

class ViewContactTableViewCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    var delegate: ViewContactTableViewCellDeleagte?
    
    @IBAction func switchToggleAction(_ sender: UISwitch) {
        delegate?.toggleAction(sender: sender)
    }
}

class ViewContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
}
