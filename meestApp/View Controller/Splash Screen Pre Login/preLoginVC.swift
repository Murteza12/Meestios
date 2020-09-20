//
//  preLoginVC.swift
//  meestApp
//
//  Created by Yash on 8/5/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import AuthenticationServices

class preLoginVC: RootBaseVC {

    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var signupBtn:UIButton!
    @IBOutlet weak var googleBtn:UIButton!
    @IBOutlet weak var appleBtn:UIButton!
    @IBOutlet weak var stackview:UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpSignInAppleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.btnLogin.applyGradient(with:  [UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1)], gradient: .horizontal)
        self.btnLogin.cornerRadius(radius: 10)
        
        self.signupBtn.applyGradient(with:  [UIColor(red: 0.976, green: 0.471, blue: 0.153, alpha: 1),UIColor(red: 0.976, green: 0.247, blue: 0.31, alpha: 1),UIColor(red: 0.498, green: 0.106, blue: 0.725, alpha: 1)], gradient: .horizontal)
        self.signupBtn.cornerRadius(radius: 10)
        
        self.googleBtn.cornerRadius(radius: self.googleBtn.frame.height / 2)
        self.appleBtn.cornerRadius(radius: self.appleBtn.frame.height / 2)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }

    func setUpSignInAppleButton() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            self.appleBtn.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            
           
        } else {
            // Fallback on earlier versions
        }
      
    }
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    
    }
}
extension preLoginVC:ASAuthorizationControllerDelegate {
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                 switch credentialState {
                    case .authorized:
                        // The Apple ID credential is valid.
                        break
                    case .revoked:
                        // The Apple ID credential is revoked.
                        break
                 case .notFound: break
                        // No credential was found, so show the sign-in UI.
                    default:
                        break
                 }
            }
        }
    }
    
}
