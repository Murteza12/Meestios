//
//  statusMainVC.swift
//  meestApp
//
//  Created by Yash on 9/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import MobileCoreServices

class statusMainVC: RootBaseVC {

    @IBOutlet weak var galleryBtn:UIButton!
    @IBOutlet weak var photoBtn:UIButton!
    @IBOutlet weak var videoBtn:UIButton!
    @IBOutlet weak var contentView:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.galleryBtn.setTitleColor(UIColor.init(hex: 0x3B5998), for: .normal)
        self.photoBtn.setTitleColor(UIColor.init(hex: 0xAAAAAA), for: .normal)
        self.videoBtn.setTitleColor(UIColor.init(hex: 0xAAAAAA), for: .normal)
        
        self.galleryBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 12)
        self.photoBtn.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 12)
        self.videoBtn.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 12)
        
        self.galleryBtn.sendActions(for: .touchUpInside)
        
    }
    
    func setView(type:String) {
        if type == "gallery" {
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "createStoryVC") as! createStoryVC
            addChild(controller)
            self.contentView.addSubview(controller.view)
            controller.view.frame = self.contentView.bounds
            controller.view.layoutIfNeeded()
            controller.didMove(toParent: self)
        } else if type == "photo" {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        } else if type == "video" {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func galleryBtn(_ sender:UIButton) {
        self.galleryBtn.setTitleColor(UIColor.init(hex: 0x3B5998), for: .normal)
        self.photoBtn.setTitleColor(UIColor.init(hex: 0xAAAAAA), for: .normal)
        self.videoBtn.setTitleColor(UIColor.init(hex: 0xAAAAAA), for: .normal)
        
        self.galleryBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 12)
        self.photoBtn.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 12)
        self.videoBtn.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 12)
        self.setView(type: "gallery")
    }
    @IBAction func photoBtn(_ sender:UIButton) {
        
        self.photoBtn.setTitleColor(UIColor.init(hex: 0x3B5998), for: .normal)
        self.galleryBtn.setTitleColor(UIColor.init(hex: 0xAAAAAA), for: .normal)
        self.videoBtn.setTitleColor(UIColor.init(hex: 0xAAAAAA), for: .normal)
        
        self.photoBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 12)
        self.galleryBtn.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 12)
        self.videoBtn.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 12)
        self.setView(type: "photo")
        
    }
    @IBAction func videoBtn(_ sender:UIButton) {
        self.videoBtn.setTitleColor(UIColor.init(hex: 0x3B5998), for: .normal)
        self.photoBtn.setTitleColor(UIColor.init(hex: 0xAAAAAA), for: .normal)
        self.galleryBtn.setTitleColor(UIColor.init(hex: 0xAAAAAA), for: .normal)
        
        self.videoBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 12)
        self.photoBtn.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 12)
        self.galleryBtn.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 12)
        self.setView(type: "video")
    }
}
extension statusMainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
