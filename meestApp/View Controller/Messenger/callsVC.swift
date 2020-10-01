//
//  callsVC.swift
//  meestApp
//
//  Created by Yash on 8/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher
import SocketIO
import JitsiMeet

class callsVC: RootBaseVC {
    
    @IBOutlet weak var tableView:UITableView!
    var allUser = [ChatHeads]()
    let manager = SocketManager.init(socketURL: URL.init(string: BASEURL.socketURL)!, config: [.compress,.log(true)])
    var socket:SocketIOClient!
    var senduser:ChatHeads?
    fileprivate var jitsiMeetView: JitsiMeetView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.socket = self.manager.defaultSocket
        self.addHandler()
//        self.socket.connect()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAll()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func getAll() {
//        APIManager.sharedInstance.getAllConversation(vc: self) { (all) in
//            self.allUser = all
//            self.tableView.reloadData()
//        }
        self.tableView.isHidden = true
        
    }
    func addHandler() {
        self.socket.on("message") { (dataa, ack) in
            print(dataa)
        }
        self.socket.on("chat_history") { (dataa, ack) in
            print(dataa)
        }
    }
    
    @IBAction func showtableView(_ sender: Any){
        self.tableView.isHidden = false
    }
    
    @objc func makecallVideo(_ sender:UIButton) {
        APIManager.sharedInstance.createRoomCall(vc: self, recipientId: self.allUser[sender.tag].id, group: false, video: true) { (room) in
            let room: String = room.id
            
            // create and configure jitsimeet view
            let jitsiMeetView = JitsiMeetView()
            jitsiMeetView.delegate = self
            self.jitsiMeetView = jitsiMeetView
            let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
                builder.welcomePageEnabled = false
                builder.room = room
                builder.videoMuted = false
                
            }
                    
            // setup view controller
            let vc = UIViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.view = jitsiMeetView
            
            // join room and display jitsi-call
            jitsiMeetView.join(options)
            self.present(vc, animated: true, completion: nil)
        }
    }
    @objc func makecallVoice(_ sender:UIButton) {
        APIManager.sharedInstance.createRoomCall(vc: self, recipientId: self.allUser[sender.tag].id, group: false, video: true) { (room) in
            let room: String = room.id
            
            // create and configure jitsimeet view
            let jitsiMeetView = JitsiMeetView()
            jitsiMeetView.delegate = self
            self.jitsiMeetView = jitsiMeetView
            let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
                builder.welcomePageEnabled = false
                builder.room = room
                builder.videoMuted = true
                
            }
                    
            // setup view controller
            let vc = UIViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.view = jitsiMeetView
            
            // join room and display jitsi-call
            jitsiMeetView.join(options)
            self.present(vc, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! mainChatVC
            dvc.toUser = self.senduser
        }
    }
}
extension callsVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! peoplesCell
        let ind = self.allUser[indexPath.row]
        cell.onlineView.cornerRadius(radius: cell.onlineView.frame.height / 2)
        cell.unreadView2.cornerRadius(radius: cell.unreadView2.frame.height / 2)
        cell.img.cornerRadius(radius: cell.img.frame.height / 2)
        cell.usernameLbl.text = ind.username
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
        cell.videoBtn.tag = indexPath.row
        cell.videoBtn.addTarget(self, action: #selector(makecallVideo(_:)), for: .touchUpInside)
        if ind.isOnline {
            cell.onlineView.backgroundColor = UIColor.init(hex: 0x7F1BB9)
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

extension callsVC {
    override func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        cleanUp()
    }
    fileprivate func cleanUp() {
        if(jitsiMeetView != nil) {
            dismiss(animated: true, completion: nil)
            jitsiMeetView = nil
        }
    }
}
