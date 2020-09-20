//
//  followingVC.swift
//  meestApp
//
//  Created by Yash on 9/4/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class followingVC: RootBaseVC {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var proImg:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    var follower = [SuggestedUser]()
    var following = [SuggestedUser]()
    
    var arr = [String]()
    var selected = 0
    var userid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchView.cornerRadius(radius: self.searchView.frame.height / 2)
        self.searchView.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        self.searchView.layer.borderWidth = 1
        
        self.proImg.cornerRadius(radius: self.proImg.frame.height / 2)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllFollowers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func getAllFollowers() {
        APIManager.sharedInstance.getFollowsData(userId: self.userid, vc: self) { (followerr, followingg,dp,username) in
            self.follower = followerr
            self.following = followingg
            self.arr.append("\(followerr.count) Followers")
            self.arr.append("\(followingg.count) Followings")
            self.collectionView.reloadData()
            self.tableView.reloadData()
            self.nameLbl.text = username
            self.proImg.kf.indicatorType = .activity
            self.proImg.kf.setImage(with: URL(string: dp),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(dp)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            
        }
    }
}
extension followingVC:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! messagehomeCell
        cell.lbl.text = self.arr[indexPath.row]
        if self.selected == indexPath.row {
            cell.lbl.textColor = UIColor(red: 0.231, green: 0.349, blue: 0.596, alpha: 0.8)
            cell.view1.backgroundColor = UIColor(red: 0.231, green: 0.349, blue: 0.596, alpha: 0.8)
        } else {
            cell.lbl.textColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 0.8)
            cell.view1.backgroundColor = .clear
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected = indexPath.row
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width / 2, height: self.collectionView.frame.height)
    }
}

extension followingVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selected == 0 {
            return self.follower.count
        } else {
            return self.following.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selected == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! peopleCell
            let ind = self.follower[indexPath.row]
            if ind.isOnline {
                cell.onlineView.isHidden = false
            } else {
                cell.onlineView.isHidden = true
            }
            cell.onlineView.cornerRadius(radius: cell.onlineView.frame.height / 2)
            cell.proImg.cornerRadius(radius: cell.proImg.frame.height / 2)
            cell.proImg.kf.indicatorType = .activity
            cell.proImg.kf.setImage(with: URL(string: ind.displayPicture),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(ind.displayPicture)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! peopleCell
            let ind = self.following[indexPath.row]
            if ind.isOnline {
                cell.onlineView.isHidden = false
            } else {
                cell.onlineView.isHidden = true
            }
            cell.onlineView.cornerRadius(radius: cell.onlineView.frame.height / 2)
            cell.proImg.cornerRadius(radius: cell.proImg.frame.height / 2)
            cell.proImg.kf.indicatorType = .activity
            cell.proImg.kf.setImage(with: URL(string: ind.displayPicture),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(ind.displayPicture)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
