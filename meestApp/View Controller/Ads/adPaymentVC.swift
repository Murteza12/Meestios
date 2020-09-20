//
//  adPaymentVC.swift
//  meestApp
//
//  Created by Yash on 9/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class adPaymentVC: UIViewController {

    @IBOutlet weak var lbl_Off_text: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Amount: UILabel!
    @IBOutlet weak var tbl_View: UITableView!
    @IBOutlet weak var B_PayandPublish: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        tbl_View.superview!.layer.masksToBounds = false
        
        tbl_View.superview!.layer.shadowColor = UIColor(red: 0.822, green: 0.827, blue: 0.843, alpha: 1).cgColor
        tbl_View.superview!.layer.shadowOpacity = 1
        tbl_View.superview!.layer.shadowOffset = CGSize(width: 0, height: 5)
        tbl_View.superview!.layer.shadowRadius = 10


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        B_PayandPublish.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    
     // MARK - button
    @IBAction func btn_Back(_ sender: Any) {
    }
    

    @IBAction func btn_Add_New_Payment(_ sender: Any) {
    }
    
    @IBAction func btn_PayandPublish(_ sender: Any) {
    }
    
}

// MARK - UITableView Delegates
extension adPaymentVC: UITableViewDelegate,UITableViewDataSource
{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbl_View.dequeueReusableCell(withIdentifier: "Cell_PaymentMethod") as! Cell_PaymentMethod
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 68
    }
}
class Cell_PaymentMethod: UITableViewCell {

   
    @IBOutlet weak var Method_Img: UIImageView!
    
    @IBOutlet weak var I_Bg_Img: UIImageView!
    @IBOutlet weak var lbl_Number: UILabel!
    @IBOutlet weak var B_Right: UIButton!
}
