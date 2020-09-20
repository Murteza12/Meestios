//
//  chooseIntrestVC.swift
//  meestApp
//
//  Created by Yash on 8/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class chooseIntrestVC: RootBaseVC {

    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var errorLbl:UILabel!
    var all = [Topics]()
    var selected = [String]()
    var selectedid = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.errorLbl.text = ""
        
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        collectionView.collectionViewLayout = layout
        
        self.continueBtn.cornerRadius(radius: 10)
        
        self.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllTopic()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    func getAllTopic() {
        APIManager.sharedInstance.getAllTopic(vc: self) { (all) in
            self.all = all
            self.collectionView.reloadData()
        }
    }
    @IBAction func cintinue(_ sender:UIButton) {
        if selected.count == 0 {
            self.errorLbl.text = "Please select any topic as per your Interest"
        } else {
            APIManager.sharedInstance.submitTopic(vc: self, topic: self.selectedid) { (str) in
                if str == "success" {
                    self.performSegue(withIdentifier: "proceed", sender: self)
                }
            }
        }
    }
}
extension chooseIntrestVC:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.all.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell",
                                                            for: indexPath) as? RoundedCollectionViewCell else {
                                    return RoundedCollectionViewCell()
        }
        cell.textLabel.numberOfLines = 0
        cell.textLabel.text = self.all[indexPath.row].topic
        if self.selected.contains(self.all[indexPath.row].topic) {
            cell.textLabel.textColor = UIColor.white
            cell.view1.backgroundColor = UIColor(red: 0.231, green: 0.349, blue: 0.596, alpha: 1)
        } else {
            cell.textLabel.textColor = UIColor.lightGray
            cell.view1.backgroundColor = .clear
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected.append(self.all[indexPath.row].topic)
        self.selectedid.append(self.all[indexPath.row].id)
        self.collectionView.reloadData()
    }
    
}
class RoundedCollectionViewCell: UICollectionViewCell {
    @IBOutlet var textLabel: UILabel!
    @IBOutlet weak var view1:RoundedView!
}
