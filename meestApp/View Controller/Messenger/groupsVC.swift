//
//  groupsVC.swift
//  meestApp
//
//  Created by Yash on 8/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class groupsVC: RootBaseVC {
    
    @IBOutlet weak var tableVIew:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
    }
}

extension groupsVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! createCell
            
            cell.view1.cornerRadius(radius: 8)
            cell.view1.layer.borderWidth = 0.5
            cell.view1.layer.borderColor = UIColor.lightGray.cgColor
            cell.createBtn.cornerRadius(radius: cell.createBtn.frame.height / 2)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! groupCell
        cell.onlineView.cornerRadius(radius: cell.onlineView.frame.height / 2)
        cell.proImg.cornerRadius(radius: cell.proImg.frame.height / 2)
        cell.img1.cornerRadius(radius: cell.img1.frame.height / 2)
        cell.img2.cornerRadius(radius: cell.img2.frame.height / 2)
        cell.img3.cornerRadius(radius: cell.img3.frame.height / 2)
        cell.img4.cornerRadius(radius: cell.img4.frame.height / 2)
        
        cell.view1.cornerRadius(radius: 8)
        cell.view1.layer.borderWidth = 0.5
        cell.view1.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.tableVIew.frame.width / 2 - 20, height: self.tableVIew.frame.height / 2.7)
    }
    // removing spacing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

class groupCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var shadowview:UIView!
    @IBOutlet weak var strBtn:UIButton!
    @IBOutlet weak var optionBtn:UIButton!
    @IBOutlet weak var proImg:UIButton!
    @IBOutlet weak var groupName:UILabel!
    @IBOutlet weak var onlineView:UIView!
    
    @IBOutlet weak var img1:UIImageView!
    @IBOutlet weak var img2:UIImageView!
    @IBOutlet weak var img3:UIImageView!
    @IBOutlet weak var img4:UIImageView!
    
}
class createCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var shadowview:UIView!
    
    @IBOutlet weak var createBtn:UIButton!
    
}
