//
//  videoViewerVC.swift
//  meestApp
//
//  Created by Yash on 9/2/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import AVKit
import AVFoundation

class videoViewerVC: UIViewController {
    
    @IBOutlet weak var followingBtn:UIButton!
    @IBOutlet weak var forBtn:UIButton!
    @IBOutlet weak var liveBtn:UIButton!
    
    @IBOutlet weak var HomeCollectionView: UICollectionView!
  

    private var dataSource : CollectionViewDataSource<HomeCollectionViewCell, Videos>!
    private var viewmodel :VideosModel!
    let videoBackground1 = VideoBackground()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.viewmodel = VideosModel()
        initViews()
        updateDataSource()
        // Do any additional setup after loading the view.
        self.followingBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 17)
        self.forBtn.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
        self.liveBtn.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
    }
    

    private func updateDataSource() {
        
        self.dataSource = CollectionViewDataSource(cellIdentifier: "HomeCollectionViewCell", items: self.viewmodel.videos, configureCell: { (cell, data) in
            
            let url = URL(string: data.videoURL)!
           VideoBackground.shared.play(view: cell.videplayer, url: url)
            
            cell.userProfile.cornerRadius(radius: cell.userProfile.frame.height / 2)
            cell.userProfile.layer.borderColor = UIColor.white.cgColor
            cell.userProfile.layer.borderWidth = 1
//            cell.totalComment.text = "\(data.commentCount)"
//            cell.totalLikes.text =  "\(data.likesCount)"
//            cell.userName.text = data.userName
//            cell.userVideodiscription.text = data.videoDiscription
//            cell.playingSong.text = data.songTitle
//            cell.userProfile.image =  LetterImageGenerator.imageWith(name: data.userName)
//            cell.diskIcon.startRotating()
        })
        
        self.HomeCollectionView.dataSource = self.dataSource
        self.HomeCollectionView.reloadData()
    }

    
    func initViews(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        HomeCollectionView.isPagingEnabled = true
        HomeCollectionView.setCollectionViewLayout(layout, animated: true)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 19),
            .foregroundColor: UIColor.lightGray
        ]
        let selectedAtributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 19),
            .foregroundColor: UIColor.white
        ]
    }
    @IBAction func backAni(_ sender:UIButton) {
        let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customTabbarVC") as! customTabbarVC
        greenVC.isHeroEnabled = true
        greenVC.modalPresentationStyle = .fullScreen
        greenVC.heroModalAnimationType = .zoomOut
        self.hero_replaceViewController(with: greenVC)
    }
    @IBAction func followingBtnPressed(_ sender:UIButton) {
        self.followingBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 17)
        self.forBtn.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
        self.liveBtn.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
    }
    
    @IBAction func forBtnPressed(_ sender:UIButton) {
        self.followingBtn.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
        self.forBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 17)
        self.liveBtn.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
    }
    
    @IBAction func liveBtnPressed(_ sender:UIButton) {
        self.followingBtn.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
        self.forBtn.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
        self.liveBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 17)
    }

}
extension videoViewerVC : UICollectionViewDelegateFlowLayout ,UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return self.HomeCollectionView.frame.size;
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        
        //VideoBackground.shared.play(view: (cell?.videplayer)!, url: URL(string: self.viewmodel.videos[indexPath.item].videoURL)!)
    }

    
   
}


extension UIView {
    func startRotating(duration: Double = 1) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userVideodiscription: UILabel!
    
   
   
    
    @IBOutlet weak var videplayer: UIView!
    
   
    @IBOutlet weak var totalLikes: UILabel!
    
    @IBOutlet weak var totalComment: UILabel!
    
    
    @IBOutlet weak var userProfile: UIImageView!
    
    @IBOutlet weak var likeIcon: UIButton!
    
    @IBOutlet weak var commentIcon: UIButton!
    
    @IBOutlet weak var shareIcon: UIButton!
    
    
    //@IBOutlet weak var diskIcon: UIImageView!
    
    @IBOutlet weak var playingSong: UILabel!
    
    
}
class CollectionViewDataSource<Cell :UICollectionViewCell,model> : NSObject, UICollectionViewDataSource {
    
    private var cellIdentifier :String!
    private var items :[model]!
    var configureCell :(Cell,model) -> ()
    
    init(cellIdentifier :String, items :[model], configureCell: @escaping (Cell,model) -> ()) {
        
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! Cell
        let item = self.items[indexPath.row]
        self.configureCell(cell,item)
        
        return cell
    }
    
  /**
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + 300)
        
    }
    **/
}
class LetterImageGenerator: NSObject {
    class func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor(hue: 0.0139, saturation: 0.74, brightness: 0.9, alpha: 1.0)
        nameLabel.textColor = .white
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first {
                    initials += String(lastLetter).capitalized
                }
            }
        } else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
}
