//
//  notificationVC.swift
//  meestApp
//
//  Created by Yash on 9/2/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class notificationVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
    }

    @objc func showAction() {
        let action = UIAlertController.init(title: "Message", message: "Select Any One", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction.init(title: "Delete Comment", style: .default, handler: { (_) in
            
        }))
        action.addAction(UIAlertAction.init(title: "Delete Post", style: .default, handler: { (_) in
            
        }))
        action.addAction(UIAlertAction.init(title: "Block User", style: .default, handler: { (_) in
            
        }))
        action.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(action, animated: true, completion: nil)
    }
}
extension notificationVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! notiCell
        cell.view1.cornerRadius(radius: cell.view1.frame.height / 2)
        cell.profileImg.cornerRadius(radius: cell.profileImg.frame.height / 2)
        cell.view1.layer.borderWidth = 0.5
        cell.view1.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "") { (action, indexPath) in
            
        }

        delete.backgroundColor = UIColor.white
        

        return [delete]
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                    self.showAction()
                completionHandler(true)
            }
            deleteAction.image = UIImage(named: "deleteicon")
            deleteAction.backgroundColor = .white
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("OK, marked as Closed")
                success(true)
            })
            closeAction.image = UIImage(named: "likenoti")
            closeAction.backgroundColor = .white
        
        let closeAction2 = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        closeAction2.image = UIImage(named: "chatnoti")
        closeAction2.backgroundColor = .white
    
            return UISwipeActionsConfiguration(actions: [closeAction,closeAction2])
    
    }
}

class notiCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var profileImg:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
}
