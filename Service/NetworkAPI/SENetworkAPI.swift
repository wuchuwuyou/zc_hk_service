//
//  SENetworkAPI.swift
//  Service
//
//  Created by Murphy on 23/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import Alamofire


struct SEError: Error {
    enum ErrorKind {
        case NetworkError
    }
    
    let code: Int
    let message: String
    let kind: ErrorKind
}


class SENetworkAPI: NSObject {
    static let sharedInstance = SENetworkAPI()
    private override init() {}
    var urlPath = "/ZCTJFirstCHospital/servlet/DevOpsService"
//    var host = "http://60.29.131.62:11000"
    var host = SETools.currentHost().stringText()
//    var Complete:((response: Any, error: Error) -> Void)
    public struct SEResponse {
        /// The server's response to the URL request.
        public let response: Data?
        
        
        /// The error encountered while executing or validating the request.
        public let error: SEError?
    }
    public func login(ac:String!,pwd:String!,complete:@escaping (SEResponse) -> Void){
        let loginURL = self.requestURL(cmd: "APPLoginCmd")
        let params :Parameters = ["password":pwd,"userName":ac,"companyId":"0","cmd":"APPLoginCmd"]
        
        Alamofire.request(loginURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { response in
            var error = response.error
            var data = response.data
            let err = self.handleJSONData(data: response.data)
            if (err != nil) {
                error = err
                data = nil
            }
            let resp = SEResponse(response: data, error: error as? SEError)
            complete(resp)
        }
    }
    func handleJSONData(data:Data?) -> Error? {
        let jsonData = data
        do {
            let json:[String:AnyObject] = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String : AnyObject]
            if json.keys.contains("responseCommand") {
                let success = json["responseCommand"]
                if (success?.isEqual("OK"))! {
                    return nil;
                }else {
                    return SEError(code: -1, message: "网络错误", kind: .NetworkError)
                }
            }else {
                return SEError(code: -1, message: "网络错误", kind: .NetworkError)
            }
        } catch let error as Error {
            return error
        }
    }
    func requestURL(cmd:String) -> String {
        return host+urlPath+"?cmd=\(cmd)"
    }
}
