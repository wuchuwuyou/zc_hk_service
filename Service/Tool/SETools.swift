//
//  SETools.swift
//  Service
//
//  Created by Murphy on 23/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SETools: NSObject {

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
