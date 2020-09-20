//
//  createPhotoPostVC.swift
//  meestApp
//
//  Created by Yash on 9/14/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class CreatePostPhotosVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var Collection: UICollectionView!
    @IBOutlet weak var txt_Caption: UITextView!
    @IBOutlet weak var I_User_Image: UIImageView!
    var img:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.I_User_Image.image = self.img
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    // MARK: - button
    
    @IBAction func btn_back(_ sender: Any) {
        
    }
    @IBAction func btn_tag_People(_ sender: Any) {
        
    }
    
    @IBAction func btn_Add_Location(_ sender: Any) {
        
    }
    
    @IBAction func S_Turn_On_Commention(_ sender: Any) {
        
    }
    
    // MARK - CollcetionView Delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_AddLocation", for: indexPath) as! Cell_AddLocation
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
class Cell_AddLocation: UICollectionViewCell {
    
    @IBOutlet weak var lbl_LocationName: UILabel!
}
