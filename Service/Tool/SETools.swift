//
//  SETools.swift
//  Service
//
//  Created by Murphy on 23/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import CoreGraphics

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
    
}
class HostUserDefaults: SETools  {
    static let host_store_name = "app_host"
    static let current_host = "app_current_host"
    
    class func currentHost()->HostModel {
        let json:String? = UserDefaults.standard.object(forKey: current_host) as? String
        let jsonData = json?.data(using: .utf8)
        if (json == nil || jsonData == nil) {
            return HostModel(host: "", port: "", method: "", description: "")
        }
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
                
            }else {
                save_array.append(h)
            }
        }
        return self.saveHostArray(array: save_array)
    }
}


class LoginUserDefaults: SETools {
    
    static let login_userDefaults = "login_userDefaults"
    
    class func loginUserList() ->[LoginUser] {
        var jsonArray:[String]? = UserDefaults.standard.object(forKey: login_userDefaults) as? [String]
        var array:[LoginUser] = []
        if jsonArray == nil {
            jsonArray = []
        }
        for json in jsonArray! {
            let jsonData = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            let user = try! decoder.decode(LoginUser.self, from: jsonData)
            array.append(user)
        }
        return array
    }
    class func addLoginUser(info:LoginUser) -> Bool {
        var array = self.loginUserList()
        var flag = true /// 是否可以存储
        for h in array {
            if(h.username == info.username && h.password == info.password && h.user_name == info.user_name ) {
                print("存在了")
                flag = false
            }
        }
        if flag {
            array.append(info)
            return self.saveUserListArrray(array: array)
        }
        return false
    }
    class func removeLoginUser(info:LoginUser) -> Bool {
        let array = self.loginUserList()
        var save_array:[LoginUser] = []
        
        for h in array {
            if(h.username == info.username && h.password == info.password && h.user_name == info.user_name ) {
                print("存在了")
            
            }else {
                save_array.append(h)
            }
        }
        return self.saveUserListArrray(array: save_array)
    }
    
    class func saveUserListArrray(array:[LoginUser]) ->Bool {
        var jsonArray:[String] = []
        for user in array {
            let encoder = JSONEncoder()
            let data = try! encoder.encode(user)
            let json = String(data: data, encoding: .utf8)!
            jsonArray.append(json)
        }
        UserDefaults.standard.set(jsonArray, forKey: login_userDefaults)
        return UserDefaults.standard.synchronize()
    }
    
//    class func userNameGroup() ->[String:[LoginUser]] {
//        
//    }
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

extension UIColor {
    class func AppColor()-> UIColor {
        //[UIColor colorWithRed:0.059 green:0.310 blue:0.478 alpha:1.00]
        return UIColor(red: 0.059, green: 0.310, blue: 0.478, alpha: 1.00)
    }
    
    class func bgColor() -> UIColor {
//        [UIColor colorWithRed:0.980 green:0.980 blue:0.980 alpha:1.00]
        return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
    }
    class func buttonColor() -> UIColor {
        // [UIColor colorWithRed:0.992 green:0.651 blue:0.267 alpha:1.00]
        return UIColor(red: 0.992, green: 0.651, blue: 0.267, alpha: 1.00)
    }
}

extension UIImage {
    class func imageWithColor(color:UIColor) ->UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        
        context!.setFillColor(color.cgColor);

        context?.addRect(rect)

        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
