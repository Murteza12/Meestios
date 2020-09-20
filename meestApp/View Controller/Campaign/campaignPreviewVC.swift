//
//  campaignPreviewVC.swift
//  meestApp
//
//  Created by Yash on 9/9/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class campaignPreviewVC: RootBaseVC {

    @IBOutlet weak var I_Avater: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var I_Campaign_Img: UIImageView!
    @IBOutlet weak var lbl_Campaign_Text: UILabel!
    @IBOutlet weak var bl_Off: UILabel!
    @IBOutlet weak var B_Pay_Amount: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        B_Pay_Amount.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    
     // MARK - button

    @IBAction func btn_Back(_ sender: Any) {
    }
   
     @IBAction func btn_Pay_Amount(_ sender: Any) {
     }
    
    @IBAction func btn_dropdown(_ sender: Any) {
    }
    
    @IBAction func btn_Learn_More(_ sender: Any) {
    }
    
    @IBAction func btn_Save_Draft(_ sender: Any) {
    }
}
