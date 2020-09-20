//
//  customTabbarVC.swift
//  meestApp
//
//  Created by Yash on 8/7/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import Kingfisher

class customTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.sharedInstance.getCurrentUser(vc: self) { (user) in
            let img = UIImageView()
            let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 30, height: 30))
            
            img.kf.indicatorType = .activity
            img.kf.setImage(with: URL(string: user.dp),placeholder: nil,options: [.transition(.fade(1)),.processor(RoundCornerImageProcessor.init(cornerRadius: 15)),.processor(resizingProcessor)]) { result in
                switch result {
                case .success(let value):
                    let myTabBarItem2 = (self.tabBar.items?[4])! as UITabBarItem
                    
                    myTabBarItem2.image = img.image?.resizedImage(newWidth: 30).roundedImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                    myTabBarItem2.selectedImage = img.image?.resizedImage(newWidth: 30).roundedImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                    myTabBarItem2.title = ""
                    
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print(user.dp)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if self.selectedIndex == 2 {
//            
//            let dvc = self.storyboard?.instantiateViewController(withIdentifier: "addPostPopupVC") as! addPostPopupVC
//            if #available(iOS 13.0, *) {
//                dvc.modalPresentationStyle = .automatic
//            } else {
//                // Fallback on earlier versions
//            }
//            self.present(dvc, animated: true, completion: nil)
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImage{
var roundedImage: UIImage {
    let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
    UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
    UIBezierPath(
        roundedRect: rect,
        cornerRadius: self.size.height
        ).addClip()
    self.draw(in: rect)
    return UIGraphicsGetImageFromCurrentImageContext()!
}
func resizedImage(newWidth: CGFloat) -> UIImage {
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
}
