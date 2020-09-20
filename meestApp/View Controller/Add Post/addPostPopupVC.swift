//
//  addPostPopupVC.swift
//  meestApp
//
//  Created by Yash on 9/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import YPImagePicker
import AVKit

class addPostPopupVC: RootBaseVC {

    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var tableView:UITableView!
    var selectedItems = [YPMediaItem]()
    let selectedImageV = UIImageView()
    let txtArr = ["Write a Post","Photos","Videos","Feeling/Activity","Camera","Share Location","Go Live"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        self.view1.cornerRadius(radius: 21)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activity" {
            let dvc = segue.destination as! postMainVC
            dvc.selected = "ACTIVITY"
        } else if segue.identifier == "text" {
            let dvc = segue.destination as! postMainVC
            dvc.selected = "POST"
        } else if segue.identifier == "photopost" {
            let dvc = segue.destination as! CreatePostPhotosVC
           // dvc.I_User_Image
        }
    }
    // MARK: - Configuration
    @objc func showPicker() {

            var config = YPImagePickerConfiguration()

            /* Uncomment and play around with the configuration 👨‍🔬 🚀 */

            /* Set this to true if you want to force the  library output to be a squared image. Defaults to false */
    //         config.library.onlySquare = true

            /* Set this to true if you want to force the camera output to be a squared image. Defaults to true */
            // config.onlySquareImagesFromCamera = false

            /* Ex: cappedTo:1024 will make sure images from the library or the camera will be
               resized to fit in a 1024x1024 box. Defaults to original image size. */
            // config.targetImageSize = .cappedTo(size: 1024)

            /* Choose what media types are available in the library. Defaults to `.photo` */
            config.library.mediaType = .photoAndVideo
            config.library.itemOverlayType = .grid
            /* Enables selecting the front camera by default, useful for avatars. Defaults to false */
            // config.usesFrontCamera = true

            /* Adds a Filter step in the photo taking process. Defaults to true */
            // config.showsFilters = false

            /* Manage filters by yourself */
    //        config.filters = [YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
    //                          YPFilter(name: "Normal", coreImageFilterName: "")]
    //        config.filters.remove(at: 1)
    //        config.filters.insert(YPFilter(name: "Blur", coreImageFilterName: "CIBoxBlur"), at: 1)

            /* Enables you to opt out from saving new (or old but filtered) images to the
               user's photo library. Defaults to true. */
            config.shouldSaveNewPicturesToAlbum = false

            /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
            config.video.compression = AVAssetExportPresetMediumQuality

            /* Defines the name of the album when saving pictures in the user's photo library.
               In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName" */
            // config.albumName = "ThisIsMyAlbum"

            /* Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
               Default value is `.photo` */
            config.startOnScreen = .library

            /* Defines which screens are shown at launch, and their order.
               Default value is `[.library, .photo]` */
            config.screens = [.library, .photo, .video]

            /* Can forbid the items with very big height with this property */
    //        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8

            /* Defines the time limit for recording videos.
               Default is 30 seconds. */
            // config.video.recordingTimeLimit = 5.0

            /* Defines the time limit for videos from the library.
               Defaults to 60 seconds. */
            config.video.libraryTimeLimit = 500.0

            /* Adds a Crop step in the photo taking process, after filters. Defaults to .none */
          //  config.showsCrop = .rectangle(ratio: (16/9))

            /* Defines the overlay view for the camera. Defaults to UIView(). */
            // let overlayView = UIView()
            // overlayView.backgroundColor = .red
            // overlayView.alpha = 0.3
            // config.overlayView = overlayView

            /* Customize wordings */
            config.wordings.libraryTitle = "Gallery"

            /* Defines if the status bar should be hidden when showing the picker. Default is true */
            config.hidesStatusBar = false

            /* Defines if the bottom bar should be hidden when showing the picker. Default is false */
            config.hidesBottomBar = false

            config.maxCameraZoomFactor = 2.0

            config.library.maxNumberOfItems = 5
            config.gallery.hidesRemoveButton = false

            /* Disable scroll to change between mode */
            // config.isScrollToChangeModesEnabled = false
    //        config.library.minNumberOfItems = 2

            /* Skip selection gallery after multiple selections */
            // config.library.skipSelectionsGallery = true

            /* Here we use a per picker configuration. Configuration is always shared.
               That means than when you create one picker with configuration, than you can create other picker with just
               let picker = YPImagePicker() and the configuration will be the same as the first picker. */

            /* Only show library pictures from the last 3 days */
            //let threDaysTimeInterval: TimeInterval = 3 * 60 * 60 * 24
            //let fromDate = Date().addingTimeInterval(-threDaysTimeInterval)
            //let toDate = Date()
            //let options = PHFetchOptions()
            // options.predicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", fromDate as CVarArg, toDate as CVarArg)
            //
            ////Just a way to set order
            //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
            //options.sortDescriptors = [sortDescriptor]
            //
            //config.library.options = options

            config.library.preselectedItems = selectedItems


            // Customise fonts
            //config.fonts.menuItemFont = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
            //config.fonts.pickerTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .black)
            //config.fonts.rightBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .bold)
            //config.fonts.navigationBarTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)
            //config.fonts.leftBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)

            let picker = YPImagePicker(configuration: config)

            picker.imagePickerDelegate = self

            /* Change configuration directly */
            // YPImagePickerConfiguration.shared.wordings.libraryTitle = "Gallery2"

            /* Multiple media implementation */
            picker.didFinishPicking { [unowned picker] items, cancelled in

                if cancelled {
                    print("Picker was canceled")
                    picker.dismiss(animated: true, completion: nil)
                    return
                }
                _ = items.map { print("🧀 \($0)") }
                
                self.selectedItems = items
                if let firstItem = items.first {
                    switch firstItem {
                    case .photo(let photo):
                        self.selectedImageV.image = photo.image
                        self.performSegue(withIdentifier: "photopost", sender: self)
                        //picker.dismiss(animated: true, completion: nil)
                    case .video(let video):
                        self.selectedImageV.image = video.thumbnail

                        let assetURL = video.url
                        let playerVC = AVPlayerViewController()
                        let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                        playerVC.player = player

                        picker.dismiss(animated: true, completion: { [weak self] in
                            self?.present(playerVC, animated: true, completion: nil)
                            //print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                        })
                    }
                }
            }

        /* Single Photo implementation. */
        // picker.didFinishPicking { [unowned picker] items, _ in
        //     self.selectedItems = items
        //     self.selectedImageV.image = items.singlePhoto?.image
        //     picker.dismiss(animated: true, completion: nil)
        // }

        /* Single Video implementation. */
        //picker.didFinishPicking { [unowned picker] items, cancelled in
        //    if cancelled { picker.dismiss(animated: true, completion: nil); return }
        //
        //    self.selectedItems = items
        //    self.selectedImageV.image = items.singleVideo?.thumbnail
        //
        //    let assetURL = items.singleVideo!.url
        //    let playerVC = AVPlayerViewController()
        //    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
        //    playerVC.player = player
        //
        //    picker.dismiss(animated: true, completion: { [weak self] in
        //        self?.present(playerVC, animated: true, completion: nil)
        //        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
        //    })
        //}

        present(picker, animated: true, completion: nil)
    }
}
extension addPostPopupVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.txtArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! popupCell
        cell.img.image = UIImage.init(named: "pop" + String(indexPath.row + 1))
        cell.lbl1.text = self.txtArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 {
            self.showPicker()
        } else if indexPath.row == 0 {
            self.performSegue(withIdentifier: "text", sender: self)
        } else if indexPath.row == 3 {
            self.performSegue(withIdentifier: "activity", sender: self)
        } else if indexPath.row == 6 {
            
        }
    }
}
class popupCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var img:UIImageView!
    
}
extension addPostPopupVC: YPImagePickerDelegate {
    func noPhotos() {}

    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true// indexPath.row != 2
    }
}
