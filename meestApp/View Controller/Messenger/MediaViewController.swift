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
    
    var docData = [[MockMessage]]()
    var searchCopy = [[MockMessage]]()
    var chatHeadImage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collection.register(MediaHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MediaHeaderReusableView")
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
                self.searchCopy = self.docData
                self.collection.reloadData()
            }else{
                let act = UIAlertController.init(title: "Error", message: "Error in getting data", preferredStyle: .alert)
                act.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (_) in
                    
                }))
                self.present(act, animated: true, completion: nil)
            }
        }
    }
    
    func search(text: String){
        print(text)
        
        guard !text.isEmpty else {
            searchCopy = docData
            collection.reloadData()
            return
        }
        
        searchCopy =  docData.filter({ (fileName) -> Bool in
            var value: Bool?
            for i in fileName{
                value = i.fileURL.lowercased().contains(text.lowercased())
            }
            return value!
        })
        self.collection.reloadData()
    }
}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchCopy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: self.view.frame.size.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MediaHeaderReusableView", for: indexPath) as! MediaHeaderReusableView
//        headerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 30)
        
        headerView.backgroundColor = UIColor.init(red: 0.667, green: 0.667, blue: 0.667, alpha: 0.2)
        let rect = CGRect(x: 28, y: 0, width: collectionView.frame.width, height: 20)
        let sectionName = UILabel(frame: rect)
        sectionName.text = self.searchCopy[indexPath.section][indexPath.row].category
        sectionName.font = UIFont.init(name: APPFont.regular, size: 16)
        headerView.addSubview(sectionName)
        
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchCopy[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MediaViewControllerCell
        let image = self.searchCopy[indexPath.section][indexPath.row]
        cell.img.kf.setImage(with: URL(string: image.fileURL))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collection.frame.width / 5, height: 100)
    }
    
    
}

class MediaViewControllerCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
}

class MediaHeaderReusableView: UICollectionReusableView{
    @IBOutlet weak var sectionName: UILabel!
    
}
