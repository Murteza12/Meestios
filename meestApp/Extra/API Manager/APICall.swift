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
    
    static let sharedInstance = APICall()
    
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
