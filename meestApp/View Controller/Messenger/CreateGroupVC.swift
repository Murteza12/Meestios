//
//  CreateGroupVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 27/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class CreateGroupVC: RootBaseVC, UINavigationControllerDelegate {

    @IBOutlet weak var widthConstraintsConstant: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintsConstant: NSLayoutConstraint!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var participateLabel: UILabel!
    @IBOutlet weak var participantTableView: UITableView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    var allUser = [SuggestedUser]()
    var selectedMember = [String]()
    var selectedUser = [SuggestedUser]()
    var imageURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.cornerRadiuss = (self.cameraView.frame.height / 2)
        navigationController?.navigationBar.isHidden = true
        self.participateLabel.text = "Participants: " + String(selectedUser.count)
        self.participantTableView.delegate = self
        self.participantTableView.dataSource = self
        self.participantTableView.separatorStyle = .none
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        let stoaryboard = UIStoryboard(name: "Main", bundle: nil)
        let attachmentVC = stoaryboard.instantiateViewController(withIdentifier: "AttachmentVC") as? AttachmentVC
        attachmentVC?.modalPresentationStyle = .overCurrentContext
        attachmentVC?.modalTransitionStyle = .crossDissolve
        self.present(attachmentVC!, animated: true) {
            
        }
        
        attachmentVC?.openGalleryCompletion = { [weak self] in
            self?.openGallery()
        }
        
        attachmentVC?.openAttachmnetCompletion = { [weak self] in
            self?.openCamera()
        }

        
    }
    @IBAction func createGroup(_ sender: Any) {
        
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            if self.groupNameTextField.text != ""{
                let groupName = self.groupNameTextField.text
                let para = ["userId":user.id, "groupAdmin": user.id, "isGroup": "true", "groupMembers" : self.selectedUser, "groupName":groupName ?? "", "files":self.imageURL ?? ""] as [String : Any]
                self.createGroups(para: para)
            }
        }
    }
    
    func createGroups(para: [String: Any]){
        APIManager.sharedInstance.getGroupChatHeads(vc: self, para: para) { str in
            if str == "success"{
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }else{
                print("API Response Failed")
            }
        }
    }
    
    func openGallery() {
        let img = UIImagePickerController()
        img.delegate = self
        img.allowsEditing = true
        img.sourceType = .photoLibrary
        
        self.present(img, animated: true, completion: nil)
    }
    func openCamera() {
        let img = UIImagePickerController()
        img.delegate = self
        img.allowsEditing = true
        img.sourceType = .camera
        
        self.present(img, animated: true, completion: nil)
    }
    
}
    

extension CreateGroupVC: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
        heightConstraintsConstant.constant = 52
        widthConstraintsConstant.constant = 52
        self.cameraButton.layoutIfNeeded()        
        cameraButton.setImage(img, for: .normal)
        self.cameraButton.cornerRadius(radius: self.cameraButton.frame.width / 2)
        picker.dismiss(animated: true) {
            self.uploadImg(imageTouplaod: img)
        }
    }
    
    func uploadImg(imageTouplaod: UIImage) {
       self.loadAnimation()
       APIManager.sharedInstance.uploadImage(vc: self, img: imageTouplaod) { (str) in
           if str == "success" {
               self.removeAnimation()
               let imgURL = UserDefaults.standard.string(forKey: "IMG")
                self.imageURL = imgURL
           }
       }
   }

}

extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantTableViewCell", for: indexPath) as! ParticipantTableViewCell
        cell.selectionStyle = .none
        let data = selectedUser[indexPath.row]
        cell.userImage.cornerRadiuss = cell.userImage.frame.height / 2
        cell.userImage.kf.setImage(with: URL(string: data.displayPicture))
        cell.nameLabel.text = data.firstName + " " + data.lastName
        cell.nameLabel.font = UIFont.init(name: APPFont.regular, size: 16)
        cell.nameLabel.textColor = UIColor.init(hex: 0x151624)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

class ParticipantTableViewCell: UITableViewCell{
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override class func awakeFromNib() {
//        userImage.cornerRadiuss = self.userImage.frame.height / 2
    }
}

