//
//  manageVC.swift
//  meestApp
//
//  Created by Yash on 9/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class manageVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    let values = ["","Boost post","Manage campaign"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }

}
extension manageVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.values[indexPath.row]
        cell?.textLabel?.font = UIFont.init(name: APPFont.semibold, size: 16)
        cell?.textLabel?.textColor = UIColor(red: 0.082, green: 0.086, blue: 0.141, alpha: 0.7)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "boost", sender: self)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "campaign", sender: self)
        }
    }
}

