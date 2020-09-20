//
//  createCampaignVC.swift
//  meestApp
//
//  Created by Yash on 9/9/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class CreateCampaignVC: RootBaseVC {

 @IBOutlet weak var Scroll_View: UIScrollView!

    @IBOutlet weak var Scroll_InView: UIView!
    @IBOutlet weak var Txt_Heading: UITextField!
    
    @IBOutlet weak var B_Pay_Amount: UIButton!
    @IBOutlet weak var lbl_Total_Amount: UILabel!
    @IBOutlet weak var txt_Day: UITextField!
    @IBOutlet weak var txt_Location: UITextField!
    @IBOutlet weak var txt_Call_Action: UITextField!
    @IBOutlet weak var txt_Gender: UITextField!
    @IBOutlet weak var txt_website: UITextField!
    @IBOutlet weak var Txt_Ad_text: UITextView!
    @IBOutlet weak var Ad_Img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()


        
        Txt_Ad_text.text = "Enter Campaign destails"
        Txt_Ad_text.textColor = UIColor(red: 100.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 0.30)
        Txt_Ad_text.delegate = self
        
        
        Txt_Heading.Create_Border()
        txt_website.Create_Border()
         Txt_Ad_text.Create_Border()
         txt_Gender.Create_Border()
         txt_Call_Action.Create_Border()
         txt_Day.Create_Border()
         txt_Location.Create_Border()
            Txt_Ad_text.Create_Border()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        Scroll_View.contentSize = Scroll_InView.frame.size
        let yourViewBorder = CAShapeLayer()
                yourViewBorder.strokeColor = UIColor.black.cgColor
                yourViewBorder.lineDashPattern = [4, 4]
                yourViewBorder.frame = Ad_Img.bounds
                yourViewBorder.fillColor = nil
                yourViewBorder.path = UIBezierPath(rect: Ad_Img.bounds).cgPath
                Ad_Img.layer.addSublayer(yourViewBorder)
        
        
        B_Pay_Amount.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    
    
    // MARK - button
    @IBAction func btn_Back(_ sender: Any) {
    }

     
    @IBAction func btn_Pay_Amount(_ sender: Any) {
    }
    
    @IBAction func B_Preview(_ sender: Any) {
    }
}
extension CreateCampaignVC : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Enter Campaign destails" && textView.textColor == UIColor(red: 100.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 0.30))
        {
            textView.text = ""
            textView.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Enter Campaign destails"
            textView.textColor = UIColor(red: 100.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 0.30)
        }
        textView.resignFirstResponder()
    }
}



extension UITextField {
    
    
    
    func Create_Border()
    {
        self.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        self.layer.cornerRadius = 8
        
        self.layer.borderWidth = 1
        
        self.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        
    }
}

extension UITextView {
    
    
    
    func Create_Border()
    {
        self.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        self.layer.cornerRadius = 8
        
        self.layer.borderWidth = 1
        
        self.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        
    }
}
