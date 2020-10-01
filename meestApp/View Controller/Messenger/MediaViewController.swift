//
//  MediaViewController.swift
//  meestApp
//
//  Created by Rahul Kashyap on 02/10/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher

class MediaViewController: RootBaseVC {

    @IBOutlet weak var collection: UICollectionView!
    var docData = [MockMessage]()
    var chatHeadImage = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collection.delegate = self
        self.collection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chatHeadImage = UserDefaults.standard.string(forKey: "ChatHeadId") ?? ""
        let parameter = ["chatHeadId": self.chatHeadImage, "attachmentType": "Image"]
        APIManager.sharedInstance.getMediaLinksAndDocs(vc: self, para: parameter) { (doc, str) in
            if str == "success"{
                self.docData = doc
                self.collection.reloadData()
            }else{
                let act = UIAlertController.init(title: "Error", message: "Error in getting data", preferredStyle: .alert)
                act.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
                    
                }))
                self.present(act, animated: true, completion: nil)
            }
        }
    }

}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return docData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MediaViewControllerCell
        
        cell.img.kf.setImage(with: URL(string: self.docData[indexPath.row].fileURL))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collection.frame.width / 3, height: self.collection.frame.height/4)
    }
    
    
}

class MediaViewControllerCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
}
