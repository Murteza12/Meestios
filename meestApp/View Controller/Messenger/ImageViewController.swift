//
//  ImageViewController.swift
//  meestApp
//
//  Created by Rahul Kashyap on 05/10/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var showImage: UIImageView!
    var imageToShow: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let image = imageToShow{
            self.showImage.image = image
        }
        
    }
    
    @IBAction func closeImageView(){
        self.dismiss(animated: true, completion: nil)
    }

}
