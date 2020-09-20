//
//  landingVC.swift
//  meestApp
//
//  Created by Yash on 8/14/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftRichString

class landingVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    var all = [Landing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getLanding()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "popup") as! enableLocationVC
        dvc.modalTransitionStyle = .crossDissolve
        self.present(dvc, animated: true, completion: nil)
    }
    func getLanding() {
        APIManager.sharedInstance.landingList(vc: self) { (land) in
            self.all = land
            self.tableView.reloadData()
        }
    }
}

extension landingVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.all.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! landingCell
            let ind = self.all[indexPath.row]
            let s1 = Style {
                $0.font = UIFont.init(name: "NunitoSans-Bold", size: 25)
            }
            let s2 = Style {
                $0.font = UIFont.init(name: "NunitoSans-Regular", size: 15)
            }
            let style = StyleXML.init(base: s1, ["s2" : s2])
            var str = ""
            if indexPath.row == 0 {
                str = "\(ind.title)\n<s2>\(ind.text)</s2>"
            } else {
                str = "\(ind.title)\n<s2>\(ind.text)</s2>"
            }
            cell.lbl.attributedText = str.set(style: style)
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: ind.url),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(ind.url)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! landingCell
            let ind = self.all[indexPath.row]
            let s1 = Style {
                $0.font = UIFont.init(name: "NunitoSans-Bold", size: 25)
            }
            let s2 = Style {
                $0.font = UIFont.init(name: "NunitoSans-Regular", size: 15)
            }
            let style = StyleXML.init(base: s1, ["s2" : s2])
            var str = ""
            if indexPath.row == 0 {
                str = "\(ind.title)<s2>\n\(ind.text)</s2>"
            } else {
                str = "\(ind.title)<s2>\n\(ind.text)</s2>"
            }
            cell.lbl.attributedText = str.set(style: style)
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: ind.url),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(ind.url)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 2
    }
}
class landingCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl:UILabel!
    
}
