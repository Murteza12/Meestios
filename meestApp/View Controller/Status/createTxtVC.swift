//
//  createTxtVC.swift
//  meestApp
//
//  Created by Yash on 9/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class createTxtVC: RootBaseVC {

    @IBOutlet weak var fontBtn:UIButton!
    @IBOutlet weak var backgroundBtn:UIButton!
    @IBOutlet weak var collectionView:UICollectionView!
    var colors = [[UIColor]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.colors.append([UIColor(red: 0.231, green: 0.349, blue: 0.596, alpha: 1), UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1) ])
        self.colors.append([UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1), UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1) ])
        self.colors.append([UIColor(red: 0.973, green: 0.78, blue: 0.337, alpha: 1),UIColor(red: 0.601, green: 0.725, blue: 0.573, alpha: 1),UIColor(red: 0, green: 0.635, blue: 0.953, alpha: 1)])
        self.colors.append([UIColor(red: 1, green: 0.859, blue: 0.263, alpha: 1),UIColor(red: 0.988, green: 0.141, blue: 0.278, alpha: 1)])
        self.colors.append([ UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1), UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1)])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.applyGradient(with: [ UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1), UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1)], gradient: .vertical)
        self.backgroundBtn.applyGradient(with: [ UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1), UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1)], gradient: .vertical)
        self.backgroundBtn.layer.borderWidth = 1
        self.backgroundBtn.layer.borderColor = UIColor.white.cgColor
        self.backgroundBtn.cornerRadius(radius: self.backgroundBtn.frame.height / 2)
        
        self.fontBtn.layer.borderWidth = 1
        self.fontBtn.layer.borderColor = UIColor.white.cgColor
        self.fontBtn.cornerRadius(radius: self.fontBtn.frame.height / 2)
    }
}

extension createTxtVC:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! galleryCell
        cell.img.applyGradient(with: self.colors[indexPath.row], gradient: .vertical)
        cell.img.layer.borderColor = UIColor.white.cgColor
        cell.img.layer.borderWidth = 1
        cell.img.cornerRadius(radius: cell.img.frame.height / 2)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.applyGradient(with: self.colors[indexPath.row], gradient: .vertical)
        
    }
}
