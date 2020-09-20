//
//  introVC.swift
//  meestApp
//
//  Created by Yash on 8/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher

class introVC: RootBaseVC {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var nextBtn:UIButton!
    @IBOutlet weak var pagecont:UIPageControl!
    
    var allon = [Onboard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.nextBtn.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getall()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(false, forKey: "launch")
    }
    func getall() {
        APIManager.sharedInstance.geetonboardData(vc: self) { (all) in
            self.allon = all
            self.pagecont.numberOfPages = all.count
            self.collectionView.reloadData()
        }
    }
}
extension introVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allon.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! introCell
        let ind = self.allon[indexPath.item]
        cell.lbl.text = ind.text
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width, height: self.view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pagecont.currentPage = indexPath.row - 1
        
    }
}

class introCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl:UILabel!
    
}
