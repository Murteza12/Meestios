//
//  rightVC.swift
//  meestApp
//
//  Created by Yash on 8/23/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class rightVC: RootBaseVC {

    @IBOutlet weak var userNameLbl:UILabel!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var logoutView:UIView!
    let str = ["Our activity","Collections","Insights","Settings","Invite friends","Manage","Help"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProfile()
        self.headerView.roundCorners(corners: [.topLeft], radius: 20)
        self.logoutView.roundCorners(corners: [.bottomLeft], radius: 20)
    }
    func getProfile() {
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            self.userNameLbl.text = user.username
        }
    }

    @IBAction func logoutBtn(_ sender:UIButton) {
        APIManager.sharedInstance.clearDB {
            let dvc = self.storyboard?.instantiateViewController(withIdentifier: "preLoginVC") as! preLoginVC
            dvc.modalPresentationStyle = .fullScreen
            self.present(dvc, animated: true, completion: nil)
        }
    }
    @IBAction func back(_ sender:UIButton) {
        self.sideMenuController?.hideRightViewAnimated()
    }
}
extension rightVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.str.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! sideCell
        cell.img.image = UIImage.init(named: "r\(indexPath.row + 1)")
        cell.lbl1.text = self.str[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.str[indexPath.row] == "Help" {
            self.performSegue(withIdentifier: "help", sender: self)
        } else if self.str[indexPath.row] == "Manage" {
            self.performSegue(withIdentifier: "manage", sender: self)
        } else if self.str[indexPath.row] == "Settings" {
            self.performSegue(withIdentifier: "setting", sender: self)
        } else if self.str[indexPath.row] == "Collections" {
            self.performSegue(withIdentifier: "collection", sender: self)
        } else if self.str[indexPath.row] == "Invite friends" {
            self.performSegue(withIdentifier: "invite", sender: self)
        }
    }
}
class sideCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
    
}
