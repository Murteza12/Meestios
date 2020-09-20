//
//  feelingVC.swift
//  meestApp
//
//  Created by Yash on 9/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class feelingVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    let headerTxt = ["Feeling......","Celebrating...... ","Watching......","Travelling...... ","Eating......","Listening...... "]
    let subTxt = ["Get more people to see and engage what you are feeling now.","Choose to celebrate your joy and hapinees with us.","Watching movies or shows , lets to engage people and friends with us.","Go out somewhere with your friends.","Get more people to message you when you fill your apetite with your favorite cusine ","whats’s the mood now. share with your friends and get touched with them."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
}
extension feelingVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headerTxt.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! peopleCell
        
        cell.proImg.image = UIImage.init(named: "feel" + String(indexPath.row + 1))
        cell.nameLbl.text = self.headerTxt[indexPath.row]
        cell.unameLbl.text = self.subTxt[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
