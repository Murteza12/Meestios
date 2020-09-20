//
//  splashVC.swift
//  meestApp
//
//  Created by Yash on 8/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import SwiftyGif
import Firebase

class splashVC: RootBaseVC {

  //  @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var video:VideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.img.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Token.sharedInstance.getToken() != "" {
            InstanceID.instanceID().instanceID { (result, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    print(result?.token)
                    APIManager.sharedInstance.fcmupdatee(fcmToken: result?.token ?? "")
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      // let gif = try! UIImage(gifName: "ezgif.com-crop.gif")
      //  self.img.setGifImage(gif, loopCount: 1)
        self.video.configure(url: "https://firebasestorage.googleapis.com/v0/b/meestapp-21438.appspot.com/o/logo%20animation.mp4?alt=media&token=ba24ed05-e107-4544-8de0-e02d43ce96a7")
        self.video.isLoop = false
        self.video.play()
        NotificationCenter.default.addObserver(self, selector: #selector(playerStopped), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//        let launch = UserDefaults.standard.bool(forKey: "launch")
//        if Token.sharedInstance.getToken() != "" {
//            
//            self.performSegue(withIdentifier: "token", sender: self)
//        } else if launch == true {
//            self.performSegue(withIdentifier: "proceed", sender: self)
//        } else {
//            self.performSegue(withIdentifier: "proceed", sender: self)
//        }
    }
    @objc func playerStopped() {
        self.video.player = nil
        let launch = UserDefaults.standard.bool(forKey: "launch")
        if Token.sharedInstance.getToken() != "" {
            
            self.performSegue(withIdentifier: "token", sender: self)
        } else if launch == true {
            self.performSegue(withIdentifier: "proceed", sender: self)
        } else {
            self.performSegue(withIdentifier: "proceed", sender: self)
        }
    }
}
//extension splashVC: SwiftyGifDelegate {
//    func gifDidStop(sender: UIImageView) {
//        let launch = UserDefaults.standard.bool(forKey: "launch")
//        if Token.sharedInstance.getToken() != "" {
//            
//            self.performSegue(withIdentifier: "token", sender: self)
//        } else if launch == true {
//            self.performSegue(withIdentifier: "proceed", sender: self)
//        } else {
//            self.performSegue(withIdentifier: "proceed", sender: self)
//        }
//    }
//}
