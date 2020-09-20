//
//  dobVC.swift
//  meestApp
//
//  Created by Yash on 8/11/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Material
import DatePicker

class dobVC: RootBaseVC {

    @IBOutlet weak var txtFName:TextField!
    
    @IBOutlet weak var continueBtn:UIButton!
    
    @IBOutlet weak var dividerViewFname:UIView!
    
    @IBOutlet weak var mailImg:UIImageView!
    
    @IBOutlet weak var fnameView:UIView!
    
    @IBOutlet weak var errorLbl:UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.continueBtn.cornerRadius(radius: 10)
        
        self.txtFName.dividerActiveColor = .clear
        self.txtFName.dividerNormalColor = .clear
        self.txtFName.placeholderActiveColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        
        self.dividerViewFname.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        
        self.txtFName.delegate = self
        
        
        self.mailImg.tintColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 0.6)
        
        self.fnameView.isHidden = false
        
        self.errorLbl.textColor = UIColor(red: 0.954, green: 0.086, blue: 0.16, alpha: 1)
        self.errorLbl.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "dob") != nil {
            self.txtFName.text = UserDefaults.standard.string(forKey: "dob")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueBtn.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    @IBAction func openPicker(_ sender:UIButton) {
        self.dobPopup()
    }
    @IBAction func submitBtn(_ sender:UIButton) {
        self.loadAnimation()
        if self.txtFName.text == "" {
            self.errorLbl.isHidden = false
            self.errorLbl.text = "Please Select Your Birthdate"
            self.removeAnimation()
            return
        }
        UserDefaults.standard.set(self.txtFName.text, forKey: "dob")
        self.removeAnimation()
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
    func dobPopup() {
        
        let datePicker = DatePicker()
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1950)
        let middleDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1990)
        let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2014)
        datePicker.setup(beginWith: middleDate, min: minDate!, max: maxDate!) { (selected, date) in
        if selected, let selectedDate = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: selectedDate)
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "MM-dd-YYYY"
            let myStringafd = formatter.string(from: yourDate!)
            
            self.txtFName.text = myStringafd
            self.dividerViewFname.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mailImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
        } else {
            print("Cancelled")
            }
        }
        datePicker.display(in: self)
    }
}
extension dobVC:TextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtFName {
            self.dividerViewFname.backgroundColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            self.mailImg.tintColor = UIColor(red: 0.204, green: 0.192, blue: 0.439, alpha: 1)
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
