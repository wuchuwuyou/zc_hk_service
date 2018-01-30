//
//  SENetworkAPI.swift
//  Service
//
//  Created by Murphy on 23/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import Alamofire
import DKImagePickerController


//struct SEError: Error {
//    enum ErrorKind {
//        case NetworkError
//    }
//
//    let code: Int
//    let message: String
//    let kind: ErrorKind
//}


class SENetworkAPI: NSObject {
    static let sharedInstance = SENetworkAPI()
    private override init() {}
    var urlPath = "/ZCTJFirstCHospital/servlet/DevOpsService"
//    var host = "http://60.29.131.62:11000"
    var host = HostUserDefaults.currentHost().stringText()
//    var Complete:((response: Any, error: Error) -> Void)
    public struct SEResponse {
        /// The server's response to the URL request.
        public let response: Data?
        
        
        /// The error encountered while executing or validating the request.
        public let error: NSError?
    }
    public func request(url:String,method:HTTPMethod,parameters: Parameters? = nil,encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil,complete:@escaping (SEResponse) -> Void) {
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).response { (response) in
            var error = response.error
            var data = response.data
            let err = self.handleJSONData(data: response.data)
            if (err != nil) {
                error = err
                data = nil
            }
            let resp = SEResponse(response: data, error: error as NSError?)
            complete(resp)
        }
    }
    public func login(ac:String!,pwd:String!,complete:@escaping (SEResponse) -> Void){
        let loginURL = self.requestURL(cmd: "APPLoginCmd")
        let params :Parameters = ["password":pwd,"userName":ac,"companyId":"0","cmd":"APPLoginCmd"]
        
        self.request(url: loginURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }
    }
    
    public func menuList(ac:String,complete:@escaping (SEResponse) -> Void) {
        let menu = self.requestURL(cmd: "APPMenuListSearchCmd")
        let params:Parameters = ["userAccount":ac]
        
        self.request(url: menu, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }
    }
    
    public func addOpinion(title:String!,content:String!,complete:@escaping (SEResponse) -> Void) {
        let addOpinionURL = self.requestURL(cmd: "ComplaintAndAdviceAddCmd")
        let item = ["content":content,"title":title,"status":"0","id":"-1"]
        let property = ["isApp":"1","userAccount":SEModel.shared.loginUser?.username,"status":"0"]
        let infoItem:Parameters = ["infosItem":["item":[item]],"property":property]
        
        self.request(url: addOpinionURL, method: .post, parameters: infoItem, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }

    }
    public func opinionList(index:Int!,count:Int,status:Int,complete:@escaping (SEResponse) -> Void) {
        let listURL = self.requestURL(cmd: "ComplaintAndAdviceSearchCmd")
        let pageInfos = ["index":index,"number":count,"totalNumber":-1]
        let property:Parameters = ["isApp":"1","endTime":"","userAccount":SEModel.shared.loginUser?.username as Any,"status":status]
        let params:Parameters = ["pageInfos":pageInfos,"property":property]
        self.request(url: listURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }
    }
    
    public func repairInfo(complete:@escaping (SEResponse) -> Void) {
        let infoURL = self.requestURL(cmd: "TemporaryRepairMessageInfosQueryCommand")
        let property = ["userAccount":SEModel.shared.loginUser?.username]
        let params = ["property":property]
        self.request(url: infoURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }

    }
    
    /// 科室查询
    public func repairClassInfo(complete:@escaping (SEResponse) -> Void) {
        let infoURL = self.requestURL(cmd: "TemRepairQueryListCommand")
        let pages = ["index":-1,"number":-1,"totalNumber":-1]
        let property:Parameters = ["hasArea":0,"hasAreaNumber":0,"hasAreaType":0,"hasContent":0,"hasPerson":0,"hasTemRepairOrg":1,"hasType":0,"personNameKey":"","userAccountName":SEModel.shared.loginUser?.username as Any]
        let params = ["pageInfos":pages,"property":property]
        self.request(url: infoURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }
    }
    
    /// 报修事件查询
    public func repairEventInfo(complete:@escaping (SEResponse) -> Void) {
        let infoURL = self.requestURL(cmd: "TemRepairQueryListCommand")
        let pages = ["index":-1,"number":-1,"totalNumber":-1]
        let property:Parameters = ["hasArea":0,"hasAreaNumber":0,"hasAreaType":0,"hasContent":1,"hasPerson":0,"hasTemRepairOrg":0,"hasType":0,"personNameKey":"","userAccountName":SEModel.shared.loginUser?.username as Any]
        let params = ["pageInfos":pages,"property":property]
        self.request(url: infoURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }
    }
    
    /// 报修区域查询
    public func repairRegionInfo(complete:@escaping (SEResponse) -> Void) {
        let infoURL = self.requestURL(cmd: "TemRepairQueryListCommand")
        let pages = ["index":-1,"number":-1,"totalNumber":-1]
        let property:Parameters = ["hasArea":1,"hasAreaNumber":1,"hasAreaType":1,"hasContent":0,"hasPerson":0,"hasTemRepairOrg":0,"hasType":0,"personNameKey":"","userAccountName":SEModel.shared.loginUser?.username as Any]
        let params = ["pageInfos":pages,"property":property]
        self.request(url: infoURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }
    }
    /*
     * content 报修内容 B区3层公共  测试
     * number 报修编号 （当前时间：yyyyMMddHHmmss）
     * orgId 报修科室ID
     * phone 提交维修人手机号
    */
    public func addRepairReport(content:String,number:String,orgId:Int,phone:String, complete:@escaping (SEResponse) -> Void) {
        let report = self.requestURL(cmd: "TemporaryRepairAddCommand")
        let item:Parameters = ["maintainContent":"","maintainTime":"","repairContent":content,"repairFeedback":"","repairNumber":number,"repairOrgId":orgId,"repairOrgName":"","repairStatus":0,"repairTime":"","repairTypeId":-1,"repairTypeName":"","repairUser":"","repairUserPhone":phone,"unFinishedReason":""]
        let property = ["status":-1,"userAccount":SEModel.shared.loginUser?.username as Any]
        let params = ["infos":["items":[item]],"property":property]
        
        self.request(url: report, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }

    }
    /*
     * status：报修单状态值（0-未处理  3-已分派 5—已接单 1-已维修 4-已确认 2-已反馈）
     */
    public func repairList(status:Int,complete:@escaping (SEResponse) -> Void) {
        let list = self.requestURL(cmd: "TemporaryRepairSearchCommand")
        let property:Parameters = ["status":status,"userAccount":SEModel.shared.loginUser?.username as Any]
        let params = ["property":property]
        
        self.request(url: list, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }
    }
    /// feedback  反馈内容
    public func repairReportFeedback(item:RepairListItem,feedback:String,complete:@escaping (SEResponse) -> Void) {
        let feedbackURL = self.requestURL(cmd: "TemporaryRepairUpdateCommand")
        let item:Parameters = ["maintainContent":item.maintainContent!,"maintainTime":item.maintainTime as Any,"repairContent":item.repairContent!,"repairFeedback":feedback,"repairNumber":item.repairNumber as Any, "repairOrgId":item.repairOrgId as Any,"repairOrgName":item.repairOrgName as Any,"repairStatus":1,"repairTime":item.repairTime!,"repairTypeId":item.repairTypeId!,"repairTypeName":item.repairTypeName as Any,"repairUser":"","repairUserPhone":"","unFinishedReason":""]
        let property:Parameters = ["status":3,"userAccount":SEModel.shared.loginUser?.username as Any]
        let params = ["property":property,"infos":["items":[item]]]
        
        self.request(url: feedbackURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil) { (response) in
            complete(response)
        }

    }
    
    public func uploadImages(number:String,images:[UIImage],complete:@escaping (SEResponse) -> Void) {
        let upload_image_url = self.requestURL(cmd: "TemporaryRepairFileUploadCommand")
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(number.data(using: .utf8)!, withName: "repairNumber")
            for image in images {
                let data = UIImageJPEGRepresentation(image, 0.9)
                formData.append(data!, withName: "img", fileName: String(format: "%d", image.hashValue), mimeType: "image/jpeg")
            }
        }, to: upload_image_url) { (encodingResult) in
            switch encodingResult {
                
                case .success(let request, let streamingFromDisk, let streamFileURL):
                    //连接服务器成功后，对json的处理
                    request.responseJSON { response in
                        //解包
                        guard let result = response.result.value else { return }
                        print("json:\(result)")
                    }
                    //获取上传进度
                    request.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        print("图片上传进度: \(progress.fractionCompleted)")
                }
                case .failure(let encodingError):
                    print(encodingError)
            }
        }
        
      
    }
    
    func handleJSONData(data:Data?) -> Error? {
        let jsonData = data
        do {
            var json:[String:AnyObject] = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String : AnyObject]
            if(json.keys.contains("resp")) {
                let resp = json["resp"] as! [String:AnyObject]
                if resp.keys.contains("responseCommand") {
                    json = resp
                }
            }
            if json.keys.contains("responseCommand") {
                let success = (json["responseCommand"] as! String).lowercased()
                if (success.isEqual("ok")) {
                    return nil;
                }else {
                    var msg = "网络错误"
                    if json.keys.contains("failReason") {
                        msg = (json["failReason"] as? String)!
                    }
                    return NSError(domain: host, code: -1, userInfo: ["message":msg])
//                    return SEError(code: -1, message: "网络错误", kind: .NetworkError)
                }
            }else {
                return NSError(domain: host, code: -1, userInfo: ["message":"网络错误"])
//                return SEError(code: -1, message: "网络错误", kind: .NetworkError)
            }
        } catch let error as NSError {
            return error
        }
    }
    func requestURL(cmd:String) -> String {
        return host+urlPath+"?cmd=\(cmd)"
    }
    func imageURL(name:String) -> String {
        return host+"/ZCTJFirstCHospital"+"/appicon/"+name
    }
}
