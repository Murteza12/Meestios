//
//  boostPostVC.swift
//  meestApp
//
//  Created by Yash on 9/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class boostPostVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    let item = ["Get more profile visits","Reach More People"]
    @IBOutlet weak var btn1:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.btn1.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
}
extension boostPostVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.item[indexPath.row]
        cell?.textLabel?.font = UIFont.init(name: APPFont.semibold, size: 19)
        cell?.textLabel?.textColor = UIColor.init(hex: 0xAAAAAA)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 2
    }
}
