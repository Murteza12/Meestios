//
//  APICall.swift
//  meestApp
//
//  Created by Yash on 8/6/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import Alamofire

class APICall {
    var urlCredential: URLCredential?
    static let sharedInstance = APICall()
    
//    private let session: Session = {
//
//        let trustManager = CertificatePinnerServerTrustManager()
//
//        return Session(serverTrustManager: trustManager)
//    }()
    private let session: Session = {
        
        let manager = ServerTrustManager(allHostsMustBeEvaluated:false, evaluators: ["socket.dbmdemo.com": DisabledTrustEvaluator()])
        return Session(serverTrustManager: manager)
        
//        let manager = ServerTrustManager(allHostsMustBeEvaluated:false, evaluators: ["meest.ams3.digitaloceanspaces.com": DisabledTrustEvaluator(), "https://socket.dbmdemo.com": DisabledTrustEvaluator()])
//        let configuration = URLSessionConfiguration.af.default
//
//        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    func printEveryThing(responseData:AFDataResponse<Any>,statusCode:Int,url:String,para:Any,header:Any) {
        
        print("----------------- URL --------------")
        print(url)
        print("----------------- URL --------------")
        print("\n")
        print("----------------- data --------------")
        print(responseData)
        print("----------------- data --------------")
        print("\n")
        print("----------------- statusCode --------------")
        print(statusCode)
        print("----------------- statusCode --------------")
        print("\n")
        print("----------------- Parameter --------------")
        print(para)
        print("----------------- Parameter --------------")
        print("\n")
        print("----------------- Header --------------")
        print(header)
        print("----------------- Header --------------")
        print("\n")
        
    }
    
    func alamofireCall(url:String,method:HTTPMethod,para:Any,header:HTTPHeaders,vc:UIViewController,completion: @escaping (String,AFDataResponse<Any>,Int) -> Void) {
        if Reachability.isConnectedToNetwork() {
            
            AF.request(url, method: method, parameters: para as? Parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (responseData) in
                self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: para, header: header)
                completion(url,responseData,responseData.response?.statusCode ?? 000)
            }
        } else {
            vc.showAlert(title: "Message", message: "No Internet connection")
        }
    }
    
}

//public final class CertificatePinnerTrustEvaluator: ServerTrustEvaluating {
//
//    public init() {}
//
//    func setupCertificatePinner(host: String) -> CertificatePinner {
//
//        let pinner = CertificatePinner("socket.dbmdemo.com")
//
//                pinner.debugMode = true
//                pinner.addCertificateHash("ZWEzMDdhZWY0MGFiZDRjYWJjYjU3NThiZjBiZGFjNmJiMDQ5MzRhOTJiOWUyZDNmYzk2MzJhMjc3ZmI1YzRlZQ==")
//
//                return pinner
//    }
//
//    public func evaluate(_ trust: SecTrust, forHost host: String) throws {
//
//        let pinner = setupCertificatePinner(host: host)
//
//        if (!pinner.validateCertificateTrustChain(trust)) {
//            print("failed: invalid certificate chain!")
//            throw AFError.serverTrustEvaluationFailed(reason: .noCertificatesFound)
//        }
//
//        if (!pinner.validateTrustPublicKeys(trust)) {
//            print ("couldn't validate trust for \(host)")
//
//            throw AFError.serverTrustEvaluationFailed(reason: .noCertificatesFound)
//        }
//    }
//}
//
//class CertificatePinnerServerTrustManager: ServerTrustManager {
//
//    let evaluator = CertificatePinnerTrustEvaluator()
//
//    init() {
//        super.init(allHostsMustBeEvaluated: false, evaluators: [:])
//    }

//    open override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
//
//        return evaluator
//    }
//}
