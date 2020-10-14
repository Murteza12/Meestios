//
//  Alert.swift
//  SensualGlow
//
//  Created by Murteza on 31/01/2020.
//  Copyright © 2020 Awais Malik. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class Alert {
    
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
