//
//  DocsViewController.swift
//  meestApp
//
//  Created by Rahul Kashyap on 02/10/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class DocsViewController: RootBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var docData = [[MockMessage]]()
    var searchCopy = [[MockMessage]]()
    var isDoc: Bool?
    var chatHeadImage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chatHeadImage = UserDefaults.standard.string(forKey: "ChatHeadId") ?? ""
        var parameter = [String:Any]()
        if isDoc == true{
             parameter = ["chatHeadId": self.chatHeadImage, "attachmentType": "Document"]
        }else{
             parameter = ["chatHeadId": self.chatHeadImage, "attachmentType": "Link"]
        }
        APIManager.sharedInstance.getMediaLinksAndDocs(vc: self, para: parameter) { (doc, str) in
            if str == "success"{
                self.docData.append(contentsOf: doc)
                self.tableView.reloadData()
            }
            let act = UIAlertController.init(title: "Error", message: "Error in getting data", preferredStyle: .alert)
            act.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
                
            }))
            self.present(act, animated: true, completion: nil)
        }
    }
    
    func search(text: String){
        print(text)
        
        guard !text.isEmpty else {
            searchCopy = docData
            tableView.reloadData()
            return
        }
        
        searchCopy =  docData.filter({ (fileName) -> Bool in
        var value: Bool?
        for i in fileName{
            value = i.fileURL.lowercased().contains(text.lowercased())
        }
        return value!
    })
        self.tableView.reloadData()
    }

}

extension DocsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        searchCopy.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCopy[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let headerView = UIView()
               headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
                
                headerView.backgroundColor = UIColor.init(red: 0.667, green: 0.667, blue: 0.667, alpha: 0.2)
                let rect = CGRect(x: 28, y: 0, width: tableView.frame.width, height: 20)
                let sectionName = UILabel(frame: rect)
                sectionName.text = self.searchCopy[section][0].category
                sectionName.font = UIFont.init(name: APPFont.regular, size: 16)
                headerView.addSubview(sectionName)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DocsViewControllerCell
        cell.selectionStyle = .none
        cell.docNameLabel.text = searchCopy[indexPath.section][indexPath.row].fileURL
        cell.sizeLabel.text = ""
        cell.timeLabel.text = searchCopy[indexPath.section][indexPath.row].createdAt
        
        return cell
    }
    
    
    
}

class DocsViewControllerCell: UITableViewCell {
    @IBOutlet weak var docNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var attachmentImageView: UIImageView!
    
    override class func awakeFromNib() {
        
    }
}
