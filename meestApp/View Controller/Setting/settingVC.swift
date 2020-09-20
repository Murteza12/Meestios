//
//  settingVC.swift
//  meestApp
//
//  Created by Yash on 9/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class settingVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    let values = ["Account Privacy","Change Language","Change Password","Notification","Media Autodownload","Do Not Disturb","Block List"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }

}
extension settingVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! settingCell
        cell.lbl1.text = self.values[indexPath.row]
        cell.lbl1.font = UIFont.init(name: APPFont.semibold, size: 16)
        cell.lbl1.textColor = UIColor(red: 0.082, green: 0.086, blue: 0.141, alpha: 0.7)
        if indexPath.row == 0 {
            cell.lbl2.text = "Private"
            cell.lbl2.isHidden = false
            cell.switchh.isHidden = true
        } else if indexPath.row == 1 {
            cell.lbl2.text = "English"
            cell.lbl2.isHidden = false
            cell.switchh.isHidden = true
        } else if indexPath.row == 2 {
            cell.lbl2.text = "15 Days Ago"
            cell.lbl2.isHidden = false
            cell.switchh.isHidden = true
        } else if indexPath.row == 3 {
            cell.lbl2.isHidden = true
            cell.switchh.isHidden = false
        } else if indexPath.row == 4 {
            cell.lbl2.isHidden = true
            cell.switchh.isHidden = false
        } else if indexPath.row == 5 {
            cell.lbl2.isHidden = true
            cell.switchh.isHidden = false
        } else {
            cell.lbl2.isHidden = true
            cell.switchh.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let act = UIAlertController.init(title: "Message", message: "Please Select Any One", preferredStyle: .actionSheet)
            act.addAction(UIAlertAction.init(title: "Private", style: .default, handler: { (_) in
                
            }))
            act.addAction(UIAlertAction.init(title: "Public", style: .default, handler: { (_) in
                
            }))
            
            act.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (_) in
                
            }))
            self.present(act, animated: true, completion: nil)
        } else if indexPath.row == 6 {
            self.performSegue(withIdentifier: "block", sender: self)
        }
    }
}

class settingCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var switchh:UISwitch!
    
}
