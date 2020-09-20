//
//  searchVC.swift
//  meestApp
//
//  Created by Yash on 9/2/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class searchVC: RootBaseVC {

    @IBOutlet weak var topCollection:UICollectionView!
    @IBOutlet weak var hashTbl:UITableView!
    @IBOutlet weak var videoCollection:UICollectionView!
    @IBOutlet weak var peopleTbl:UITableView!
    
    @IBOutlet weak var searchView:UIView!
    
    var selected = 0
    
    let menu = ["PEOPLES","VIDEOS","#Hashtags"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.topCollection.delegate = self
        self.topCollection.dataSource = self
        
        self.videoCollection.delegate = self
        self.videoCollection.dataSource = self
        
        self.peopleTbl.delegate = self
        self.peopleTbl.dataSource = self
        
        self.hashTbl.delegate = self
        self.hashTbl.dataSource = self
        
        self.peopleTbl.isHidden = false
        self.videoCollection.isHidden = true
        self.hashTbl.isHidden = true
        
        self.searchView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        self.searchView.layer.borderWidth = 1
        self.searchView.cornerRadius(radius: 8)
    }
    func setSelected(index:Int) {
        if index == 0 {
            self.peopleTbl.isHidden = false
            self.videoCollection.isHidden = true
            self.hashTbl.isHidden = true
        } else if index == 1 {
            self.peopleTbl.isHidden = true
            self.videoCollection.isHidden = false
            self.hashTbl.isHidden = true
        } else if index == 2 {
            self.peopleTbl.isHidden = true
            self.videoCollection.isHidden = true
            self.hashTbl.isHidden = false
        }
    }
}
extension searchVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topCollection {
            return 3
        }
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.topCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! searchCell
            cell.lbl1.text = self.menu[indexPath.row]
            
            if self.selected == indexPath.row {
                cell.lbl1.textColor = UIColor(red: 0.231, green: 0.349, blue: 0.596, alpha: 0.8)
                cell.view1.backgroundColor = UIColor(red: 0.231, green: 0.349, blue: 0.596, alpha: 1)
            } else {
                cell.lbl1.textColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 0.8)
                cell.view1.backgroundColor = UIColor.clear
            }
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! videoCell
        cell.proImg.cornerRadius(radius: cell.proImg.frame.height / 2)
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.topCollection {
            self.selected = indexPath.row
            self.setSelected(index: indexPath.row)
            self.topCollection.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.videoCollection {
            return CGSize.init(width: self.videoCollection.frame.width / 2 - 2, height: self.videoCollection.frame.height / 2.5)
        }
        return CGSize.init(width: self.topCollection.frame.width / 3, height: self.topCollection.frame.height)
    }
    
    // removing spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
extension searchVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.peopleTbl {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! peopleCell
            cell.onlineView.cornerRadius(radius: cell.onlineView.frame.height / 2)
            cell.proImg.cornerRadius(radius: cell.proImg.frame.height / 2)
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! hashCell
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
class searchCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lbl1:UILabel!
    
}

class videoCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var proImg:UIImageView!
    
}

class hashCell:UITableViewCell {
    
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    
}

class peopleCell:UITableViewCell {
    @IBOutlet weak var proImg:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var unameLbl:UILabel!
    @IBOutlet weak var onlineView:UIView!
    
}
