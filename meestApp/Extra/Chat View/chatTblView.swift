//
//  chatTblView.swift
//  meestApp
//
//  Created by Yash on 8/31/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import UIKit

class chatTblView: UITableView {
  
    var toUser:ChatHeads?
    lazy var inputAccessory: msgSendView = {
        let rect = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 70)
        let inputAccessory = msgSendView(frame: rect)
        inputAccessory.toUser = self.toUser
        return inputAccessory
    }()

    override var inputAccessoryView: UIView? {
        return inputAccessory
    }
  
    override var canBecomeFirstResponder: Bool {
        return true
    }
  
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.contentInset.bottom = keyboardHeight
            if keyboardHeight > 100 {
                scrollToBottom()
            }
        }
    }
  
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.contentInset.bottom = keyboardHeight
        }
    }
}
//MARK:- Scroll to bottom function
extension UITableView {
    func scrollToBottom(animated: Bool = true, scrollPostion: UITableView.ScrollPosition = .bottom) {
        let no = self.numberOfRows(inSection: 0)
        if no > 0 {
            let index = IndexPath(row: no - 1, section: 0)
            scrollToRow(at: index, at: scrollPostion, animated: animated)
        }
    }
}
