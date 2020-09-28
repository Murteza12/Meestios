//
//  DeleteOptionViC.swift
//  meestApp
//
//  Created by Rahul Kashyap on 24/09/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit

class DeleteOptionForEveryOneVC: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var deleteForEveryone: UIView!
    var deleteForEveryOneCompletion: (()->())?
    var deletedCompletion: (()->())?
    var cancelCompletion: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.deleteForEveryone.cornerRadius(radius: 15)
    }
    
    @IBAction func deleteForEveryOneButtonAction(_ sender: Any) {
        dismiss(animated: true) {
            self.deleteForEveryOneCompletion?()
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true) {
            self.cancelCompletion?()
        }
    }
    
    @IBAction func DeleteChatMeButtonAction(_ sender: Any) {
        dismiss(animated: true) {
            self.deletedCompletion?()
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
