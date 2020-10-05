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
    var docData = [MockMessage]()
    var searchCopy = [MockMessage]()
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
            fileName.fileURL.lowercased().contains(text.lowercased())
        })
        self.tableView.reloadData()
    }

}

extension DocsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCopy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DocsViewControllerCell
        cell.selectionStyle = .none
        cell.docNameLabel.text = searchCopy[indexPath.row].fileURL
        cell.sizeLabel.text = ""
        cell.timeLabel.text = searchCopy[indexPath.row].createdAt
        
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
