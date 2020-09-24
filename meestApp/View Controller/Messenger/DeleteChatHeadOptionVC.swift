//
//  DeleteChatHeadOptionVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 24/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class DeleteChatHeadOptionVC: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var optionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confrimButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        optionView.cornerRadius(radius: 15)
        confrimButton.cornerRadius(radius: 8)
        cancelButton.cornerRadius(radius: 8)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
    }
    
}
