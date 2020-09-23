//
//  AttachmentVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 23/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class AttachmentVC: UIViewController {
    
    @IBOutlet var attachementButton: UIButton!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var attacementView: UIView!
    @IBOutlet var galleryView: UIView!
    var openGalleryCompletion : (()->())?
    var openAttachmnetCompletion : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryView.cornerRadius(radius: 9.0)
        attacementView.cornerRadius(radius: 9.0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popUpView.roundCorners(corners: [.topLeft, .topRight], radius: 24.0)
        
    }
    
    @IBAction func attachmentButtonAction(_ sender: Any) {
        
        self.dismiss(animated: false) {
            self.openAttachmnetCompletion?()
        }
    }
    @IBAction func galleryButtonAction(_ sender: Any) {
        
        self.dismiss(animated: false) {
            self.openGalleryCompletion?()
        }
    }
    
    
    
}
