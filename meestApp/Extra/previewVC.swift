//
//  previewVC.swift
//  meestApp
//
//  Created by Yash on 9/12/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class previewVC: RootBaseVC {

     var imageView = UIImageView()
       
       var image: UIImage? {
           didSet {
               if let image = image {
                   imageView.image = image
               }
           }
       }
       
       override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
           imageView.frame = self.view.bounds
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           self.title = "Amsterdam"
           imageView.image = image
           self.view.addSubview(imageView)
       }

}
