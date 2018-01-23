//
//  SENetworkAPI.swift
//  Service
//
//  Created by Murphy on 23/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import Alamofire

class SENetworkAPI: NSObject {
    static let sharedInstance = SENetworkAPI()
    private override init() {}
    
    var host = "http://60.29.131.62:11000"
    public func login(ac:String!,pwd:String!)-> Void {
        let loginURL = host+"?cmd=APPLoginCmd"
        let params :Parameters = ["password":pwd,"userName":ac,"cmd":"APPLoginCmd"]
        
        Alamofire.request(loginURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { response in
            
        }
       
    }
}
