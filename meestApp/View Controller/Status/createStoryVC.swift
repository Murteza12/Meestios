//
//  createStoryVC.swift
//  meestApp
//
//  Created by Yash on 9/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Photos

class createStoryVC: RootBaseVC {

    var allPhotos : PHFetchResult<PHAsset>? = nil
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var textView:UIView!
    @IBOutlet weak var selfieView:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Load Photos
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.collectionView.reloadData()
                }
                
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            @unknown default:
                fatalError()
            }
        }
        self.textView.cornerRadius(radius: 8)
        self.selfieView.cornerRadius(radius: 8)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.applyGradient(with: [ UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1), UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1)], gradient: .vertical)
        self.selfieView.applyGradient(with: [ UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1), UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1)], gradient: .vertical)
    }
}
extension createStoryVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.allPhotos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! galleryCell
        cell.img.fetchImage(asset: self.allPhotos![indexPath.row], contentMode: .aspectFill, targetSize: cell.img.frame.size)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width / 3, height: 128)
    }
}
extension UIImageView{
 func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
    let options = PHImageRequestOptions()
    options.version = .original
    PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
        guard let image = image else { return }
        switch contentMode {
        case .aspectFill:
            self.contentMode = .scaleAspectFill
        case .aspectFit:
            self.contentMode = .scaleAspectFit
        @unknown default:
            fatalError()
        }
        self.image = image
        }
    }
}
class galleryCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
}
