//
//  RootBaseVC.swift
//  meestApp
//
//  Created by Yash on 8/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import JitsiMeet

class RootBaseVC: UIViewController {

    let animationView = AnimationView()
    fileprivate var jitsiMeetView: JitsiMeetView?
    var blurEffectView = UIVisualEffectView()
   // var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
      //  self.getprofile(completion: (User) -> Void)
        NotificationCenter.default.addObserver(self, selector: #selector(forwardToCallAudio), name: NSNotification.Name("forwardToAudioCall"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(forwardToCallVideo), name: NSNotification.Name("forwardToVideoCall"), object: nil)
        
    }

    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func loadAnimation() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.blurEffectView = UIVisualEffectView(effect:blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let animation = Animation.named(Themes.animationName)
        animationView.frame = CGRect(x: 140, y: 240, width: 100, height: 100)
        //Don't forget this line
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
        let height = NSLayoutConstraint(item: animationView,attribute: .height,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute,multiplier: 1.0,constant: 100.0)
        let width = NSLayoutConstraint(item: animationView,attribute: .width,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute,multiplier: 1.0,constant: 100.0)
        
        animationView.addConstraint(height)
        animationView.addConstraint(width)

        animationView.layer.cornerRadius = 15
        animationView.clipsToBounds = true
        animationView.animation = animation
       // animationView.contentMode =
        animationView.backgroundColor = .white
        animationView.loopMode = .loop
        animationView.play()
        
    }
    @objc func forwardToCallAudio() {
        let room: String = UserDefaults.standard.string(forKey: "roomid") ?? ""
        
        // create and configure jitsimeet view
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = false
            builder.room = room
            builder.videoMuted = true
            builder.userInfo?.displayName = Token.sharedInstance.getUsername()
        }
        
        // setup view controller
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view = jitsiMeetView
        
        // join room and display jitsi-call
        jitsiMeetView.join(options)
        self.present(vc, animated: true, completion: nil)
    }
    @objc func forwardToCallVideo() {
        let room: String = UserDefaults.standard.string(forKey: "roomid") ?? ""
           
        // create and configure jitsimeet view
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.welcomePageEnabled = false
            builder.room = room
            builder.videoMuted = false
            builder.userInfo?.displayName = Token.sharedInstance.getUsername()
        }
           
           // setup view controller
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view = jitsiMeetView
        if (self.jitsiMeetView == nil) {
            jitsiMeetView.join(options)
        }
           // join room and display jitsi-call
        
        self.present(vc, animated: true, completion: nil)
    }
    func removeAnimation() {
        self.blurEffectView.removeFromSuperview()
        self.animationView.removeFromSuperview()
    }
//    func getprofile(completion:@escaping (User) -> Void) {
//        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
//
//            completion(user)
//        }
//    }
}
extension RootBaseVC:JitsiMeetViewDelegate {
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        cleanUp()
    }
    fileprivate func cleanUp() {
        if(jitsiMeetView != nil) {
            dismiss(animated: true, completion: nil)
            jitsiMeetView = nil
        }
    }
}
