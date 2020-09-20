//
//  commentVC.swift
//  meestApp
//
//  Created by Yash on 8/19/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class commentVC: RootBaseVC {

    @IBOutlet weak var tableView:subTblView!
    
    @IBOutlet weak var headerLbl:UILabel!
    @IBOutlet weak var sendView:UIView!
    @IBOutlet weak var txt1:UITextField!
  //  @IBOutlet weak var scrollView:UIScrollView!
    
    var postid = ""
    var isReply = false
    var hassubcmt = false
    var count = 0
    var comments = [PostCommentElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerForKeyboardWillHideNotification(self.tableView)
        self.registerForKeyboardWillShowNotification(self.tableView)
        KeyboardAvoiding.avoidingView = self.sendView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        
        
        self.sendView.cornerRadius(radius: self.sendView.frame.height / 2)
        self.getComment()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
        }
    }
    func getComment() {
        APIManager.sharedInstance.getComment(postId: self.postid, vc: self) { (all) in
            self.comments = all
            self.headerLbl.text = "\(self.comments.count) Comments"
            self.count = all.count
            for i in all {
                if i.subcomment.id != "" {
                    self.count += 1
                }
            }
            self.comments.append(PostCommentElement.init(id: "", comment: "", subCommentID: "", postID: "", userID: "", status: false, deletedAt: "", createdAt: "", updatedAt: "", user: PostCommentUser.init(id: "", username: "", displayPicture: ""), subcomment: SubComment.init(id: "", comment: "", subCommentID: "", postID: "", userID: "", status: false, deletedAt: "", createdAt: "", updatedAt: "", user: PostCommentUser.init(id: "", username: "", displayPicture: ""))))
            self.tableView.reloadData()
            print(self.count + 1)
            self.removeAnimation()
            
            
        }
    }
    @IBAction func sendComment(_ sender:UIButton) {
        if self.txt1.text == "" {
            self.showAlert(with: "Message", message: "Please Enter A Comment")
            return
        }
        if self.isReply {
            APIManager.sharedInstance.postSubComment(comment: self.txt1.text ?? "", postId: self.postid, subCommentId: self.comments[sender.tag].id, vc: self) { (str) in
                if str == "success" {
                    self.loadAnimation()
                    self.getComment()
                    self.tableView.reloadData()
                    self.txt1.text = ""
                }
            }
            
        } else {
            APIManager.sharedInstance.postComment(comment: self.txt1.text ?? "", postId: self.postid, vc: self) { (str) in
                if str == "success" {
                    self.loadAnimation()
                    self.getComment()
                    self.tableView.reloadData()
                    self.txt1.text = ""
                }
            }
        }
        
    }
    @objc func likeComt(_ sender:UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! commentCell2
        cell.likeBtn.setTitleColor(UIColor(red: 0.522, green: 0.522, blue: 0.584, alpha: 1), for: .normal)
        cell.likeBtn.titleLabel?.font = UIFont.init(name: APPFont.bold, size: 11)
        let ind = self.comments[sender.tag]
        APIManager.sharedInstance.likeComment(vc: self, commetnid: ind.id, postId: ind.postID) { (str) in
            
        }
    }
    @objc func stratReply(_ sender:UIButton) {
        self.isReply = true
        self.txt1.becomeFirstResponder()
    }
}
extension commentVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! commentCell1
            
            return cell
        } else {
            if self.hassubcmt {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! subCommentCell
                let ind = self.comments[indexPath.row - 2]
                cell.usernameLbl.text = ind.user.username
                cell.lastMsg.text = ind.subcomment.comment
                cell.img.cornerRadius(radius: cell.img.frame.height / 2)
                cell.timeLbl.text = ind.createdAt
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: ind.subcomment.user.displayPicture ?? ""),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print(ind.subcomment.user.displayPicture ?? "")
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
                self.hassubcmt = false
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! commentCell2
                print(indexPath.row - 1)
                print(self.comments.count)
                let ind = self.comments[indexPath.row - 1]
                cell.usernameLbl.text = ind.user.username
                cell.lastMsg.text = ind.comment ?? ""
                cell.img.cornerRadius(radius: cell.img.frame.height / 2)
                cell.timeLbl.text = ind.createdAt
                cell.likeBtn.tag = indexPath.row
                cell.likeBtn.addTarget(self, action: #selector(likeComt(_:)), for: .touchUpInside)
                cell.replyBtn.tag = indexPath.row
                cell.replyBtn.addTarget(self, action: #selector(stratReply(_:)), for: .touchUpInside)
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: ind.user.displayPicture ?? ""),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print(ind.user.displayPicture ?? "")
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
                if ind.subcomment.id != "" {
                    self.hassubcmt = true
                } else {
                    self.hassubcmt = false
                }
                return cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            APIManager.sharedInstance.deleteComment(vc: self, commetnid: self.comments[indexPath.row].id) { (str) in
                
            }
            self.comments.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)-> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // delete the item here
            APIManager.sharedInstance.deleteComment(vc: self, commetnid: self.comments[indexPath.row].id) { (str) in
                
            }
            self.comments.remove(at: indexPath.row)
            self.tableView.reloadData()
            completionHandler(true)
        }
            deleteAction.image = UIImage.init(named: "bin")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
}

class commentCell1:UITableViewCell {
    
    @IBOutlet weak var txt1:UITextView!
    
}
class commentCell2:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var usernameLbl:UILabel!
    @IBOutlet weak var lastMsg:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var likeBtn:UIButton!
    @IBOutlet weak var replyBtn:UIButton!
    @IBOutlet weak var reportBtn:UIButton!
    
}

class subCommentCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var usernameLbl:UILabel!
    @IBOutlet weak var lastMsg:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
}
