//
//  SESurveyListTableViewController.swift
//  Service
//
//  Created by Murphy on 11/04/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class SESurveyListTableViewController: UITableViewController {
    
    var dataArray:[SurveyListItemModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = "满意度调查查询"

        
        self.tableView.register(UINib(nibName: "SEMyOpinionTableViewCell", bundle: nil), forCellReuseIdentifier: "SEMyOpinionTableViewCell")

        let header =  MJRefreshNormalHeader {
            self.requestList()
        }
        self.tableView.mj_header = header
        
        
        self.tableView.mj_header.beginRefreshing()

    }
    func requestList() {
        SENetworkAPI.sharedInstance.satisfactionSurveyList { (response) in
            self.tableView.mj_header.endRefreshing()
    
            if response.error != nil {
                let error = response.error
                var msg = error?.localizedDescription
                if (error?.userInfo != nil) {
                    if(error?.userInfo.keys.contains("message"))! {
                        msg = (error?.userInfo["message"] as! String)
                    }
                }
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: msg)
            }else {
                let decoder = JSONDecoder()
                let model = try! decoder.decode(SurveyListModel.self, from: response.response!)
                self.dataArray = model.infos.items!
                self.tableView.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SEMyOpinionTableViewCell", for: indexPath) as! SEMyOpinionTableViewCell
        //        cell.selectionStyle = .default
        let item = self.dataArray[indexPath.row]
        cell.configCell(title: "调查编号：\(item.surveyCode!)", content: "提交人员：\(item.submitUser!)", index: String(indexPath.row + 1))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataArray[indexPath.row]
        let detail = SESurveyDetailViewController(nibName: "SESurveyDetailViewController", bundle: nil)
        detail.items = item.evaluateItems
        self.navigationController?.pushViewController(detail, animated: true)

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
