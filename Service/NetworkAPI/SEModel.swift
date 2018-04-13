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
    var menu:[SEMenuItem]?
    static let shared = SEModel()
    
    private override init() {}
}



class SEMenuChildItem: NSObject,Codable {
    var fatherId:Int = -1
    var link:String = ""
    var menuId:Int = -1
    var menuName:String = ""
    var orderIndex:Int = -1
}
class SEMenuItem: NSObject,Codable {
    var hasChild:Int = -1
    var icon:String = ""
    var number:Int = -1
    var menuId:Int = -1
    var menuName:String = ""
    var orderIndex:Int = -1
    var children:[SEMenuChildItem]? = []
}
class SEMenuResp:NSObject,Codable {
    var menus:[SEMenuItem]? = []
    var resp:respModel? = respModel(responseCommand: "", failReason: "")
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

enum Service_type:Int {
    case baoxiu_service = 79
    case tousu_service = 80
    case survey_service = 83
    case default_service = -1
}

class LoginUser:NSObject,Codable {
    var username:String = ""
    var password:String = ""
    @objc var user_name:String = ""
    class func initWithInfo(username:String,password:String,name:String) ->LoginUser {
        let model = LoginUser()
        model.username = username
        model.password = password
        model.user_name = name
        return model
    }
//    func name() -> String {
//       return self.user_name
//    }
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

struct ListRespModel:Codable {
    let resp:respModel?
    let pageInfos:pagesModel?
    
    struct infos:Codable {
        let item:[ListDataModel]
    }
    let infosItem:infos?
}


struct ListDataModel:Codable {
    let id:Int?
    let title:String?
    let content:String?
    let status:Int?
    let solveAccount:String?
    let solveContent:String?
    let solveTime:String?
}

struct pagesModel:Codable {
    let index:Int?
    let number:Int?
    let totalNumber:Int?
}

struct respModel:Codable {
    let responseCommand:String?
    let failReason:String?
}

struct RepairInfo:Codable {
    
    struct RepairInfoItem:Codable {
        let buildingNumber:String?
        let floor:String?
        let orgId:Int?
        let orgName:String?
        let phoneNumber:String?
    }
    let resp:respModel?

    let infos:RepairInfoItem?
}

class RepairOrgItem: NSObject,Codable {
    var objId:Int? = 0
    @objc var objName:String? = ""
    init(objId:Int,objName:String) {
        self.objId = objId
        self.objName = objName
    }
}

struct RepairOrgItems:Codable {
    let resp:respModel?
    let pageInfos:pagesModel?
    
    struct orgInfos:Codable {
        let orgItems:[RepairOrgItem]
    }
    let infos:orgInfos?
    
}

struct RepairEventItems:Codable {
    let resp:respModel?
    let pageInfos:pagesModel?
    struct orgInfos:Codable {
        let contentItems:[RepairOrgItem]
    }
    let infos:orgInfos?
}

struct RepairAreaInfo:Codable {
    let resp:respModel?
    let pageInfos:pagesModel?
    let infos:areaInfo?
    
    struct areaInfo:Codable {
        let areaTypeItems:[RepairOrgItem]?
        let areaItems:[RepairAreaItem]?
    }
}
struct RepairAreaItem:Codable {
    let items:[RepairOrgItem]?
    var objId:Int? = 0
    var objName:String? = ""
}


struct RepairListResponse:Codable {
    let resp:respModel?
    struct Items:Codable {
        let items:[RepairListItem]?
    }
    let infos:Items?
}

struct RepairListItem:Codable {
    struct RequisitionItem:Codable {
        let applicationContent:String?
        let applicationTime:String?
        let applicationUser:String?
        let status:Int?
    }
    let materialRequisitionItems:[RequisitionItem]?
    
    let maintainTime:String?
    let maintainContent:String?
    let repairContent:String?
    let repairFeedback:String?
    let repairNumber:String?
    let repairOrgId:Int?
    let repairOrgName:String?
    let repairStatus:Int?
    let repairTime:String?
    let repairTypeId:Int?
    let repairTypeName:String?
    let repairUser:String?
    let repairUserPhone:String?
    let unFinishedReason:String?
}

class SurveyProModel:Codable {
    var sProId:Int?
    var sProName:String?
    var type:SurveyTypeModel?
    var complainContent:String?
}
class SurveyTypeModel:Codable {
    var typeId:Int?
    var typeName:String?
}

class ProItem:Codable {
    var suProItems:[SurveyProModel]?
    var valueTypeId:Int?
    var valueTypeName:String?
}
class SurveyInfo:Codable {
    var evTypeItems:[SurveyTypeModel]?
    var sProItems:[ProItem]?
}

class SurveyModel:Codable {
    var resp:respModel?
    var infos:SurveyInfo?
}
class SurveyCommitModel: Codable {
    var evaluateType:Int?
    var evaluateValue:String?
    var surveyProject: String? = ""
    var surveyProjectId:Int?
}

class SurveyListModel:Codable {
    var resp:respModel?
    var infos:SurveyListItemsModel
}
class SurveyListItemsModel: Codable {
    var items:[SurveyListItemModel]?
}

class SurveyListItemModel: Codable {
    var evaluateItems:[SurveyCommitModel]?
    var submitDate:String?
    var submitUser: String?
    var surveyCode: String?
}

