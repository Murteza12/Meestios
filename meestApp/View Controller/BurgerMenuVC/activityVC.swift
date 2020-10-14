//
//  activityVC.swift
//  BurgerMenuModule
//
//  Created by Murteza on 10/10/2020.
//  Copyright © 2020 Murteza. All rights reserved.
//

import UIKit

class activityVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
           
             self.tableView.register(UINib(nibName: "activityCell", bundle: nil), forCellReuseIdentifier: "cell")
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  
    

 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return 5
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! activityCell
  
    return cell
 }

}
