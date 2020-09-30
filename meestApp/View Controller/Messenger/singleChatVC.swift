//
//  singleChatVC.swift
//  meestApp
//
//  Created by Yash on 8/19/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Foundation
import MessageKit
import InputBarAccessoryView
import SocketIO
import Kingfisher

public struct Sender: SenderType {
    public let senderId: String

    public let displayName: String
}

class singleChatVC:MessagesViewController {
    
    var messages = [MockMessage]()
    var count = 0
    var toUser:ChatUser?
//    let manager = SocketManager.init(socketURL: URL.init(string: BASEURL.socketURL)!, config: [.compress,.log(true)])
    var socket:SocketIOClient!
    var userid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageCollectionView()
        configureMessageInputBar()
        self.socket = SocketSessionHandler.manager.defaultSocket
        self.addHandler()
//        self.socket.connect()
        NotificationCenter.default.addObserver(self, selector: #selector(sendMsg), name: NSNotification.Name.init("msgsend"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        updateTitleView(title: self.toUser?.username ?? "", subtitle: "", baseColor: .black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            self.userid = user.id
            let neww = ["userId":user.id,"toUserId":self.toUser?.id ?? "","pageNumber":1] as [String : Any]
            self.socket.emitWithAck("get_history", neww).timingOut(after: 20) {data in
                return
            }
        }
    }
    func configureMessageCollectionView() {
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        layout?.setMessageOutgoingCellBottomLabelAlignment(.init(textAlignment: .right, textInsets: .zero))
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
      //  messagesCollectionView.addSubview(refreshControl)
       // refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.setMiddleContentView(messageInputBar.inputTextView, animated: false)
        messageInputBar.inputTextView.backgroundColor = UIColor.init(hex: 0xEFF1F2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messageInputBar.inputTextView.cornerRadius(radius: self.messageInputBar.frame.height / 2 - 10)
            self.messageInputBar.rightStackView.cornerRadius(radius: self.messageInputBar.rightStackView.frame.height / 2)
        }
        messageInputBar.inputTextView.delegate = self
        messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.setStackViewItems([sendBtn(named: "microphone")], forStack: .right, animated: true)
        
       // messageInputBar.setStackViewItems(bottomItems, forStack: .left, animated: false)
        
//        messageInputBar.sendButton.setImage(UIImage.init(named: "send"), for: .normal)
//        messageInputBar.sendButton.setTitle("", for: .normal)
//        messageInputBar.sendButton.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
//        messageInputBar.sendButton.activityViewColor = .black
//        messageInputBar.sendButton.backgroundColor = .clear
//        messageInputBar.sendButton.layer.cornerRadius = 10
//        messageInputBar.sendButton.setTitleColor(.white, for: .normal)
//        messageInputBar.sendButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .highlighted)
//        messageInputBar.sendButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .disabled)
//        messageInputBar.sendButton.onSelected { item in
//                item.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//
//        }.onDeselected { item in
//                item.transform = .identity
//        }
    }
    private func imageBtn(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 20, height: 20), animated: false)
                $0.tintColor = UIColor.black
                $0.cornerRadius(radius: $0.frame.height / 2)
            }.onSelected {
                $0.tintColor = UIColor.black
            }.onDeselected {
                $0.tintColor = .black
            }.onTouchUpInside { _ in
        }
    }
    private func sendBtn(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(0)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: false)
                $0.tintColor = UIColor.black
                $0.backgroundColor = UIColor.init(hex: 0xEFF1F2)
                $0.cornerRadius(radius: $0.frame.height / 2)
                
            }.onSelected {
                $0.tintColor = UIColor.black
            }.onDeselected {
                $0.tintColor = .black
            }.onTouchUpInside { _ in
              //  self.sendMsg()
        }
    }
    @objc func sendMsg(notification:Notification) {
        let info = notification.userInfo as! [String:Any]
        
        let new = ["msg":info["msg"] as! String ,"toUserId":self.toUser?.id ?? "","type":0,"userId":self.userid] as [String : Any]
        
        self.messages.append(MockMessage.init(text: self.messageInputBar.inputTextView.text ?? "", user: MockUser.init(senderId: self.toUser?.id ?? "", displayName: ""), messageId: "", date: Date(), attachment: 0, createdAt: "", deletedAt: "", id: "", msg: self.messageInputBar.inputTextView.text, status: 0, toUserID: self.toUser?.id ?? "", updatedAt: "", userID: "", sent: true, senderData: [ : ], fileURL:"", attachmentType: "", videothumbnail: "", read: 0))
        self.messageInputBar.inputTextView.text = ""
        self.messagesCollectionView.reloadData()
        self.socket.emitWithAck("send", new).timingOut(after: 20) {data in
            print(data)
            return
        }
        
    }
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func addHandler() {
        
        self.socket.on("message") { (dataa, ack) in
            print(dataa)
            var ChatUserID = ""
            let ChatUserName = ""
            let datamsg = dataa as! [[String:Any]]
            let data = datamsg[0]["msg"] as! [String:Any]
            let attachment = data["attachment"] as? Int ?? 0
            let createdAt = data["createdAt"] as? String ?? ""
            let deletedAt = data["deletedAt"] as? String ?? ""
            let id = data["id"] as? String ?? ""
            let msg = data["msg"] as? String ?? ""
            let status = data["status"] as? Int ?? 0
            let toUserId = data["toUserId"] as? String ?? ""
            let updatedAt = data["updatedAt"] as? String ?? ""
            let userId = data["userId"] as? String ?? ""
            let sent = data["sender"] as? Bool ?? false
            let senderData = data["senderData"] as? [String:Any] ?? [:]
            if sent {
                
                ChatUserID = self.toUser?.id ?? ""
            } else {
                ChatUserID = self.userid
                
            }
            let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent,senderData: senderData, fileURL:"", attachmentType: "", videothumbnail: "", read: 0)
            
            self.messages.append(temp)
            
            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
        
        self.socket.on("chat_history") { (dataa, ack) in
            self.messages.removeAll()
            print(dataa)
            let data = dataa as! [[String:Any]]
            let count = data[0]["count"] as? Int ?? 0
            self.count = count
            let rows = data[0]["rows"] as! [[String:Any]]
            for ii in rows {
                var ChatUserID = ""
                let ChatUserName = ""
                let attachment = ii["attachment"] as? Int ?? 0
                let createdAt = ii["createdAt"] as? String ?? ""
                let deletedAt = ii["deletedAt"] as? String ?? ""
                let id = ii["id"] as? String ?? ""
                let msg = ii["msg"] as? String ?? ""
                let status = ii["status"] as? Int ?? 0
                let toUserId = ii["toUserId"] as? String ?? ""
                let updatedAt = ii["updatedAt"] as? String ?? ""
                let userId = ii["userId"] as? String ?? ""
                let sent = ii["sender"] as? Bool ?? false
                let senderData = ii["senderData"] as? [String:Any] ?? [:]
                if sent {
                    ChatUserID = self.userid
                    
                } else {
                    ChatUserID = self.toUser?.id ?? ""
                }
                let temp = MockMessage.init(text: self.decode(msg) ?? "", user: MockUser.init(senderId: ChatUserID, displayName: ChatUserName), messageId: "", date: Date(), attachment: attachment, createdAt: createdAt, deletedAt: deletedAt, id: id, msg: self.decode(msg) ?? "", status: status, toUserID: toUserId, updatedAt: updatedAt, userID: userId, sent: sent,senderData: senderData, fileURL:"", attachmentType: "",videothumbnail: "", read: 0)
                
                self.messages.append(temp)
            }
            self.messagesCollectionView.reloadData()
        }
    }
}

extension singleChatVC:MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        if self.messages.count > 0 {
            
            return MockUser.init(senderId: self.toUser?.id ?? "", displayName: "")
        } else {
            return MockUser.init(senderId: "", displayName: "")
        }
    }
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].user == messages[indexPath.section + 1].user
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section]
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.init(hex: 0x3B5998) : UIColor.init(hex: 0xECF7FE)
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if self.messages[indexPath.section].user.senderId != self.userid {
            avatarView.isHidden = true
            return
        }
        let avatar = self.toUser?.dp
        let img = UIImageView()
        img.kf.indicatorType = .activity
        img.kf.setImage(with: URL(string: avatar),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                avatarView.set(avatar: Avatar.init(image: img.image, initials: ""))
                
                avatarView.isHidden = self.isNextMessageSameSender(at: indexPath)
                
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
    }
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
}
extension singleChatVC:InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                //self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
}
extension singleChatVC: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Image tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
    }

    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }

    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }

}

extension singleChatVC: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }

    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }

    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }

    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }

}

extension singleChatVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as! UIImage
        APIManager.sharedInstance.uploadImage(vc: self, img: img) { (str) in
            let new = ["msg":str,"toUserId":self.toUser?.id ?? "","type":0,"userId":self.userid] as [String : Any]
            self.socket.emitWithAck("send", new).timingOut(after: 20) {data in
                print(data)
                return
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
}

extension singleChatVC:UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       // self.messageInputBar.
    }
}

