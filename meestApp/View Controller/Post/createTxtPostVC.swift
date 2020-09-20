//
//  createTxtPostVC.swift
//  meestApp
//
//  Created by Yash on 9/8/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class createTxtPostVC: RootBaseVC,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate {

   
   
   
    @IBOutlet weak var img_Post_Bg: UIImageView!
    
     @IBOutlet weak var Txt_Post: UITextView!
    
     @IBOutlet weak var Collection_Bg: UICollectionView!
    
    @IBOutlet weak var lbl_Public_Or: UILabel!
    
    @IBOutlet weak var B_Post: UIButton!
    @IBOutlet weak var Collection_Font_Color: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.black.cgColor
        yourViewBorder.lineDashPattern = [5, 5]
        yourViewBorder.frame = img_Post_Bg.superview!.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: img_Post_Bg.superview!.bounds).cgPath
        img_Post_Bg.superview!.layer.addSublayer(yourViewBorder)
        
        Txt_Post.text = "Write a Text here:"
        Txt_Post.textColor = UIColor(red: 100.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 1)
        Txt_Post.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
      
        B_Post.applyGradient(with: [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
    }
    // MARK: - button
    
    @IBAction func btn_back(_ sender: Any) {
    }
    
    @IBAction func btn_Show_Post(_ sender: Any) {
    }
    
    @IBAction func S_Allow_Comments(_ sender: Any) {
    }
    
    // MARK - UITextView Delegates
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Write a Text here:" && textView.textColor == UIColor(red: 100.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 1))
        {
            textView.text = ""
            textView.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.80)
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Write a Text here:"
            textView.textColor = UIColor(red: 100.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 1)
        }
        textView.resignFirstResponder()
    }
    
    // MARK - CollcetionView Delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == Collection_Bg
        {
            return 10
        }
        else
        {
            return 10
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        if collectionView == Collection_Bg
        {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_Text_Bg", for: indexPath) as! Cell_Text_Bg
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_Font_Color", for: indexPath) as! Cell_Font_Color
            
            cell.Img_Font_Color.backgroundColor = UIColor.red
            
                cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor(red: 100.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 1).cgColor
            
                return cell
        }
       
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == Collection_Bg
        {
            
        }
        else
        {
            
            
        }
    }
}
class Cell_Text_Bg: UICollectionViewCell {
    
    @IBOutlet weak var Img_Bg: UIImageView!
}
class Cell_Font_Color: UICollectionViewCell {
    
    @IBOutlet weak var Img_Font_Color: UIImageView!
}
