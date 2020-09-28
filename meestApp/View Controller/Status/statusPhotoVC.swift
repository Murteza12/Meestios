//
//  statusPhotoVC.swift
//  meestApp
//
//  Created by Yash on 9/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class statusPhotoVC: RootBaseVC {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var upImageView: UIImageView!
    var story: Story?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setImage(UIImage(named: "back"), for: .normal)
        replyButton.setTitle("Reply", for: .normal)
        replyButton.titleLabel?.font = UIFont.init(name: APPFont.semibold, size: 22)
        replyButton.setTitleColor(.white, for: .normal)
        nameLabel.font = UIFont.init(name: APPFont.semibold, size: 19)
        nameLabel.textColor = .white
        lastUpdateLabel.font = UIFont.init(name: APPFont.semibold, size: 12)
        lastUpdateLabel.textColor = .white
        captionLabel.font = UIFont.init(name: APPFont.semibold, size: 15)
        captionLabel.textColor = .white
        upImageView.setImage(UIImage(named: "up")!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.nameLabel.text = (story?.storyUSer.firstName ?? "") + " " + (story?.storyUSer.lastName ?? "")
        self.nameLabel.text = story?.storyUSer.username ?? ""
        self.captionLabel.text = story?.caption ?? ""
        self.lastUpdateLabel.text = story?.createdAt ?? ""
        self.storyImageView.kf.indicatorType = .activity
        self.storyImageView.kf.setImage(with: URL(string: story?.storyUSer.displayPicture),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(self.story?.storyUSer.displayPicture as Any)
                print("Job failed: \(error.localizedDescription)")
                
            }
        }

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func replyButtonAction(_ sender: Any) {
    }
    
}
extension statusPhotoVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusPhotoCell", for: indexPath) as! StatusPhotoCell
        return cell
    }
    
    
}

class StatusPhotoCell: UICollectionViewCell{
    @IBOutlet weak var statusView: UIView!
    
}
