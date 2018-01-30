//
//  SELoginUserTableViewController.swift
//  Service
//
//  Created by Murphy on 02/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

protocol SelectUserDelegate {
    func selectUser(user:LoginUser)
}


class SELoginUserTableViewController: UITableViewController {
    let collation = UILocalizedIndexedCollation.current()
    var sections:[[Any]] = []
    var titles:[String] = []
    var delegate:SelectUserDelegate?
    var dataArray:[LoginUser] = [] {
        didSet {
            let selector: Selector = #selector(getter: LoginUser.user_name)
            sections = Array(repeating: [], count: collation.sectionTitles.count)
            
            let sortedObjects = collation.sortedArray(from: dataArray, collationStringSelector: selector)
            for object in sortedObjects {
                let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
            
            var source:[[Any]] = []
    
            for (index,subArray) in sections.enumerated() {
                if(subArray.count != 0) {
                    source.append(subArray)
                    titles.append(collation.sectionTitles[index])
                }
            }
            sections = source
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clea@objc @objc @objc rsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.dataArray = LoginUserDefaults.loginUserList()
        
        self.navigationItem.title = "选择用户"
//        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return titles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titles
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
//        }
        let model = sections[indexPath.section][indexPath.row] as? LoginUser
        // Configure the cell...
        cell.selectionStyle = .default
        cell.textLabel?.text = model?.user_name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section][indexPath.row] as? LoginUser
        self.delegate?.selectUser(user: model!)
        self.navigationController?.popViewController(animated: true)
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
