//
//  presentVC.swift
//  meestApp
//
//  Created by Yash on 8/27/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Player

class videoHomeVC: RootBaseVC {

    @IBOutlet weak var collectionView:UICollectionView!
    var string = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.string.append("https://www.dropbox.com/s/0x2ke57h7wv49ll/Sample_512x288.mp4")
        self.string.append("https://www.dropbox.com/s/0x2ke57h7wv49ll/Sample_512x288.mp4")
        self.string.append("https://www.dropbox.com/s/0x2ke57h7wv49ll/Sample_512x288.mp4")
    }
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
}

extension videoHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.string.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! videoHomeCell
        cell.player.playerDelegate = self
        cell.player.playbackDelegate = self
        
        cell.videoView.addSubview(cell.player.view)
        cell.player.url = URL.init(string: self.string[indexPath.row])!
        cell.player.playbackLoops = true
        cell.videoView.backgroundColor = .black
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:player:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.player.view.addGestureRecognizer(tapGestureRecognizer)
        DispatchQueue.main.async {
            cell.player.playFromBeginning()
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = collectionView.frame.size
        return frame
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
    }
}
extension videoHomeVC {
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer,player:Player) {
        
        switch player.playbackState {
        case .stopped:
            player.playFromBeginning()
            break
        case .paused:
            player.playFromCurrentTime()
            break
        case .playing:
            player.pause()
            break
        case .failed:
            player.pause()
            break
        }
    }
}
extension videoHomeVC: PlayerDelegate, PlayerPlaybackDelegate {
    
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
}

class videoHomeCell:UICollectionViewCell {
    
    @IBOutlet weak var videoView:UIView!
    var player = Player()
}
