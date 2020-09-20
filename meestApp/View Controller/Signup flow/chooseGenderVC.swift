
//
//  chooseGenderVC.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class chooseGenderVC: RootBaseVC {

    @IBOutlet weak var maleView:UIView!
    @IBOutlet weak var femaleView:UIView!
    @IBOutlet weak var otherView:UIView!
    
    @IBOutlet weak var checkedMale:UIImageView!
    @IBOutlet weak var checkedFemale:UIImageView!
    @IBOutlet weak var checkedother:UIImageView!
    
    @IBOutlet weak var continueBtn:UIButton!
    @IBOutlet weak var lbl1:UILabel!
    var gender = "Male"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.continueBtn.cornerRadius(radius: 10)
        
       // self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        self.checkedMale.image = UIImage.init(named: "checked_2_2")
        self.femaleView.backgroundColor = UIColor(red: 0.949, green: 0.961, blue: 0.965, alpha: 1)
        self.otherView.backgroundColor = UIColor(red: 0.949, green: 0.961, blue: 0.965, alpha: 1)
        self.checkedother.image = nil
        self.femaleView.cornerRadius(radius: 7)
        self.maleView.cornerRadius(radius: 7)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    @IBAction func maleSelect(_ sender:UIButton) {
        
        self.maleView.backgroundColor = UIColor.white
        self.checkedMale.image = UIImage.init(named: "checked_2_2")
        
        self.femaleView.backgroundColor = UIColor(red: 0.949, green: 0.961, blue: 0.965, alpha: 1)
        self.checkedFemale.image = nil
        self.otherView.backgroundColor = UIColor(red: 0.949, green: 0.961, blue: 0.965, alpha: 1)
        self.checkedother.image = nil
        self.gender = "Male"
    }
    @IBAction func femaleSelect(_ sender:UIButton) {
        self.femaleView.backgroundColor = UIColor.white
        self.checkedFemale.image = UIImage.init(named: "checked_2_2")
        self.checkedMale.image = nil
        self.maleView.backgroundColor = UIColor(red: 0.949, green: 0.961, blue: 0.965, alpha: 1)
        self.otherView.backgroundColor = UIColor(red: 0.949, green: 0.961, blue: 0.965, alpha: 1)
        self.checkedother.image = nil
        self.gender = "Female"
    }
    @IBAction func otherSelect(_ sender:UIButton) {
        self.otherView.backgroundColor = UIColor.white
        self.checkedother.image = UIImage.init(named: "checked_2_2")
        
        self.checkedMale.image = nil
        self.maleView.backgroundColor = UIColor(red: 0.949, green: 0.961, blue: 0.965, alpha: 1)
        
        self.checkedFemale.image = nil
        self.femaleView.backgroundColor = UIColor(red: 0.949, green: 0.961, blue: 0.965, alpha: 1)
        self.gender = "Rather Not Specify"
    }
    
    @IBAction func submitBtn(_ sender:UIButton) {
        UserDefaults.standard.set(self.gender, forKey: "gender")
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
}
