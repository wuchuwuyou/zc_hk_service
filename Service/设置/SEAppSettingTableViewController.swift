//
//  SEAppSettingTableViewController.swift
//  Service
//
//  Created by Murphy on 30/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEAppSettingTableViewController: UITableViewController {
    
    var dataArray:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = "智慧医院后勤管理平台"
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion :String? = infoDictionary? ["CFBundleShortVersionString"] as? String//主程序版本号

        let version =  ["icon":"版本检测","title":"版本检测","content":majorVersion]
        let setting = ["icon":"系统设置","title":"系统设置","content":""]
        let about = ["icon":"设置","title":"关于我们","content":""]
        self.dataArray = [version,setting,about]

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.tableView.tableFooterView = UIView()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.selectionStyle = .default
        let content = self.dataArray[indexPath.row]
        // Configure the cell...
        cell.imageView?.image = UIImage(named: content["icon"] as! String)
        cell.textLabel?.text = content["title"] as? String
        let sub = content["content"] as? String
        if (sub?.isEmpty == false) {
            cell.detailTextLabel?.text = sub
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = self.dataArray[indexPath.row]
//        let content = item["content"] as! String
        
        if (indexPath.row == 1) {
            let hostSetting = SESettingHostViewController(nibName: "SESettingHostViewController", bundle: nil)
            self.navigationController?.pushViewController(hostSetting, animated: true)

        }else if (indexPath.row == 2) {
            let about = SEAboutViewController(nibName: "SEAboutViewController", bundle: nil)
            self.navigationController?.pushViewController(about, animated: true)
        }
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
