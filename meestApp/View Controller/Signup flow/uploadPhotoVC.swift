//
//  uploadPhotoVC.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class uploadPhotoVC: RootBaseVC {
    
    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var editBtn:UIButton!
    @IBOutlet weak var welcomeLbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.continueBtn.cornerRadius(radius: 10)
        
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(showActionSheett))
        self.img.addGestureRecognizer(tap1)
        self.img.isUserInteractionEnabled = true
        self.img.cornerRadius(radius: self.img.frame.height / 2)
        self.welcomeLbl.addBottomBorderWithColor(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1), width: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.editBtn.cornerRadius(radius: self.editBtn.frame.height / 2)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    @objc func showActionSheett() {
        let alert = UIAlertController.init(title: "Please Select Any One", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (_) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: { (_) in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
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
    @IBAction func uploadImg(_ sender:UIButton) {
        self.loadAnimation()
        APIManager.sharedInstance.uploadImage(vc: self, img: self.img.image!) { (str) in
            if str == "success" {
                self.removeAnimation()
                
                self.performSegue(withIdentifier: "proceed", sender: self)
            }
        }
    }
    @IBAction func skipBtn(_ sender:UIButton) {
        self.loadAnimation()
        APIManager.sharedInstance.uploadImage(vc: self, img: self.img.image!) { (str) in
            if str == "success" {
                self.removeAnimation()
                
                self.performSegue(withIdentifier: "proceed", sender: self)
            }
        }
    }
    @IBAction func editBtAct(_ sender:UIButton) {
        self.showActionSheett()
    }
}
extension uploadPhotoVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
        self.img.image = img
        picker.dismiss(animated: true, completion: nil)
    }
}
