//
//  profileVC.swift
//  meestApp
//
//  Created by Yash on 8/22/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class profileVC:RootBaseVC {
    
    @IBOutlet weak var profileView:UIView!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var editBtn:UIButton!
    @IBOutlet weak var usernameLbl:UILabel!
    @IBOutlet weak var bioLbl:UILabel!
    @IBOutlet weak var followerLbl:UILabel!
    @IBOutlet weak var followingLbl:UILabel!
    @IBOutlet weak var postLbl:UILabel!
  //  @IBOutlet weak var logoutBtn:UIButton!
    @IBOutlet weak var userCollection:UICollectionView!
    @IBOutlet weak var photoCollectionView:UICollectionView!
    @IBOutlet weak var heightCollection:NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userCollection.delegate = self
        self.userCollection.dataSource = self
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getCurrentUser()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.profileView.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .vertical)
        self.profileView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: self.profileView.frame.height / 2)
       // self.logoutBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
       // self.logoutBtn.isHidden = true
        self.imgView.cornerRadius(radius: self.imgView.frame.height / 2)
       // self.logoutBtn.cornerRadius(radius: 10)
        self.imgView.layer.borderColor = UIColor.white.cgColor
        self.imgView.layer.borderWidth = 2
        
        self.editBtn.cornerRadius(radius: self.editBtn.frame.height / 2)
    }
    
    func showMenu(){
           let myMenu = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC")
        myMenu?.hidesBottomBarWhenPushed = true
           let transition = CATransition()
           transition.duration = 0.4
           transition.type = CATransitionType.push
           transition.subtype = CATransitionSubtype.fromRight
           transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           view.window!.layer.add(transition, forKey: kCATransition)
           self.navigationController?.view?.layer.add(transition, forKey: nil)
           // self.navigationController?.pushViewController(myMenu, animated: false)
        myMenu?.modalPresentationStyle = .overCurrentContext
        
        present(myMenu!, animated: false, completion: nil)

       }
    
    
    @IBAction func showMenu(_ sender: Any) {
        self.showMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let totalBythree = 10 / 3
        let collectionCitySize = CGFloat(totalBythree) * CGFloat(self.view.frame.width / 3)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.heightCollection.constant = collectionCitySize + 370
        } else {
            self.heightCollection.constant = collectionCitySize + 170
        }
    }
    func getCurrentUser() {
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            self.usernameLbl.text = user.username
           // self.bioLbl.text = user.about
            self.followerLbl.text = user.totalFollowers.toString()
            self.followingLbl.text = user.totalFollowings.toString()
            self.postLbl.text = user.totalPosts.toString()
            self.removeAnimation()
            self.imgView.kf.indicatorType = .activity
            self.imgView.kf.setImage(with: URL(string: user.dp),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(user.dp)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    @objc func showActionSheett() {
        let alert = UIAlertController.init(title: "Please Select Any One", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (_) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: { (_) in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func openGallery() {
        let img = UIImagePickerController()
        img.delegate = self
        img.allowsEditing = true
        img.sourceType = .photoLibrary
        
        self.present(img, animated: true, completion: nil)
    }
    func openCamera() {
        let img = UIImagePickerController()
        img.delegate = self
        img.allowsEditing = true
        img.sourceType = .camera
        
        self.present(img, animated: true, completion: nil)
    }
    @IBAction func editBtn(_ sender:UIButton) {
        self.showActionSheett()
    }
    
    @IBAction func uploadImg(_ sender:UIButton) {
        self.loadAnimation()
        
    }
}
extension profileVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
        self.imgView.image = img
        picker.dismiss(animated: true) {
            APIManager.sharedInstance.uploadImage(vc: self, img: img) { (str) in
                if str == "success" {
                    self.getCurrentUser()
                }
            }
        }
    }
}
extension profileVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.userCollection {
            return 6
        }
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.userCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! storyCell
            cell.addBtn.cornerRadius(radius: cell.addBtn.frame.height / 2)
            cell.nameLbl.text = "Rock"
            cell.img.cornerRadius(radius: cell.img.frame.height / 2)
            cell.img.kf.indicatorType = .activity
            
            cell.addBtn.isHidden = true
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! galleryCell
        //cell.proImg.cornerRadius(radius: cell.proImg.frame.height / 2)
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
