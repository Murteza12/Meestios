//
//  AddPeopleGroupVC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 27/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class AddPeopleGroupVC: RootBaseVC {

    @IBOutlet weak var headerImageView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var peopleCountLabel: UILabel!
    @IBOutlet weak var allPeopleLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    var allFollwedUser = [SuggestedUser]()
    var selectedMember = [String]()
    var selectedUser = [SuggestedUser]()
    var addedMember = [GroupMember]()
    var addMember: Bool = false
    var groupId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.nextButtonView.isHidden = true
        
        self.peopleCountLabel.font = UIFont.init(name: APPFont.regular, size: 14)
        self.peopleCountLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.allPeopleLabel.font = UIFont.init(name: APPFont.regular, size: 19)
        self.sortButton.setTitle("Newest", for: .normal)
        self.sortButton.titleLabel?.font = UIFont.init(name: APPFont.regular, size: 14)
        self.allPeopleLabel.text = "All People"
        APIManager.sharedInstance.followGetFriends(vc: self) { all in
            self.allFollwedUser = all
            self.peopleCountLabel.text =  self.allFollwedUser.count > 9 ? (self.allFollwedUser.count).toString() + " Peoples" : "0"+(self.allFollwedUser.count).toString() + " Peoples"
            self.tableView.reloadData()
        }
        if self.addMember == true{
            APIManager.sharedInstance.getGroupMembers(vc: self, groupId: self.groupId) { (addedMember) in
                self.addedMember = addedMember
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createGroupVC" {
            let peopleGroup = segue.destination as! CreateGroupVC
            peopleGroup.allUser = allFollwedUser
            peopleGroup.selectedMember = selectedMember
            peopleGroup.selectedUser = self.selectedUser
            peopleGroup.addMember = addMember
            peopleGroup.groupId = groupId
            if addMember == true{
                peopleGroup.imageURL = addedMember[0].chatHead["groupIcon"]
                peopleGroup.groupName = addedMember[0].chatHead["groupName"]
            }
            
        }
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "createGroupVC", sender: self)
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
    }
    
    
}

extension AddPeopleGroupVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFollwedUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addPeopleCellTableViewCell", for: indexPath) as! AddPeopleCellTableViewCell
        let allUser = allFollwedUser[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        cell.chatHeadsImageView.kf.setImage(with: URL(string: allUser.displayPicture))
        cell.names.text = allUser.firstName + " " + allUser.lastName
        
        cell.buttonImageView.setImage(UIImage(named: "AddPeople")!)
        cell.heightConstraintsConstant.constant = 10
        cell.widthConstraintsConstant.constant = 14
        if addMember == true{
        for i in addedMember{
            if allUser.id == i.userid{
                cell.buttonImageView.setImage(UIImage(named: "CircleRight")!)
                cell.heightConstraintsConstant.constant = 18
                cell.widthConstraintsConstant.constant = 18
                selectedUser.append(allUser)
            }
        }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
}

extension AddPeopleGroupVC: AddPeopleDelegate{
    func addPeople(at index: IndexPath, selected: Bool) {
        if selected{
            selectedUser.append(allFollwedUser[index.row])
            if let groupMember = allFollwedUser[index.row].id as? String{
                selectedMember.append(groupMember)
            }
        }else{
            if let groupMember = allFollwedUser[index.row].id as? String{
                while selectedMember.contains(groupMember) {
                    if let itemToRemoveIndex = selectedMember.firstIndex(of: groupMember) {
                        selectedMember.remove(at: itemToRemoveIndex)
                    }
                }
            }
            
            if let allMember = allFollwedUser[index.row] as? SuggestedUser{
                if let idx = selectedUser.firstIndex(where: { $0 === allMember }) {
                    selectedUser.remove(at: idx)
                }
            }
        }
        
        if selectedMember.count > 0{
            self.nextButtonView.isHidden = false
        }else{
            self.nextButtonView.isHidden = true
        }
    }
    
}

