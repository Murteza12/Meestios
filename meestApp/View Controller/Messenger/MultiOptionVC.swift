//
//  MultiOptionVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 26/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

protocol MultiOptionVCDelegate {
    func showWallpaperOption()
}

class MultiOptionVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tabelviewBackgroundView: UIView!
    @IBOutlet weak var tableViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var tabelView: UITableView!
    var allChatMessage = [MockMessage]()
    var deleagte: MultiOptionVCDelegate?
    var delegateViewContact: ViewContactVCDeleagte?
    var isFirstOption: Bool = true
    var isGroup: Bool?
    var firstOptions = ["View Contact","Media, links, and docs", "Search", "Mute Notification", "Wallpaper", "More"]
    var secondOptions = ["Report","Block", "Clear Chat", "Export Chat", "Add Shortcut"]
    var groupOption = ["Open Conversation", "Snooze Conversation", "Archive Conversation", "Mark as priority", "Share Conversation", "Add a member"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabelView.delegate = self
        self.tabelView.dataSource = self
        self.tabelView.separatorStyle = .none
        self.tabelView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let recongnizer = UIGestureRecognizer(target: self, action: #selector(self.tapAction))
        recongnizer.cancelsTouchesInView = false
        recongnizer.delegate = self
        self.view.addGestureRecognizer(recongnizer)
    }
    @objc func tapAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view?.isDescendant(of: self.tabelView)) == true) {
            return false
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }
}

extension MultiOptionVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGroup == true{
            return groupOption.count
        }
        return firstOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "multiOptionCell", for: indexPath) as! MultiOptionCell
        cell.selectionStyle = .none
        cell.rightArrowImageView.isHidden = true
        if isGroup == true{
            cell.optionLabel.text = groupOption[indexPath.row]
            if firstOptions[indexPath.row] == "Add a member"{
                cell.optionLabel.textColor = UIColor.init(hex: 0x3B5998)
            }
        }
        else{
            cell.optionLabel.text = firstOptions[indexPath.row]
            if firstOptions[indexPath.row] == "More"{
                cell.rightArrowImageView.isHidden = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isGroup == true{
            switch indexPath.row {
            case 0:
                self.openConversation()
                print("0 called")
            case 1:
                self.snoozeConversation()
                print("1 called")
            case 2:
                self.archiveConversation()
                print("2 called")
            case 3:
                self.markAsPriority()
                print("3 called")
            case 4:
                self.shareConversation()
                print("4 called")
            case 5:
                self.addaMember()
                print("5 called")
            default:
                print("Default called")
            }
        }else{
            switch indexPath.row {
            case 0:
                self.showViewContactVC()
                print("View Contact called")
            case 1:
                self.mediaLinksandDocs()
                print("1 called")
            case 2:
                self.search()
                print("2 called")
            case 3:
                self.muteNotification()
                print("3 called")
            case 4:
                self.showWallpaperOptionView()
            case 5:
                if self.firstOptions.count < 7{
                    self.loadMore()
                }else{
                    self.report()
                }
            case 6:
                self.block()
                print("6 called")
            case 7:
                self.clearChat()
                print("7 called")
            case 8:
                self.exportChat()
                print("8 called")
            case 9:
                self.addShortcut()
                print("9 called")
            default:
                print("Default called")
            }
        }
        
    }
    
    func showViewContactVC(){
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let viewContactVC = stoaryboard.instantiateViewController(withIdentifier: "ViewContactVC") as? ViewContactVC
        viewContactVC?.modalPresentationStyle = .overCurrentContext
        viewContactVC?.allChatMessage = self.allChatMessage
        viewContactVC?.delegate = self.delegateViewContact
        self.present(viewContactVC!, animated: true) {
        }
    }
    
    func showWallpaperOptionView()  {
        self.dismiss(animated: true) {
            self.deleagte?.showWallpaperOption()
        }
    }
    
    func loadMore(){
        tableViewHeightConstraints.constant = 279
        firstOptions.remove(at: 5)
        firstOptions.append(contentsOf: secondOptions)
        tabelView.isScrollEnabled = true
        tabelView.reloadData()
    }
    
    func mediaLinksandDocs(){
        
    }
    
    func search(){
    }
    
    func muteNotification(){
        
    }
    
    func report(){
        
    }
    func block(){
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let multiOptionVC = stoaryboard.instantiateViewController(withIdentifier: "DeleteChatHeadOptionVC") as? DeleteChatHeadOptionVC
        multiOptionVC?.modalPresentationStyle = .overCurrentContext
        multiOptionVC?.modalTransitionStyle = .crossDissolve
        multiOptionVC?.isBlock = true
        self.present(multiOptionVC!, animated: true) {
            
        }
        multiOptionVC?.deleteCompletion = {
            print("Delete API Called")
        }
        
    }
    func clearChat(){
        let stoaryboard = UIStoryboard(name: "Messenger", bundle: nil)
        let clearVC = stoaryboard.instantiateViewController(withIdentifier: "ClearChatVC") as? ClearChatVC
        clearVC?.modalPresentationStyle = .overCurrentContext
        clearVC?.modalTransitionStyle = .crossDissolve
        self.present(clearVC!, animated: true, completion: nil)
        clearVC?.clearCompletion = {
            print("clear API Called")
        }
        
    }
    func exportChat(){
    }
    func addShortcut(){
    }
    
    func openConversation(){
        
    }
    
    func archiveConversation(){
        
    }
    
    func snoozeConversation(){
        
    }
    func markAsPriority(){
        
    }
    func shareConversation(){
        
    }
    func addaMember(){
        
    }
    
}

class MultiOptionCell: UITableViewCell{
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
}
