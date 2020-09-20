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

class msgSendView: UIView {
    
    var toUser:ChatUser?
    var userid = ""
    let manager = SocketManager.init(socketURL: URL.init(string: BASEURL.socketURL)!, config: [.compress,.log(true)])
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
      let new = ["msg":self.textView.text ?? "","toUserId":self.toUser?.id ?? "","type":0,"userId":self.userid] as [String : Any]
      
      //self.messages.append(MockMessage.init(text: self.msgTxtView.text ?? "", user: MockUser.init(senderId: self.toUser?.id ?? "", displayName: ""), messageId: "", date: Date(), attachment: 0, createdAt: "", deletedAt: "", id: "", msg: self.msgTxtView.text ?? "", status: 0, toUserID: self.toUser?.id ?? "", updatedAt: "", userID: "", sent: "TRUE"))
      self.textView.text = ""
      print(new)
      self.socket.emitWithAck("send", new).timingOut(after: 20) {data in
          print(data)
          return
      }
      
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
        self.socket = self.manager.defaultSocket
        
        APIManager.sharedInstance.getCurrentUser(vc: UIViewController()) { (user) in
            self.userid = user.id
            
            
        }
        
        self.socket.connect()
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    
        textView.translatesAutoresizingMaskIntoConstraints = false
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type your message"
            textView.textColor = UIColor.gray
        } else {
            self.sendBtn.setImage(UIImage.init(named: "navigation"), for: .normal)
            textView.textColor = UIColor.black
        }
        
        
    }
}
