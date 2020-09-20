//
//  otherProfileVC.swift
//  meestApp
//
//  Created by Yash on 9/2/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher
import PeekPop

class otherProfileVC: RootBaseVC {

    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var followBtn:UIButton!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var userCollection:UICollectionView!
    @IBOutlet weak var photoCollectionView:UICollectionView!
    @IBOutlet weak var followingCount:UILabel!
    @IBOutlet weak var followerCount:UILabel!
    @IBOutlet weak var postCount:UILabel!
    @IBOutlet weak var heightCollection:NSLayoutConstraint!
    
    var peekPop: PeekPop?
    var userid = ""
    var otheruser:OtherUserr?
    var allSuggestUser = [SuggestedUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.followBtn.cornerRadius(radius: self.followBtn.frame.height / 2)
        self.userCollection.delegate = self
        self.userCollection.dataSource = self
        self.img.cornerRadius(radius: self.img.frame.height / 2)
        self.img.layer.borderColor = UIColor.white.cgColor
        self.img.layer.borderWidth = 3
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: self.photoCollectionView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllSuggestUser()
        self.getUserProfile(userid: self.userid)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.followBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "follow" {
            let dvc = segue.destination as! followingVC
            dvc.userid = self.otheruser?.id ?? ""
        }
    }
    @IBAction func follow(_ sender:UIButton){
        self.performSegue(withIdentifier: "follow", sender: self)
    }
    func getUserProfile(userid:String) {
        APIManager.sharedInstance.getOtherUserProfile(vc: self, userId: userid) { (other) in
            self.otheruser = other
            self.followerCount.text = other.totalFollowers.toString()
            self.followingCount.text = other.totalFollowings.toString()
            self.postCount.text = other.totalPosts.toString()
            self.nameLbl.text = other.username
            let totalBythree = other.posts.count / 3
            let collectionCitySize = CGFloat(totalBythree) * CGFloat(self.view.frame.width / 3)
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.heightCollection.constant = collectionCitySize + 370
            } else {
                self.heightCollection.constant = collectionCitySize + 170
            }
            self.photoCollectionView.reloadData()
            
            self.img.kf.indicatorType = .activity
            self.img.kf.setImage(with: URL(string: other.displayPicture),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(other.displayPicture)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            
            if other.friendStatus == "Following" {
                self.followBtn.setTitle("Following", for: .normal)
            } else if other.friendStatus == "Waiting" {
                self.followBtn.setTitle("Waiting", for: .normal)
            } else if other.friendStatus == "NoFriend" {
                if other.accountType == "PUBLIC" {
                    self.followBtn.setTitle("Follow", for: .normal)
                } else if other.accountType == "" {
                    self.followBtn.setTitle("Request", for: .normal)
                }
            }
        }
    }
    
    func getAllSuggestUser() {
        APIManager.sharedInstance.getAllSuggestion(vc: self) { (all) in
            self.allSuggestUser = all
            self.userCollection.reloadData()
        }
    }
}
extension otherProfileVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.userCollection {
            return self.allSuggestUser.count
        }
        return self.otheruser?.posts.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.userCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! storyCell
            let ind = self.allSuggestUser[indexPath.row]
            cell.addBtn.cornerRadius(radius: cell.addBtn.frame.height / 2)
            cell.nameLbl.text = ind.username
            cell.img.cornerRadius(radius: cell.img.frame.height / 2)
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: ind.displayPicture),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(ind.displayPicture)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            cell.addBtn.isHidden = true
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! galleryCell
        
        let ind = self.otheruser?.posts[indexPath.row]
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: ind?.posts[0].post),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(ind?.posts[0].post)
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.userCollection {
            return CGSize.init(width: 72, height: 72)
        }
        return CGSize.init(width: self.photoCollectionView.frame.width / 3 - 2, height: 128)
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
extension otherProfileVC:PeekPopPreviewingDelegate {
    func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        if let previewViewController = storyboard.instantiateViewController(withIdentifier: "previewVC") as? previewVC {
            if let indexPath = self.photoCollectionView!.indexPathForItem(at: location) {
                let cell = self.photoCollectionView.cellForItem(at: indexPath) as! galleryCell
                let selectedImage = cell.img.image
                if let layoutAttributes = self.photoCollectionView!.layoutAttributesForItem(at: indexPath) {
                    previewingContext.sourceRect = layoutAttributes.frame
                }
                previewViewController.image = selectedImage
                return previewViewController
            }

        }
        return nil
    }
    
    func previewingContext(_ previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    
    
}
