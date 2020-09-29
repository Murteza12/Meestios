//
//  peoplesVC.swift
//  meestApp
//
//  Created by Yash on 8/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher
import SocketIO

class peoplesVC: RootBaseVC {
    
    @IBOutlet weak var tableView:UITableView!
    var allUser = [ChatHeads]()
    var chatUser = [[String:Any]]()
//    let manager = SocketManager.init(socketURL: URL.init(string: BASEURL.socketURL)!, config: [.compress,.log(true)])
    var socket:SocketIOClient!
    var senduser:ChatHeads?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.socket = APIManager.sharedInstance.getSocket()
        self.socket = SocketSessionHandler.manager.defaultSocket
        self.addHandler()
//        self.socket.connect()
        self.getAll()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getAll() {
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            let payload = ["userId":user.id]
            self.socket.emit("getChatHeads", payload)
        }
    }
    
    func setChatHeadsData(data: [Any]){
        var all = [ChatHeads]()
        let newUser = data[0] as! [[String:Any]]
        for i in newUser {
            let id = i["id"] as? String ?? ""
            let chatHeadId = i["chatHeadId"] as? String ?? ""
            let likes = i["likes"] as? Int ?? 0
            let email = i["email"] as? String ?? ""
            let firstName = i["firstName"] as? String ?? ""
            let lastName = i["lastName"] as? String ?? ""
            let mobile = i["mobile"] as? Int ?? 0
            let dob = i["dob"] as? String ?? ""
            let status = i["status"] as? Bool ?? false
            let username = i["username"] as? String ?? ""
            let gender = i["gender"] as? String ?? ""
            let displayPicture = i["displayPicture"] as? String ?? ""
            let about = i["about"] as? String ?? ""
            let isOnline = i["isOnline"] as? Bool ?? false
            let chat = i["chats"] as? [[String:Any]] ?? [[:]]
            
            let temp = ChatHeads.init(id: id, likes: likes, email: email, firstName: firstName, lastName: lastName, mobile: mobile, dob: dob, status: status, username: username, gender: gender, dp: displayPicture,about: about,isOnline:isOnline,chat:chat,chatHeadId: chatHeadId)
            
            all.append(temp)
        }
        self.allUser = all
    }
    
    func addHandler() {

        self.socket.on("chatHeads") { data, ack in
            self.setChatHeadsData(data: data)
            self.tableView.reloadData()
        }
        self.socket.on("message") { dataa, ack in
            print(dataa)
        }
        self.socket.on("chat_history") { (dataa, ack) in
            print(dataa)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! mainChatVC
            dvc.toUser = self.senduser
        }
    }
}
extension peoplesVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! peoplesCell
        let ind = self.allUser[indexPath.row]
//        let ind = self.chatUser[indexPath.row]
        cell.onlineView.cornerRadius(radius: cell.onlineView.frame.height / 2)
        cell.unreadView2.cornerRadius(radius: cell.unreadView2.frame.height / 2)
        cell.img.cornerRadius(radius: cell.img.frame.height / 2)
        cell.usernameLbl.text = ind.firstName + " " + ind.lastName
        cell.timeLbl.text = ind.chat[0]["createdAt"] as? String
        
        if let lastMsg = (ind.chat[0]["last_msg"] as? String)?.decode(){
            cell.lastMsg.text = lastMsg
        }else{
            cell.lastMsg.text =  ind.about
        }
        cell.img.applyRoundedView()
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: ind.dp),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(ind.dp)
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        cell.unreadView2.isHidden = true
        if ind.isOnline {
            cell.onlineView.backgroundColor = UIColor.systemGreen
        } else {
            cell.onlineView.backgroundColor = UIColor.init(named: "backgroundcolor")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.senduser = self.allUser[indexPath.row]
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
}
class peoplesCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var usernameLbl:UILabel!
    @IBOutlet weak var onlineView:UIView!
    @IBOutlet weak var unreadView2:UIView!
    @IBOutlet weak var lastMsg:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var videoBtn:UIButton!
    
}
