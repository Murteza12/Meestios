//
//  VCCells.swift
//  meestApp
//
//  Created by Yash on 8/19/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class postCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var dpImage:UIImageView!
    @IBOutlet weak var usernameLbl:UILabel!
    @IBOutlet weak var dropBtn:UIButton!
    @IBOutlet weak var mediaCollection:UICollectionView!
    @IBOutlet weak var captionLbl:UILabel!
    @IBOutlet weak var likeImg1:UIImageView!
    @IBOutlet weak var likeImg2:UIImageView!
    @IBOutlet weak var likeImg3:UIImageView!
    @IBOutlet weak var likeImg4:UIImageView!
    @IBOutlet weak var likeLbl:UILabel!
    @IBOutlet weak var commentshareLbl:UILabel!
    @IBOutlet weak var likeLblCount:UILabel!
    @IBOutlet weak var likeBtn:UIButton!
   // @IBOutlet weak var dislikeBtn:UIButton!
   // @IBOutlet weak var dislikeLblCount:UILabel!
    @IBOutlet weak var commentBtn:UIButton!
    @IBOutlet weak var commentCount:UILabel!
    @IBOutlet weak var collectionHeight:NSLayoutConstraint!
  //  @IBOutlet weak var likeBtn1:AnimatedButton!
    @IBOutlet weak var saveBtn1:AnimatedButton!
    
}

extension postCell {

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        mediaCollection.delegate = dataSourceDelegate
        mediaCollection.dataSource = dataSourceDelegate
        mediaCollection.tag = row
        mediaCollection.setContentOffset(mediaCollection.contentOffset, animated:false) // Stops collection view if it was scrolling.
        mediaCollection.reloadData()
    }

    var collectionViewOffset: CGFloat {
        set { mediaCollection.contentOffset.x = newValue }
        get { return mediaCollection.contentOffset.x }
    }
}

class mediaCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    
}
class storyCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var addBtn:UIButton!
    @IBOutlet weak var nameLbl:UILabel!
    
}
