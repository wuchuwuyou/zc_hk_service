//
//  SEModel.swift
//  Service
//
//  Created by Murphy on 24/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit


class SEModel: NSObject {
    
    var _loginModel:LoginModel?
    var loginUser:LoginUser?
    var loginModel:LoginModel? {
        get{
            return _loginModel
        }
        set {
            _loginModel = newValue
        }
    }
    
    static let shared = SEModel()
    
    private override init() {}
}

class SEMainListModel: NSObject {
    var imageName:String = ""
    var title:String = ""
    var type:Service_type = Service_type.default_service
    class func initWithInfo(title:String,imageName:String,type:Service_type) -> SEMainListModel {
        let model = SEMainListModel()
        model.title = title
        model.imageName = imageName
        model.type = type
        return model
    }
}

enum Service_type:String {
    case baoxiu_service = "baoxiu"
    case tousu_service = "tousu"
    case default_service = "default"
}

struct LoginUser {
    let username:String
    let password:String
}

struct LoginModel:Codable {
    let role:String
    let userName:String
    let roleName:String
    let companyId:Int
    let company:String
    let appLogo:String
    struct DeviceItem :Codable{
        let classifyId:Int
        let typeCode:String
        let nameCn:String
    }
    let DeviceItems:[DeviceItem]
}
