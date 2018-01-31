//
//  SEPersonalTableViewController.swift
//  Service
//
//  Created by Murphy on 07/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEPersonalTableViewController: UITableViewController {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    var dataArray:[[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "智慧医院后勤管理平台"

        self.topView.backgroundColor = UIColor.AppColor()
        let model = SEModel.shared.loginModel
        self.label1.text = model?.userName
        self.label2.text = (model?.roleName)! + "/" + (model?.company)!
        self.avatarImageView.image = UIImage(named: "icon")
//        self.dataArray = [["title":"空间清理","icon":"空间清理"],["title":"修改密码","icon":"修改密码"],["title":"退出登录","icon":"退出登录"]]
        self.dataArray = [["title":"退出登录","icon":"退出登录"]]
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.tableFooterView = UIView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showUserInfo))
        self.topView.addGestureRecognizer(tap)
    }

    @objc func showUserInfo() {
        let info = SEPersonalInfoViewController(nibName: "SEPersonalInfoViewController", bundle: nil)
        self.navigationController?.pushViewController(info, animated: true)
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
        
        // Configure the cell...
        cell.selectionStyle = .default
        let item = self.dataArray[indexPath.row]
        cell.imageView?.image = UIImage(named: item["icon"]!)
        cell.textLabel?.text = item["title"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 { //空间清理
//
//        }else if indexPath.row == 1 { // 修改密码
//
//        }else if indexPath.row == 2 { //退出登录
        if indexPath.row == 0 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let loginController = SENavigationViewController(rootViewController: SELoginViewController(nibName: "SELoginViewController", bundle: nil))
            appDelegate.window?.rootViewController = loginController

            }
//        }
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
