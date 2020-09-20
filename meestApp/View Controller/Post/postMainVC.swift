//
//  postMainVC.swift
//  meestApp
//
//  Created by Yash on 9/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class postMainVC: RootBaseVC {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var contentView:UIView!
    var selected = ""
    let posts = ["POST","ACTIVITY","LIVE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.selected(type: "POST")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.selected(type: self.selected)
        self.collectionView.reloadData()
    }
    func selected(type:String) {
        self.selected = type
        if type == "POST" {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "createTxtPostVC") as! createTxtPostVC
            addChild(controller)
            self.contentView.addSubview(controller.view)
            controller.view.frame = self.contentView.bounds
            controller.view.layoutIfNeeded()
            controller.didMove(toParent: self)
        } else if type == "PHOTOS" {
            
        } else if type == "VIDEOS" {
            
        } else if type == "ACTIVITY" {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "feelingVC") as! feelingVC
            addChild(controller)
            self.contentView.addSubview(controller.view)
            controller.view.frame = self.contentView.bounds
            controller.view.layoutIfNeeded()
            controller.didMove(toParent: self)
        } else if type == "CAMERA" {
            
        } else if type == "LIVE" {
            
        }
    }
}
extension postMainVC:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! postMainCell
        cell.lbl1.text = self.posts[indexPath.row]
        if self.selected == self.posts[indexPath.row] {
            cell.lbl1.font = UIFont.init(name: APPFont.bold, size: 14)
            cell.lbl1.textColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else {
            cell.lbl1.font = UIFont.init(name: APPFont.semibold, size: 14)
            cell.lbl1.textColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected = self.posts[indexPath.row]
        self.selected(type: self.selected)
        self.collectionView.reloadData()
    }
}

class postMainCell:UICollectionViewCell {
    
    @IBOutlet weak var lbl1:UILabel!
    
}
