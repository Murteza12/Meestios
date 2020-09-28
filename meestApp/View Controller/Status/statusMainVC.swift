//
//  statusMainVC.swift
//  meestApp
//
//  Created by Yash on 9/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation
import AVKit

class statusMainVC: RootBaseVC {

    @IBOutlet weak var galleryBtn:UIButton!
    @IBOutlet weak var photoBtn:UIButton!
    @IBOutlet weak var videoBtn:UIButton!
    @IBOutlet weak var contentView:UIView!
    var imageURL:String?
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locManager.location
        }
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
            controller.delegate = self
        } else if type == "photo" {
            guard AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) != nil
            else { fatalError("no front camera. but don't all iOS 10 devices have them?")}
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
    @IBAction func selfieButtonAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = false
        guard AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) != nil
        else { fatalError("No front camera")}
        self.present(imagePicker, animated: true, completion: nil)
    }
}
extension statusMainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
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
            self.insertStories()
           }
       }
   }
    
    func insertStories(){
        let hastags = [String]()
        let latLongLocation = ["lat":"\(currentLocation?.coordinate.latitude)", "long":"\(currentLocation?.coordinate.longitude)"]
        let location = ["lat":21.603176, "long":71.222084]

        let parameter = ["story": self.imageURL ?? "",
                         "caption": "",
                         "hashTags":hastags,
                         "location": latLongLocation,
                         "status":true,
                         "image":true] as [String : Any]
//        {
//            "story":"https://meest.ams3.digitaloceanspaces.com/userUploads/VHTzM2zAlANKW.jpg",
//            "caption":" ",
//            "hashTags":[],
//            "location":{
//                "lat":21.603176,
//                "long":71.222084
//            },
//            "status":true,
//            "image":true
//        }
        APIManager.sharedInstance.insertStory(vc: self, para: parameter) { (str) in
            if str == "success"{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension statusMainVC: createStoryDeleagte{
    func getImage(image: UIImage) {
        uploadImg(imageTouplaod: image)
    }
    
    func getText(text: String) {
        self.imageURL = text
        self.insertStories()
    }
}

