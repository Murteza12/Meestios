//
//  groupsVC.swift
//  meestApp
//
//  Created by Yash on 8/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import SocketIO

class groupsVC: RootBaseVC {
    
    @IBOutlet weak var tableVIew:UICollectionView!
    var socket:SocketIOClient!
    var allUser = [groupHeads]()
    var groupChat: groupHeads?
    var chatHeadId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
//        self.socket = APIManager.sharedInstance.getSocket()
        self.socket =  SocketSessionHandler.manager.defaultSocket
        self.addHandler()
        self.getAllGroupHeads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chatHeadId = UserDefaults.standard.string(forKey: "ChatHeadId") ?? ""
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPeopleGroup" {
            let peopleGroup = segue.destination as! AddPeopleGroupVC
//            dvc.toUser = self.senduser
        }else if segue.identifier == "mainChatVC" {
            let group = segue.destination as! mainChatVC
            group.groupHead = self.groupChat
            group.isGroup = true
            
        }
    }
    func getAllGroupHeads(){
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            let payload = ["userId":user.id]
            self.socket.emit("getGroupHeads", payload)
        }
    }
    
    func addHandler(){
        self.socket.on("groupHeads") { data, ack in
            print(data)
            self.setGroupHeadsData(data: data)
            if self.allUser.count == 0{
                self.tableVIew.isHidden = true
            }else{
                self.tableVIew.isHidden = false
            }
            self.tableVIew.reloadData()
        }
    }
    
    @IBAction func showCollectionView(_ sender: Any){
        self.tableVIew.isHidden = false
    }
    
    func setGroupHeadsData(data: [Any]){
        var all = [groupHeads]()
        let newUser = data[0] as! [[String:Any]]
        for i in newUser {
            let id = i["id"] as? String ?? ""
            let isGroup = i["isGroup"] as? Bool ?? false
            let groupname = i["groupName"] as? String ?? ""
            let groupIcon = i["groupIcon"] as? String ?? ""
            let groupAdminData = i["groupAdminData"] as? [String:Any] ?? [:]
            let chat = i["chats"] as? [[String:Any]] ?? [[:]]
            
            let temp = groupHeads.init(id: id, groupIcon: groupIcon, isGroup: isGroup, groupname: groupname, groupAdminData: groupAdminData, chat: chat)
            
            all.append(temp)
        }
        print(all)
        self.allUser = all
    }

}

extension groupsVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allUser.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! createCell
            
            cell.view1.cornerRadius(radius: 8)
            cell.view1.layer.borderWidth = 0.5
            cell.view1.layer.borderColor = UIColor.lightGray.cgColor
            cell.createBtn.cornerRadius(radius: cell.createBtn.frame.height / 2)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! groupCell
            cell.delegate = self
            cell.onlineView.cornerRadius(radius: cell.onlineView.frame.height / 2)
            cell.proImg.cornerRadius(radius: cell.proImg.frame.height / 2)
            cell.img1.cornerRadius(radius: cell.img1.frame.height / 2)
            cell.img2.cornerRadius(radius: cell.img2.frame.height / 2)
            cell.img3.cornerRadius(radius: cell.img3.frame.height / 2)
            cell.img4.cornerRadius(radius: cell.img4.frame.height / 2)
            
            cell.view1.cornerRadius(radius: 8)
            cell.view1.layer.borderWidth = 0.5
            cell.view1.layer.borderColor = UIColor.lightGray.cgColor
            
            let groupData = self.allUser[indexPath.row-1]
            cell.groupName.text = groupData.groupName
            
            cell.onlineView.backgroundColor = UIColor.init(hex: 0xF8C756)
            cell.proImg.kf.setBackgroundImage(with: URL(string: groupData.groupIcon), for: .normal)
            cell.img1.kf.indicatorType = .activity
            cell.img2.kf.indicatorType = .activity
            cell.img3.kf.indicatorType = .activity
            cell.img4.kf.indicatorType = .activity
            cell.img1.kf.setImage(with: URL(string: groupData.groupIcon))
            cell.img2.kf.setImage(with: URL(string: groupData.groupIcon))
            cell.img3.kf.setImage(with: URL(string: groupData.groupIcon))
            cell.img4.kf.setImage(with: URL(string: groupData.groupIcon))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.tableVIew.frame.width / 2 - 20, height: self.tableVIew.frame.height / 2.7)
    }
    // removing spacing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "addPeopleGroup", sender: self)
        }else {
            self.groupChat = self.allUser[indexPath.row-1]
            self.performSegue(withIdentifier: "mainChatVC", sender: self)
            
        }
    }
}

extension groupsVC: GroupCellDelegate{
    
    
    func optionButtonAction(sender: Any, cell: groupCell) {
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let multiOptionVC = stoaryboard.instantiateViewController(withIdentifier: "MultiOptionVC") as? MultiOptionVC
        multiOptionVC?.modalPresentationStyle = .overCurrentContext
        multiOptionVC?.modalTransitionStyle = .crossDissolve
//        multiOptionVC?.allChatMessage = messages
//        multiOptionVC?.deleagte = self
        multiOptionVC?.isGroup = true
        self.present(multiOptionVC!, animated: true) {}
        multiOptionVC?.openChatCompletion = {
            
            let indexPath = self.tableVIew.indexPath(for: cell)
            self.groupChat = self.allUser[indexPath!.row - 1]
            self.performSegue(withIdentifier: "mainChatVC", sender: self)
        }
    }
    
    func starButtonAction(sender: Any, cell: groupCell) {
        let indexPath = self.tableVIew.indexPath(for: cell)
        
    }
    func displayPictureButtonAction(sender: Any) {
        
    }
    
}

protocol GroupCellDelegate {
    func optionButtonAction(sender: Any, cell: groupCell)
    func starButtonAction(sender: Any, cell: groupCell)
    func displayPictureButtonAction(sender: Any)
}

class groupCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var shadowview:UIView!
    @IBOutlet weak var strBtn:UIButton!
    @IBOutlet weak var optionBtn:UIButton!
    @IBOutlet weak var proImg:UIButton!
    @IBOutlet weak var groupName:UILabel!
    @IBOutlet weak var onlineView:UIView!
    
    @IBOutlet weak var img1:UIImageView!
    @IBOutlet weak var img2:UIImageView!
    @IBOutlet weak var img3:UIImageView!
    @IBOutlet weak var img4:UIImageView!

    var delegate: GroupCellDelegate?
    
    @IBAction func starButtonAction(_ sender: Any) {
        delegate?.starButtonAction(sender: sender, cell: self)
    }
    @IBAction func optionButtonAction(_ sender: Any) {
        delegate?.optionButtonAction(sender: sender, cell: self)
    }
    @IBAction func displayPictureButtonAction(_ sender: Any) {
        delegate?.displayPictureButtonAction(sender: sender)
    }
    
}
class createCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var shadowview:UIView!
    
    @IBOutlet weak var createBtn:UIButton!
    
}

class LoadingButton: UIButton {
var originalButtonText: String?
var activityIndicator: UIActivityIndicatorView!

func showLoading() {
    originalButtonText = self.titleLabel?.text
    self.setTitle("", for: .normal)

    if (activityIndicator == nil) {
        activityIndicator = createActivityIndicator()
    }

    showSpinning()
}

func hideLoading() {
    self.setTitle(originalButtonText, for: .normal)
    activityIndicator.stopAnimating()
}

private func createActivityIndicator() -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = .lightGray
    return activityIndicator
}

private func showSpinning() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    centerActivityIndicatorInButton()
    activityIndicator.startAnimating()
}

private func centerActivityIndicatorInButton() {
    let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
    self.addConstraint(xCenterConstraint)

    let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
    self.addConstraint(yCenterConstraint)
}
}
