//
//  feelingDetailVC.swift
//  meestApp
//
//  Created by Yash on 9/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class feelingDetailVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    let headerTxt = ["Happy","Blessed","Sad"]
    let img = ["feeld1","feel1","feeld2"]
    @IBOutlet weak var searchView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchView.cornerRadius(radius: self.searchView.frame.height / 2)
        self.searchView.layer.borderColor = UIColor.init(hex: 0xCCCCCC).cgColor
        self.searchView.layer.borderWidth = 1
        
    }
}
extension feelingDetailVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headerTxt.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! peopleCell
        
        cell.proImg.image = UIImage.init(named: self.img[indexPath.row])
        cell.nameLbl.text = self.headerTxt[indexPath.row]
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
