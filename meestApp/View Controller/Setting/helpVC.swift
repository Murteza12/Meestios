//
//  helpVC.swift
//  meestApp
//
//  Created by Yash on 9/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class helpVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    let values = ["Report a Problem","Help Center","Privacy and Security Help","About","FAQ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
    }

}
extension helpVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.values[indexPath.row]
        cell?.textLabel?.font = UIFont.init(name: APPFont.semibold, size: 16)
        cell?.textLabel?.textColor = UIColor(red: 0.082, green: 0.086, blue: 0.141, alpha: 0.7)
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let act = UIAlertController.init(title: "Message", message: "Please Select Any One", preferredStyle: .actionSheet)
            act.addAction(UIAlertAction.init(title: "Report Spam or Abuse", style: .default, handler: { (_) in
                
            }))
            act.addAction(UIAlertAction.init(title: "Send Feedback", style: .default, handler: { (_) in
                
            }))
            act.addAction(UIAlertAction.init(title: "Report a Problem", style: .default, handler: { (_) in
                
            }))
            act.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (_) in
                
            }))
            self.present(act, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "about", sender: self)
        } else if indexPath.row == 3 {
            self.performSegue(withIdentifier: "privacy", sender: self)
        }
    }
}
