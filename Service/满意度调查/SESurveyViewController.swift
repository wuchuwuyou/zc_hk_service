//
//  SESurveyViewController.swift
//  Service
//
//  Created by Murphy on 10/04/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class SESurveyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    var model:SurveyModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "满意度调查"

        
        self.tableview.register(UINib(nibName: "SERadioTableViewCell", bundle: nil), forCellReuseIdentifier: "SERadioTableViewCell")
        self.tableview.register(UINib(nibName: "SETextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "SETextViewTableViewCell")
        self.sendBtn.setTitle("提交", for: .normal)
        self.sendBtn.setTitleColor(UIColor.white, for: .normal)
        self.sendBtn.backgroundColor = UIColor.AppColor()
        self.sendBtn.layer.cornerRadius = 2
        self.sendBtn.addTarget(self, action: #selector(submitResult), for: .touchUpInside)
        
        self.requestData()
        
        let item = UIBarButtonItem(title: "查询", style: .plain, target: self, action: #selector(showSurveyList))
        self.navigationItem.rightBarButtonItem = item

    }
    @objc func showSurveyList() {
        let my = SESurveyListTableViewController(nibName: "SESurveyListTableViewController", bundle: nil)
        self.navigationController?.pushViewController(my, animated: true)
    }
    func requestData() {
        SVProgressHUD.show()
        SENetworkAPI.sharedInstance.satisfactionSurveyQuery { (response) in
            if response.error != nil {
                let error = response.error
                var msg = error?.localizedDescription
                if (error?.userInfo != nil) {
                    if(error?.userInfo.keys.contains("message"))! {
                        msg = (error?.userInfo["message"] as! String)
                    }
                }
                self.tableview.reloadData()
                SVProgressHUD.showError(withStatus: msg)
            }else {
                let decoder = JSONDecoder()
                self.model = try! decoder.decode(SurveyModel.self, from: response.response!)
                self.tableview.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    @objc func submitResult() {
        self.setEditing(false, animated: true)
        let spItems:[ProItem]? = self.model?.infos?.sProItems
        if spItems == nil {
            return;
        }
        var arr:[[String:Any]] = []
        for item in spItems! {
            for sp in item.suProItems! {
                var sc:[String:Any] = [:]
                if item.valueTypeId == 1 {
                    //文本
                    if sp.complainContent == nil {
                        sp.complainContent = ""
                    }
                    sc["evaluateValue"] = sp.complainContent
                }else if item.valueTypeId == 0 {
                    // 单选
                    if sp.type == nil {
                        SVProgressHUD.showError(withStatus: "请完成选项")
                        return
                    }
                    sc["evaluateValue"] = "\(sp.type!.typeId!)"
                }
                sc["surveyProjectId"] = sp.sProId
                sc["evaluateType"] = item.valueTypeId
                arr.append(sc)
            }
        }
        
        SVProgressHUD.show()
        SENetworkAPI.sharedInstance.satisfactionSurveyCommit(items: arr) { (resp) in
            if resp.error != nil {
                
                SVProgressHUD.showError(withStatus: resp.error?.localizedDescription)
                return;
            }
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.model == nil {
            return 0
        }
        let arr:[ProItem] = (self.model?.infos?.sProItems)!
        return arr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items:[SurveyProModel] = (self.model?.infos?.sProItems![section].suProItems)!
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item:ProItem = (self.model?.infos?.sProItems![indexPath.section])!
//        var cell:SESurveyTableViewCell?
        if item.valueTypeId == 0 {
            //单选
            let cell = tableview.dequeueReusableCell(withIdentifier: "SERadioTableViewCell") as? SERadioTableViewCell
            let pro:SurveyProModel = item.suProItems![indexPath.row]
            cell!.configCell(type: (self.model?.infos?.evTypeItems)!, item: pro)
            cell?.callBack = {(obj)->Void in
                item.suProItems![indexPath.row] = obj!
            }

            return cell!;
        }else if item.valueTypeId == 1 {
            // 文本
            let cell = tableview.dequeueReusableCell(withIdentifier: "SETextViewTableViewCell") as? SETextViewTableViewCell
            let pro:SurveyProModel = item.suProItems![indexPath.row]
            cell!.configCell(type: (self.model?.infos?.evTypeItems)!, item: pro)
            cell?.callBack = {(obj)->Void in
                item.suProItems![indexPath.row] = obj!
            }

            return cell!;
        }
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
