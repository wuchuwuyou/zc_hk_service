//
//  SETools.swift
//  Service
//
//  Created by Murphy on 23/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SETools: NSObject {
    class func hostList()-> Array<Any> {
        return []
    }
}
class LoginUserDefaults: SETools {
    class func loginUserList() ->Array<Any> {
        return []
    }
    class func addLoginUser(info:Dictionary<String, Any>) -> Bool {
        return true
    }
    class func removeLoginUser(info:Dictionary<String, Any>) -> Bool {
        return true
    }
}

extension String {
    
    func decodeBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func encodeBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
