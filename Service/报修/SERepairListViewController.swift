//
//  SERepairListViewController.swift
//  Service
//
//  Created by Murphy on 29/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MJRefresh
import SVProgressHUD


class SERepairListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var segmentedControl:HMSegmentedControl?
    
    var dataArray:[RepairListItem] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    
    var status = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.segmentedControl = HMSegmentedControl(sectionTitles: ["未处理","已确认","已反馈"])
        self.segmentedControl?.setSelectedSegmentIndex(0, animated: true)
        self.segmentedControl?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        self.segmentedControl?.selectionStyle = .fullWidthStripe
        self.segmentedControl?.selectionIndicatorLocation = .down
        self.segmentedControl?.selectionIndicatorColor = UIColor.yellow
        self.segmentedControl?.selectionIndicatorHeight = 0.5
        self.segmentedControl?.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.gray]
        self.segmentedControl?.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        self.segmentedControl?.addTarget(self, action: #selector(segmentedChange(control:)), for: UIControlEvents.valueChanged)
        
        self.topView.addSubview(self.segmentedControl!)
        
        self.tableView.register(UINib(nibName: "SEListTableViewCell", bundle: nil), forCellReuseIdentifier: "SEListTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let header =  MJRefreshNormalHeader {
            self.refresh()
        }
        self.tableView.mj_header = header
        
        self.tableView.mj_header.beginRefreshing()
    }
    @objc func segmentedChange(control:HMSegmentedControl) {
        
        if control.selectedSegmentIndex == 0 {
            // 未处理

            status = 0
        }else if control.selectedSegmentIndex == 1 {
            // 已确认
            status = 4
        }else if control.selectedSegmentIndex == 2 {
            // 已反馈
            status = 2
        }
        self.tableView.mj_header.beginRefreshing()
    }
    func refresh() {
        self.requestList(status: status)
    }

    func requestList(status:Int) {
        SENetworkAPI.sharedInstance.repairList(status: status) { (response) in
            self.tableView.mj_header.endRefreshing()
            
            if response.error != nil {
                let error = response.error
                var msg = error?.localizedDescription
                if (error?.userInfo != nil) {
                    if(error?.userInfo.keys.contains("message"))! {
                        msg = (error?.userInfo["message"] as! String)
                    }
                }
                SVProgressHUD.showError(withStatus: msg)
            }else {
                let decoder = JSONDecoder()
                let model = try! decoder.decode(RepairListResponse.self, from: response.response!)
                self.dataArray = (model.infos?.items)!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SEListTableViewCell", for: indexPath)
        let item = self.dataArray[indexPath.row]
        cell.textLabel?.text = item.repairContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (status == 4) {
            let item = self.dataArray[indexPath.row]
            self.showFeedback(item: item)
        }
    }
    func showFeedback(item:RepairListItem) {
        
        let action1 = UIAlertAction(title: "满意", style: .default) { (action) in
            self.requestFeedback(item: item, feedback: action.title)
        }
        let action2 = UIAlertAction(title: "不满意", style: .default) { (action) in
            self.requestFeedback(item: item, feedback: action.title)
        }
        let action3 = UIAlertAction(title: "一般", style: .default) { (action) in
            self.requestFeedback(item: item, feedback: action.title)
        }
        let action4 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        let alert = UIAlertController(title: "反馈", message: "请选择反馈内容", preferredStyle: .actionSheet)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        
        self.present(alert, animated: true) {
            
        }
    }
    
    func requestFeedback(item:RepairListItem,feedback:String?) {
        if feedback?.isEmpty == true {
            return;
        }
        SVProgressHUD.show()
        SENetworkAPI.sharedInstance.repairReportFeedback(item: item, feedback: feedback!) { (response) in
            if response.error != nil {
                let error = response.error
                var msg = error?.localizedDescription
                if (error?.userInfo != nil) {
                    if(error?.userInfo.keys.contains("message"))! {
                        msg = (error?.userInfo["message"] as! String)
                    }
                }
                SVProgressHUD.showError(withStatus: msg)
            }else {
                SVProgressHUD.dismiss()
                self.tableView.mj_header.beginRefreshing()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
