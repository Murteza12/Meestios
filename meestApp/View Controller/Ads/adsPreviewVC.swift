//
//  adsPreviewVC.swift
//  meestApp
//
//  Created by Yash on 9/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class adsPreviewVC: RootBaseVC {

    let Arr_tbl_Name : [String] = ["Ads Listing","Create New Ads"]
    @IBOutlet weak var B_See_More: UIButton!
    @IBOutlet weak var lbl_Spent: UILabel!
    @IBOutlet weak var lbl_People_Reached: UILabel!
    @IBOutlet weak var B_LifeTime: UIButton!
    @IBOutlet weak var tbl_View: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.B_See_More.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    
   
    
    // MARK - button

    @IBAction func btn_Back(_ sender: Any) {
    }
    
    @IBAction func btn_Lifetime(_ sender: Any)
    {
        
    }
    @IBAction func btn_SeeMore(_ sender: Any)
    {
        
    }
}

// MARK - UITableView Delegates
extension adsPreviewVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.Arr_tbl_Name.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.Arr_tbl_Name[indexPath.row]
        cell?.textLabel?.textColor = UIColor.init(hex: 0x999999)
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
