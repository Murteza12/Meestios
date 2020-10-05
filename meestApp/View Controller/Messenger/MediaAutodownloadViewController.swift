//
//  MediaAutodownloadViewController.swift
//  meestApp
//
//  Created by Rahul Kashyap on 04/10/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class MediaAutodownloadViewController: UIViewController {

    @IBOutlet weak var defaultYesButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var defaultYesLabel: UILabel!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.cornerRadius(radius: 15)
        
        descriptionLabel.font = UIFont.init(name: APPFont.semibold, size: 17)
        defaultYesLabel.font = UIFont.init(name: APPFont.regular, size: 17)
        yesLabel.font = UIFont.init(name: APPFont.regular, size: 17)
        noLabel.font = UIFont.init(name: APPFont.regular, size: 17)
        
        defaultYesButton.setImage(UIImage(named: "Select"), for: .normal)
        
        let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        self.view.addGestureRecognizer(tapOnScreen)
    }
    
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func defaultYesButtonAction(_ sender: UIButton){
        defaultYesButton.setImage(UIImage(named: "Select"), for: .normal)
        yesButton.setImage(UIImage(named: "Deselect"), for: .normal)
        noButton.setImage(UIImage(named: "Deselect"), for: .normal)
    }
    
    @IBAction func yesButtonAction(_ sender: UIButton){
        yesButton.setImage(UIImage(named: "Select"), for: .normal)
        defaultYesButton.setImage(UIImage(named: "Deselect"), for: .normal)
        noButton.setImage(UIImage(named: "Deselect"), for: .normal)
    }
    
    @IBAction func noButtonAction(_ sender: UIButton){
        noButton.setImage(UIImage(named: "Select"), for: .normal)
        defaultYesButton.setImage(UIImage(named: "Deselect"), for: .normal)
        yesButton.setImage(UIImage(named: "Deselect"), for: .normal)
    }

}
