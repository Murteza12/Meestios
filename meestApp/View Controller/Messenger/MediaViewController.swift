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
    var searchCopy = [MockMessage]()
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
            fileName.fileURL.lowercased().contains(text.lowercased())
        })
        self.collection.reloadData()
    }
    
    func segregateDate(){
        let messageDate =  Dictionary(grouping: docData) { (element) -> String in
            element.createdAt
        }
    }

}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: self.view.frame.size.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MediaHeaderReusableView", for: indexPath) as! MediaHeaderReusableView
//           headerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 30)

           // MOVE THE COMMENTED LINE TO YOUR HeaderDiscoverVC
           //headerView.backgroundColor = UIColor.hex("d9e2e7")
         
//            headerView.sectionName.text = "Last Week"
           // MOVE THE COMMENTED LINES TO YOUR HeaderDiscoverVC
//            headerView.sectionName.font = UIFont.init(name: APPFont.regular, size: 16)
           //label.font = UIFont(name: Fonts.OpenSans_Bold, size: 16)
           //label.textColor = UIColor.hex("8a9da6")
           //headerView.addSubview(label)
           return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchCopy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MediaViewControllerCell
        
        cell.img.kf.setImage(with: URL(string: self.searchCopy[indexPath.row].fileURL))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collection.frame.width / 4, height: self.collection.frame.height/4)
    }
    
    
}

class MediaViewControllerCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
}

class MediaHeaderReusableView: UICollectionReusableView{
    @IBOutlet weak var sectionName: UILabel!
    
}
