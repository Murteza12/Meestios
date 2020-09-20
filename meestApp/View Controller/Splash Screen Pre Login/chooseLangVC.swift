//
//  chooseLangVC.swift
//  meestApp
//
//  Created by Yash on 8/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher

class chooseLangVC: RootBaseVC {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var headerVIew:UIView!
    var allLang = [Language]()
    var selectedLang = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.headerVIew.addBottomBorderWithColor(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1), width: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllLang()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
        self.continueBtn.cornerRadius(radius: 10)
    }
    func getAllLang() {
        APIManager.sharedInstance.getAllLang(vc: self) { (all) in
            self.allLang = all
            self.collectionView.reloadData()
        }
    }
}
extension chooseLangVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allLang.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! langCell
        let ind = self.allLang[indexPath.row]
        cell.view1.cornerRadius(radius: 8)
        print(self.allLang[indexPath.row].languageNameEnglish)
        print(self.selectedLang)
        if self.selectedLang == self.allLang[indexPath.row].languageNameEnglish {
            
//            let gradient = CAGradientLayer()
//            gradient.frame =  CGRect(origin: CGPoint.zero, size: cell.view1.frame.size)
//            gradient.colors = [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)]
//
//            let shape = CAShapeLayer()
//            shape.lineWidth = 2
//            shape.path = UIBezierPath(rect: cell.view1.bounds).cgPath
//            shape.strokeColor = UIColor.black.cgColor
//            shape.fillColor = UIColor.blue.cgColor
//            gradient.mask = shape
//
//            cell.view1.layer.addSublayer(gradient)
            
            cell.view1.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
        } else {
           // cell.view1.applyGradient(with:  [UIColor.white,UIColor.white,UIColor.white], gradient: .horizontal)
        }
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: ind.image),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(ind.image)
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        cell.engLbl.text = ind.languageNameEnglish
        cell.lbl.text = ind.languageNameNative
        cell.img.cornerRadius(radius: 10)
        cell.lblView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionView.frame.width / 2 - 20, height: self.collectionView.frame.height / 4 - 20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedLang = self.allLang[indexPath.row].languageNameEnglish
        self.collectionView.reloadData()
        
    }
}

class langCell:UICollectionViewCell {
    
    @IBOutlet weak var lbl:UILabel!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lblView:UIView!
    @IBOutlet weak var engLbl:UILabel!
    
}
