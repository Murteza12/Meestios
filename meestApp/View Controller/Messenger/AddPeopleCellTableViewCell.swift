//
//  AddPeopleCellTableViewCell.swift
//  meestApp
//
//  Created by Rahul Kashyap on 27/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

protocol AddPeopleDelegate {
    func addPeople(at index: IndexPath, selected: Bool)
}
class AddPeopleCellTableViewCell: UITableViewCell {

    @IBOutlet weak var heightConstraintsConstant: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintsConstant: NSLayoutConstraint!
    @IBOutlet weak var chatHeadsImageView: UIImageView!
    @IBOutlet weak var buttonImageView: UIImageView!
    @IBOutlet weak var names: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var indexPath: IndexPath?
    var delegate:AddPeopleDelegate?
    var isButtonSelected:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.buttonImageView.setImage(UIImage(named: "AddPeople")!)
        self.chatHeadsImageView.cornerRadius(radius: self.chatHeadsImageView.frame.height / 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func addPeopleButtonAction(_ sender: Any) {
        
        if self.buttonImageView.image == UIImage(named: "AddPeople")!{
            self.buttonImageView.setImage(UIImage(named: "CircleRight")!)
            heightConstraintsConstant.constant = 18
            widthConstraintsConstant.constant = 18
            delegate?.addPeople(at: indexPath!, selected: true)
        }else{
            self.buttonImageView.setImage(UIImage(named: "AddPeople")!)
            delegate?.addPeople(at: indexPath!, selected: false)
            heightConstraintsConstant.constant = 10
            widthConstraintsConstant.constant = 14
        }
        
    }
    
}
