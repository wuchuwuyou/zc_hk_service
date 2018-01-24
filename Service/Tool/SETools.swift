//
//  SETools.swift
//  Service
//
//  Created by Murphy on 23/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

struct HostModel:Codable {
    var host:String
    var port:String
    var method:String
    var description:String
    
    func stringText() -> String {
        return method+"://"+host+":"+port
    }
}

class SETools: NSObject {
    static let host_store_name = "app_host"
    static let current_host = "app_current_host"
    
    class func currentHost()->HostModel {
        let json:String? = UserDefaults.standard.object(forKey: current_host) as? String
        let jsonData = json?.data(using: .utf8)
        let decoder = JSONDecoder()
        let host = try! decoder.decode(HostModel.self, from: jsonData!)
        return host
    }
    class func setCurrentHost(host:HostModel) -> Bool {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(host)
        let json = String(data: data, encoding: .utf8)!
        UserDefaults.standard.set(json, forKey: current_host)
        return UserDefaults.standard.synchronize()
    }
    
    class func hostList()-> [HostModel] {
        let jsonArray:[String]? = UserDefaults.standard.object(forKey: host_store_name) as? [String]
        var array:[HostModel] = []
        if jsonArray==nil {
            return []
        }
        for json in jsonArray! {
            let jsonData = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let host = try! decoder.decode(HostModel.self, from: jsonData)
            array.append(host)
        }
        return array
    }
    class func addHost(host:HostModel)->Bool {
        var array = self.hostList()
        var flag = true /// 是否可以存储
        for h in array {
            if(h.host == host.host && h.port == host.port && h.method == host.method && h.description == host.description) {
                print("存在了")
                flag = false
            }
        }
        if flag {
            array.append(host)
            return self.saveHostArray(array: array)
        }
        return false
    }
    class func saveHostArray(array:[HostModel]) ->Bool {
        var jsonArray:[String] = []
        for host in array {
            let encoder = JSONEncoder()
            let data = try! encoder.encode(host)
            let json = String(data: data, encoding: .utf8)!
            jsonArray.append(json)
        }
        UserDefaults.standard.set(jsonArray, forKey: host_store_name)
        return UserDefaults.standard.synchronize()
    }
    class func deleteHost(host:HostModel) -> Bool {
        let array = self.hostList()
        var save_array:[HostModel] = []
        
        for h in array {
            if(h.host == host.host && h.port == host.port && h.method == host.method && h.description == host.description) {
                print("存在了")
                save_array.append(h)
            }
        }
       return self.saveHostArray(array: save_array)
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

extension Data {
   
}
