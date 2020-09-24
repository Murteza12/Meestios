//
//  msgSendView.swift
//  meestApp
//
//  Created by Yash on 8/28/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import GrowingTextView
import SocketIO
import AVKit

class msgSendView: UIView {
    
    var audioRecorder: AVAudioRecorder!
    var audioFilename: URL!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    
    var toUser:ChatHeads?
    var userid = ""
//    var attachmentButtonClicked : (()->())?
    var socket:SocketIOClient!
    
    @IBOutlet weak var textView: GrowingTextView!  {
        didSet {
            textView.delegate = self
            textView.text = "Type your message"
            textView.textColor = UIColor.gray
        }
    }
    @IBOutlet weak var sendBtn:UIButton! {
        didSet {
            sendBtn.cornerRadius(radius: sendBtn.frame.height / 2)
        }
    }
    @IBOutlet weak var view1:UIView! {
        didSet {
            view1.cornerRadius(radius: view1.frame.height / 2)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    @IBAction func btnSendActino(_ sender: Any) {
        if sendBtn.currentImage == UIImage(named: "navigation"){
            if self.textView.text != ""{
                let new = ["msg" : (self.textView.text ?? "").encode(),
                           "chatHeadId" : self.toUser?.chatHeadId ?? "",
                           "userId": self.userid ,
                           "attachment":false,"attachmentType":"","fileURL":""] as [String : Any]
                self.textView.text = ""
                print(new)
                self.socket.emit("send", new)
//                let neww = ["userId":self.userid,"chatHeadId":self.toUser?.chatHeadId ?? ""] as [String : Any]
//                self.socket.emit("get_history", neww)
            }
        }else{
            self.enableZoom()
        }
    }
    
    @IBAction func btnAttachmentAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "attachmentButtonClicked"), object: nil)
        
    }
    
    @IBAction func btnSmileyAction(_ sender: Any) {
        textView.becomeFirstResponder()
    }
    //MARK:- for iPhoneX Spacing bottom
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
}

extension msgSendView {
  // Performs the initial setup.
    private func setupView() {
        
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    
        textView.translatesAutoresizingMaskIntoConstraints = false
        
            self.socket = APIManager.sharedInstance.getSocket()
            APIManager.sharedInstance.getCurrentUser(vc: UIViewController()) { (user) in
                self.userid = user.id
            }
        
        switch AVAudioSession.sharedInstance().recordPermission {
               case AVAudioSessionRecordPermission.granted:
                   isAudioRecordingGranted = true
                   break
               case AVAudioSessionRecordPermission.denied:
                   isAudioRecordingGranted = false
                   break
               case AVAudioSessionRecordPermission.undetermined:
                   AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                       DispatchQueue.main.async {
                           if allowed {
                               self.isAudioRecordingGranted = true
                           } else {
                               self.isAudioRecordingGranted = false
                           }
                       }
                   }
                   break
               default:
                   break
               }
    }
  
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}
//MARK:- GrowingTextView Delegate for dynamic height increase according to text
extension msgSendView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        // invalidateIntrinsicContentSize()
        // https://developer.apple.com/documentation/uikit/uiview/1622457-invalidateintrinsiccontentsize
        // to reflect height changes
        textView.invalidateIntrinsicContentSize()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.sendTypingEmit()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            self.sendBtn.setImage(UIImage.init(named: "microphone"), for: .normal)
        } else {
            self.sendBtn.setImage(UIImage.init(named: "navigation"), for: .normal)
        }

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type your message"
            textView.textColor = UIColor.gray
        } else {
//            self.sendBtn.setImage(UIImage.init(named: "navigation"), for: .normal)
            textView.textColor = UIColor.black
            textView.text = ""
        }
    }
    
    func sendTypingEmit(){
        let new = ["userId":self.userid,"chatHeadId":self.toUser?.chatHeadId ?? ""] as [String : Any]
        self.socket.emit("typing", new)
        isSender = true

    }
}

class EmojiTextField: UITextView {

   // required for iOS 13
   override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}

extension msgSendView {
  func enableZoom() {
    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
    self.sendBtn.addGestureRecognizer(longGesture)

  }
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.sendBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
                if self.isAudioRecordingGranted{
                    self.finishAudioRecording(success: true)
                }

                    }, completion: {(_ finished: Bool) -> Void in
                    })
            
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.sendBtn.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                if self.isAudioRecordingGranted{
                    self.audioRecorderAction()
                }
                    }, completion: {(_ finished: Bool) -> Void in
                        
                    })
        }
    }
}

extension msgSendView : AVAudioRecorderDelegate{
    
    func audioRecorderAction(){
            if isAudioRecordingGranted {

                //Create the session.
                let session = AVAudioSession.sharedInstance()

                do {
                    //Configure the session for recording and playback.
                    try session.setCategory(.playAndRecord, mode: .default, options: [])
                    try session.setActive(true)

                    //Set up a session
                    let settings = [
                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 44100,
                        AVNumberOfChannelsKey: 2,
                        AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
                    ]

                    //file name URL
                    audioFilename = getDocumentsDirectory().appendingPathComponent("audio.m4a")

                    //Create the audio recording, and assign ourselves as the delegate
                    audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                    audioRecorder.delegate = self
                    audioRecorder.isMeteringEnabled = true
                    audioRecorder.record()
                    meterTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(self.updateAudioTimer(timer:)), userInfo: nil, repeats: true)
                }
                catch let error {
                    print("Error for audio record: \(error.localizedDescription)")
                }
            }
        }


        func finishAudioRecording(success: Bool) {

            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()

            if success {
                textView.text = ""
                print("Finished.")
            } else {
                print("Failed :(")
            }
        }

        @objc func updateAudioTimer(timer: Timer) {

            if audioRecorder.isRecording {
                let min = Int(audioRecorder.currentTime / 60)
                let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
                let totalTimeString = String(format: "%02d:%02d", min, sec)
                textView.text = totalTimeString
                audioRecorder.updateMeters()

                if (sec == 10) {

                    //finishAudioRecording(success: true)
                }
            }
        }

        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
    
    //MARK:- Audio recoder delegate methods
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if !flag {
                finishAudioRecording(success: false)
            }
        }
}
