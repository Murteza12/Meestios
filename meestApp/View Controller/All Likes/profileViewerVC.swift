//
//  profileViewerVC.swift
//  meestApp
//
//  Created by Yash on 9/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class profileViewerVC: RootBaseVC {

    @IBOutlet weak var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}
extension profileViewerVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! profileViewCell
        cell.img.cornerRadius(radius: cell.img.frame.height / 2)
        cell.btn1.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
        cell.btn1.cornerRadius(radius: cell.btn1.frame.height / 2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 128, height: 128)
    }
}
class profileViewCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var nameLbl:UILabel!
}
