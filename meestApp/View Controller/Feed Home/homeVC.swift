//
//  homeVC.swift
//  meestApp
//
//  Created by Yash on 8/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftRichString
import SimpleAnimation
import Lottie
import Hero
import SocketIO

class homeVC: RootBaseVC, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var tableView:subTblView!
    @IBOutlet weak var storyCollection:UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    var socket:SocketIOClient!
    let transition = CircularTransition()
    
    var allPost = [Post]()
    var allStory = [Story]()
    var sendComment = [PostCommentElement]()
    var headerView = UIView()
    var headerLabel = UILabel()
    var storedOffsets = [Int: CGFloat]()
    var user:CurrentUser?
    var postid = ""
    var senduserid = ""
    var action = ["Report","Turn On Push Notification","Copy Link","Share to..","Unfollow","Mute"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.storyCollection.delegate = self
        self.storyCollection.dataSource = self
        
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            if Token.sharedInstance.getToken() != "" {
                self.socket = SocketSessionHandler.manager.defaultSocket
                self.addHandlers(userid: user.id, username: user.username)
                if self.socket.status != .connected{
                    self.socket.connect(timeoutAfter: 30) {
                        self.socket.emit("connection")
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.loadAnimation()
        self.getAllPost()
        self.getCurrent()
        self.getStory()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //  view.shake(toward: .top, amount: 0.1, duration: 5, delay: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           // self.removeAnimation()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.tableView.invalidateIntrinsicContentSize()
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comment" {
            let dvc = segue.destination as! commentVC
            dvc.postid = self.postid
        } else if segue.identifier == "profile" {
            let dvc = segue.destination as! otherProfileVC
            dvc.userid = self.senduserid
        }
//        let secondVC = segue.destination as! videoHomeVC
//        secondVC.transitioningDelegate = self
//        secondVC.modalPresentationStyle = .custom
    }
    
    func addHandlers(userid:String,username:String) {
        
        self.socket.on("connected") { data, ack in
            print(data)
            let data = data as! [[String:Any]]
            let msg = data[0]["msg"] as? String ?? ""
            print(msg)
            let payload = ["userId":userid,"name":username]
            self.socket.once(clientEvent: .connect) {data, ack in
                self.socket.emit("createSession", payload)
            }

        }
            self.socket.on("session") { (dataa, ack) in
                print(dataa)
            
        }
    }
    @IBAction func videoView(_ sender:UIButton) {
        
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = menuButton.center
        transition.circleColor = menuButton.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = menuButton.center
        transition.circleColor = menuButton.backgroundColor!
        
        return transition
    }
    
    func getAllPost() {
        APIManager.sharedInstance.getAllPost(vc: self) { (post) in
            self.allPost = post
            self.tableView.reloadData()
        }
    }
    func getCurrent() {
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            self.user = user
            self.storyCollection.reloadData()
        }
    }
    func getStory() {
        APIManager.sharedInstance.getStory(vc: self) { (all) in
            self.allStory = all
            self.storyCollection.reloadData()
        }
    }
    @IBAction func logout(_ sender:UIButton) {
//        view.shake(toward: .bottom, amount: 0.1, duration: 5, delay: 1)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//            self.performSegue(withIdentifier: "proceed", sender: self)
//        }
//        APIManager.sharedInstance.clearDB {
//            let dvc = self.storyboard?.instantiateViewController(withIdentifier: "preLoginVC") as! preLoginVC
//            dvc.modalPresentationStyle = .fullScreen
//            self.present(dvc, animated: true, completion: nil)
//        }
    }
    @objc func postLike(_ sender:UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! postCell
      
        if cell.likeBtn.imageView?.image == UIImage.init(named: "liked") {
            
            
            cell.likeBtn.setImage(UIImage.init(named: "unlike"), for: .normal)
        } else {
           
            cell.likeBtn.setImage(UIImage.init(named: "liked"), for: .normal)
       //     cell.dislikeBtn.setImage(UIImage.init(named: "unlike1"), for: .normal)
        }
        APIManager.sharedInstance.postLike(postId: self.allPost[sender.tag].id, vc: self) { (like,dislike) in
            cell.likeLblCount.text = like.toString()
           // cell.dislikeLblCount.text = dislike.toString()
        }
    }
    
//    @objc func postDislike(_ sender:UIButton) {
//        
//        let cell = self.tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! postCell
//        
//        if cell.dislikeBtn.imageView?.image == UIImage.init(named: "liked1") {
//            
//            
//            cell.dislikeBtn.setImage(UIImage.init(named: "unlike1"), for: .normal)
//        } else {
//            
//       //     cell.dislikeBtn.setImage(UIImage.init(named: "liked1"), for: .normal)
//            cell.likeBtn.setImage(UIImage.init(named: "unlike"), for: .normal)
//        }
//        APIManager.sharedInstance.postdisLike(postId: self.allPost[sender.tag].id, vc: self) { (like,dislike) in
//            cell.likeLblCount.text = like.toString()
//       //     cell.dislikeLblCount.text = dislike.toString()
//        }
//    }
    
    @objc func postComment(_ sender:UIButton) {
        self.postid = self.allPost[sender.tag].id
        self.performSegue(withIdentifier: "comment", sender: self)
    }
    @objc func otherProfile(_ sender:UITapGestureRecognizer) {
        self.senduserid = self.allPost[sender.view!.tag].userID
        self.performSegue(withIdentifier: "profile", sender: self)
    }
    @objc func option(_ sender:UIButton) {
        let action = UIAlertController.init(title: "Message", message: "Please Select Option", preferredStyle: .actionSheet)
        for i in self.action {
            action.addAction(UIAlertAction.init(title: i, style: .default, handler: { (_) in
                
            }))
        }
        action.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(action, animated: true, completion: nil)
    }
    @IBAction func messengerBtn(_ sender:UIButton) {
        let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mssengerHomeVC") as! mssengerHomeVC
        greenVC.isHeroEnabled = true
        greenVC.modalPresentationStyle = .fullScreen
        greenVC.heroModalAnimationType = .zoomOut
        self.hero_replaceViewController(with: greenVC)
    }
    @IBAction func videoBtn(_ sender:UIButton) {
        let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "videoViewerVC") as! videoViewerVC
        greenVC.isHeroEnabled = true
        greenVC.modalPresentationStyle = .fullScreen
        greenVC.heroModalAnimationType = .zoom
        self.hero_replaceViewController(with: greenVC)
    }
}
extension homeVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allPost.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! postCell
        let ind = self.allPost[indexPath.row]
        cell.view1.cornerRadius(radius: 16)
        cell.dpImage.backgroundColor = UIColor.black
        cell.dpImage.cornerRadius(radius: cell.dpImage.frame.height / 2)
        cell.dpImage.kf.indicatorType = .activity
        cell.dpImage.kf.setImage(with: URL(string: ind.user.displayPicture),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(ind.user.displayPicture)
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(otherProfile(_:)))
        cell.usernameLbl.tag = indexPath.row
        cell.usernameLbl.addGestureRecognizer(tap)
        cell.usernameLbl.isUserInteractionEnabled = true
        cell.dpImage.cornerRadius(radius: cell.dpImage.frame.height / 2)
        cell.usernameLbl.numberOfLines = 0
        
        let u1 = Style {
            $0.font = UIFont.init(name: APPFont.regular, size: 16)
            $0.color = UIColor.black
        }
        
        let u2 = Style {
            $0.font = UIFont.init(name: APPFont.regular, size: 12)
            $0.color = UIColor(red: 0.583, green: 0.591, blue: 0.633, alpha: 1)
        }
        
        let styles = StyleXML.init(base: u1, ["u2" : u2])
        let str = "\(ind.user.username)\n<u2>\(ind.createdAt)</u2>"
        cell.usernameLbl.attributedText = str.set(style: styles)
        cell.captionLbl.text = ind.caption
        cell.captionLbl.font = UIFont.init(name: APPFont.extralight, size: 14)
        cell.captionLbl.textColor = UIColor(red: 0.496, green: 0.496, blue: 0.496, alpha: 1)
        cell.captionLbl.numberOfLines = 0
        cell.likeImg1.isHidden = true
        cell.likeImg2.isHidden = true
        cell.likeImg3.isHidden = true
        cell.likeImg4.isHidden = true
        
        cell.likeImg1.cornerRadius(radius: cell.likeImg1.frame.height / 2)
        cell.likeImg2.cornerRadius(radius: cell.likeImg2.frame.height / 2)
        cell.likeImg3.cornerRadius(radius: cell.likeImg3.frame.height / 2)
        cell.likeImg4.cornerRadius(radius: cell.likeImg4.frame.height / 2)
        
        cell.likeImg1.layer.borderColor = UIColor.white.cgColor
        cell.likeImg1.layer.borderWidth = 2.67
        
        cell.likeImg2.layer.borderColor = UIColor.white.cgColor
        cell.likeImg2.layer.borderWidth = 2.67
        
        cell.likeImg3.layer.borderColor = UIColor.white.cgColor
        cell.likeImg3.layer.borderWidth = 2.67
        
        cell.likeImg4.layer.borderColor = UIColor.white.cgColor
        cell.likeImg4.layer.borderWidth = 2.67
        
        cell.likeImg1.backgroundColor = .blue
        cell.likeImg2.backgroundColor = .blue
        cell.likeImg3.backgroundColor = .blue
        cell.likeImg4.backgroundColor = .blue
        
        let img = [cell.likeImg1,cell.likeImg2,cell.likeImg3,cell.likeImg4,cell.likeImg4]
        for i in 0 ..< ind.posts.count {
            img[i]?.isHidden = false
            img[i]?.kf.indicatorType = .activity
            img[i]?.kf.setImage(with: URL(string: ind.posts[i].post),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")

                case .failure(let error):
                    print(ind.posts[i].post)
                    print("Job failed: \(error.localizedDescription)")

                }
            }
        }
        let l1 = Style {
            $0.font = UIFont.init(name: APPFont.extralight, size: 15)
            $0.color = UIColor(red: 0.583, green: 0.591, blue: 0.633, alpha: 1)
        }
        
        let l2 = Style {
            $0.font = UIFont.init(name: APPFont.semibold, size: 16)
            $0.color = UIColor.black
        }
        
        let stylesl = StyleXML.init(base: l1, ["l2" : l2])
//        if ind.postLikes.count > 0 {
//            let strr = "Liked By <l2>\(ind.postLikes[0].user.username)</l2> and <l2>\(ind.postLikes.count) Others</l2>"
//            cell.likeLblCount.attributedText = strr.set(style: stylesl)
//        }
        
        cell.likeLblCount.text = ind.liked.toString()
      //  cell.likeBtn.cornerRadius(radius: cell.likeBtn.frame.height / 2)
      //  cell.commentBtn.cornerRadius(radius: cell.commentBtn.frame.height / 2)
      //  cell.dislikeBtn.cornerRadius(radius: cell.likeBtn.frame.height / 2)
        
     //   cell.likeBtn1.addTarget(self, action: #selector(postLike(_:)), for: .touchUpInside)
     //   cell.likeBtn1.isHidden = true
   //     cell.dislikeLblCount.text = ind.disliked.toString()
        cell.likeBtn.cornerRadius(radius: cell.likeBtn.frame.height / 2)
        cell.likeBtn.isHidden = false
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(postLike(_:)), for: .touchUpInside)
    //    cell.dislikeBtn.tag = indexPath.row
    //    cell.dislikeBtn.addTarget(self, action: #selector(postDislike(_:)), for: .touchUpInside)
        cell.dropBtn.addTarget(self, action: #selector(option(_:)), for: .touchUpInside)
        if ind.liked == 0 {
            cell.likeBtn.setImage(UIImage.init(named: "unlike"), for: .normal)
        } else {
            cell.likeBtn.setImage(UIImage.init(named: "liked"), for: .normal)
        }
        
        if ind.disliked == 0 {
    //        cell.dislikeBtn.setImage(UIImage.init(named: "unlike1"), for: .normal)
        } else {
   //         cell.dislikeBtn.setImage(UIImage.init(named: "liked1"), for: .normal)
        }
        let animation = Animation.named(Themes.save)
        cell.saveBtn1.animation = animation
//        let string = ind.commentCounts.toString() + " Comment"
        cell.commentshareLbl.font = UIFont.init(name: APPFont.regular, size: 12)
        cell.commentshareLbl.text = ind.commentCounts.toString() + " Comment " + "● " + ind.commentCounts.toString() + " Share"
        cell.commentBtn.tag = indexPath.row
        cell.commentBtn.addTarget(self, action: #selector(postComment(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? postCell else { return }

        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? postCell else { return }

        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension homeVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.storyCollection {
            return self.allStory.count + 1
        }
        return self.allPost[collectionView.tag].posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.storyCollection {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! storyCell
                cell.addBtn.cornerRadius(radius: cell.addBtn.frame.height / 2)
                cell.nameLbl.text = "Your Story"
                cell.img.cornerRadius(radius: cell.img.frame.height / 2)
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.user?.dp),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print(self.user?.dp ?? "")
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
                cell.addBtn.isHidden = false
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! storyCell
                let ind = self.allStory[indexPath.row - 1]
                cell.addBtn.isHidden = true
                cell.addBtn.cornerRadius(radius: cell.addBtn.frame.height / 2)
                cell.nameLbl.text = ind.storyUSer.username
                cell.img.cornerRadius(radius: cell.img.frame.height / 2)
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: ind.storyUSer.displayPicture),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print(ind.storyUSer.displayPicture)
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! mediaCell
        let ind = self.allPost[collectionView.tag].posts[indexPath.row]
        cell.img.cornerRadius(radius: 10)
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: ind.post),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(ind.post)
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        cell.img.contentMode = .scaleToFill
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.storyCollection {
            return CGSize.init(width: 72, height: 72)
        }
        if self.allPost[collectionView.tag].posts.count > 1 {
            return CGSize.init(width: self.tableView.frame.width - 70, height: collectionView.frame.height)
        }
        return CGSize.init(width: self.tableView.frame.width - 50, height:collectionView.frame.height )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.storyCollection {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "statusadd", sender: self)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.storyCollection {
            return 5
        }
        if self.allPost[collectionView.tag].posts.count > 1 {
            return 10
        }
        return 10
    }
}





class CircularTransition: NSObject {

    var circle = UIView()
    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.white
    
    var duration = 0.3
    
    enum CircularTransitionMode:Int {
        case present, dismiss, pop
    }
    
    var transitionMode:CircularTransitionMode = .present
    
}

extension CircularTransition:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(circle)
                
                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                    
                    }, completion: { (success:Bool) in
                        transitionContext.completeTransition(success)
                })
            }
            
        }else{
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.circle, belowSubview: returningView)
                    }
                    
                    
                    }, completion: { (success:Bool) in
                        returningView.center = viewCenter
                        returningView.removeFromSuperview()
                        
                        self.circle.removeFromSuperview()
                        
                        transitionContext.completeTransition(success)
                        
                })
                
            }
            
            
        }
        
    }
    
    
    
    func frameForCircle (withViewCenter viewCenter:CGPoint, size viewSize:CGSize, startPoint:CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    
    }
}

//extension homeVC: URLSessionDelegate{
//    
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        
//        if challenge.protectionSpace.host == "socket.dbmdemo.com" {
//                completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
//            } else {
//                completionHandler(.performDefaultHandling, nil)
//            }
////        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
////            if let serverTrust = challenge.protectionSpace.serverTrust {
////                completionHandler(.useCredential, URLCredential(trust:serverTrust))
////                return
////            }
////        }
//    }
//}
