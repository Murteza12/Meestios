//
//  MediadocslinksVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 02/10/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import UIKit
import Hero

class MediadocslinksVC: RootBaseVC {

    @IBOutlet weak var topCollection:UICollectionView!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    let arr = ["Media","Docs","Links"]
    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topCollection.delegate = self
        self.topCollection.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setSelected(index: selected)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setSelected(index:Int) {
        self.selected = index
        self.topCollection.reloadData()
        
        if index == 0 {
            if self.contentView.subviews.count > 0 {
                for i in self.contentView.subviews {
                    i.removeFromSuperview()
                }
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "MediaViewController") as! MediaViewController
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "MediaViewController") as! MediaViewController
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            }
        } else if index == 1 {
            if self.contentView.subviews.count > 0 {
                for i in self.contentView.subviews {
                    i.removeFromSuperview()
                }
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "DocsViewController") as! DocsViewController
                controller.isDoc = true
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "DocsViewController") as! DocsViewController
                controller.isDoc = true
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            }
        } else if index == 2 {
            if self.contentView.subviews.count > 0 {
                for i in self.contentView.subviews {
                    i.removeFromSuperview()
                }
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "DocsViewController") as! DocsViewController
                controller.isDoc = false
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "DocsViewController") as! DocsViewController
                controller.isDoc = false
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            }
        }
    }
    @IBAction func backAni(_ sender:UIButton) {
//        let redVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customTabbarVC") as! customTabbarVC
//        redVC.isHeroEnabled = true
//        redVC.modalPresentationStyle = .fullScreen
//        redVC.heroModalAnimationType = .zoomSlide(direction: HeroDefaultAnimationType.Direction.right)
//        self.hero_replaceViewController(with: redVC)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchAction(_ sender:UIButton) {

    }
}
extension MediadocslinksVC:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MediadocslinksVCCell
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
        self.setSelected(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width / 3, height: self.topCollection.frame.height)
    }
}
class MediadocslinksVCCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lbl:UILabel!
}
