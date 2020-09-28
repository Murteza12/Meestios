//
//  mssengerHomeVC.swift
//  meestApp
//
//  Created by Yash on 8/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import UIKit
import Hero

class mssengerHomeVC: RootBaseVC {

    @IBOutlet weak var topCollection:UICollectionView!
    @IBOutlet weak var contentView:UIView!
    
    let arr = ["PEOPLES","GROUPS","CALLS"]
    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.topCollection.delegate = self
      //  self.topCollection.dataSource = self
        UserDefaults.standard.setValue(0, forKey: "SelectedIndex")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        let index = UserDefaults.standard.integer(forKey: "SelectedIndex")
        self.setSelected(index: index)
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
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "peoplesVC") as! peoplesVC
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "peoplesVC") as! peoplesVC
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
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "groupsVC") as! groupsVC
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "groupsVC") as! groupsVC
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
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "callsVC") as! callsVC
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "callsVC") as! callsVC
                addChild(controller)
                self.contentView.addSubview(controller.view)
                controller.view.frame = self.contentView.bounds
                controller.view.layoutIfNeeded()
                controller.didMove(toParent: self)
            }
        }
    }
    @IBAction func backAni(_ sender:UIButton) {
        let redVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customTabbarVC") as! customTabbarVC
        redVC.isHeroEnabled = true
        redVC.modalPresentationStyle = .fullScreen
        redVC.heroModalAnimationType = .zoomSlide(direction: HeroDefaultAnimationType.Direction.right)
        self.hero_replaceViewController(with: redVC)
    }
}
extension mssengerHomeVC:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! messagehomeCell
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
        UserDefaults.standard.setValue(indexPath.row, forKey: "SelectedIndex")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width / 3, height: self.topCollection.frame.height)
    }
}
class messagehomeCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lbl:UILabel!
}
