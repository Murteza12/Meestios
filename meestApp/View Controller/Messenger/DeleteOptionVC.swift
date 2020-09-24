//
//  DeleteOptionViC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 24/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class DeleteOptionVC: UIViewController {

    @IBOutlet var backGroundView: UIView!
    @IBOutlet var copyReplyDeleteView: UIView!
    var deleteCompletion: (()->())?
    var replyCompletion: (()->())?
    var copyCompletion: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        copyReplyDeleteView.cornerRadius(radius: 15)
    }
    
    @IBAction func copyButtonAction(_ sender: Any) {
        dismiss(animated: true) {
            self.copyCompletion?()
        }
    }
    
    @IBAction func replyButtonAction(_ sender: Any) {
        dismiss(animated: true) {
            self.replyCompletion?()
        }
    }
    
    @IBAction func DeleteButtonAction(_ sender: Any) {
        dismiss(animated: true) {
            self.deleteCompletion?()
        }
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
