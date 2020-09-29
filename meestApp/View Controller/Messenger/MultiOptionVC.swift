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
    var firstOptions = ["View Contact","Media, links, and docs", "Search", "Mute Notification", "Wallpaper", "More"]
    var secondOptions = ["Report","Block", "Clear Chat", "Export Chat", "Add Shortcut"]
    
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
        return firstOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "multiOptionCell", for: indexPath) as! MultiOptionCell
        cell.selectionStyle = .none
        cell.rightArrowImageView.isHidden = true
//        if isFirstOption{
            cell.optionLabel.text = firstOptions[indexPath.row]
        if firstOptions[indexPath.row] == "More"{
            cell.rightArrowImageView.isHidden = false
        }
            
//        }else{
//            cell.optionLabel.text = secondOptions[indexPath.row]
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        isFirstOption = false
        
        switch indexPath.row {
        case 0:
            self.showViewContactVC()
        case 4:
            self.showWallpaperOptionView()
        case 5:
            self.loadMore()
        default:
            print("Default called")
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
//        UIView.transition(with: tableView,
//                          duration: 0.35,
//                          options: .transitionCrossDissolve,
//                          animations: { tabelView.reloadData() })
    }
    
}

class MultiOptionCell: UITableViewCell{
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
}
