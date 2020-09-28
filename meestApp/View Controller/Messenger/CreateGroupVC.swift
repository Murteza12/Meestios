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
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    var allUser = [SuggestedUser]()
    var selectedUser = [String]()
    var imageURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.cornerRadiuss = (self.cameraView.frame.height / 2)
        navigationController?.navigationBar.isHidden = true
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

