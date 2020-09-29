//
//  WallpaperOptionVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 29/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class WallpaperOptionVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var noWallpaperLabel: UILabel!
    @IBOutlet weak var galleryLabel: UILabel!
    @IBOutlet weak var solidColorLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var noWallpaperView: UIView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var solidColorView: UIView!
    
    var openGalleryCompletion : (()->())?
    var noWallpaerCompletion : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = "Wallpaper"
        headerLabel.font = UIFont.init(name: APPFont.bold, size: 18)
        noWallpaperLabel.font = UIFont.init(name: APPFont.regular, size: 12)
        galleryLabel.font = UIFont.init(name: APPFont.regular, size: 12)
        solidColorLabel.font = UIFont.init(name: APPFont.regular, size: 12)
        
        noWallpaperView.cornerRadiuss = noWallpaperView.frame.height / 2
        galleryView.cornerRadiuss = galleryView.frame.height / 2
        solidColorView.cornerRadiuss = solidColorView.frame.height / 2
        let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        self.backgroundView.addGestureRecognizer(tapOnScreen)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 24.0)
        
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noWallpaerAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            self.noWallpaerCompletion?()
        }
    }
    @IBAction func galleryAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            self.openGalleryCompletion?()
        }
    }
    @IBAction func solidColorAction(_ sender: Any) {
    }

}
