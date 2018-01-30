//
//  SERepairEventViewController.swift
//  Service
//
//  Created by Murphy on 27/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol RepairEventDelegate {
    func selectRepairEvent(events: [RepairOrgItem])
}

class SERepairEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var submitBrn: UIButton!
    
    
    let collation = UILocalizedIndexedCollation.current()
    var sections:[[Any]] = []
    var titles:[String] = []
    var delegate:RepairEventDelegate?
    
    var selectArray:[RepairOrgItem] = []
    
    var dataArray:[RepairOrgItem] = [] {
        didSet {
            let selector: Selector = #selector(getter: RepairOrgItem.objName)
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
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.submitBrn.setTitle("选好了", for: .normal)
        self.submitBrn.setTitleColor(UIColor.white, for: .normal)
        self.submitBrn.backgroundColor = UIColor.AppColor()
        self.submitBrn.layer.cornerRadius = 3
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.isEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.requestRepairEvent()
    }
    func requestRepairEvent() {
        SENetworkAPI.sharedInstance.repairEventInfo { (response) in
            if response.error != nil {
                
                SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
                return;
            }
            let decoder = JSONDecoder()
            let orgItems = try! decoder.decode(RepairEventItems.self, from: response.response!)
            self.dataArray = (orgItems.infos?.contentItems)!
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titles
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        //        if cell == nil {
        //            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        //        }
        cell.selectionStyle = .default
        let model = sections[indexPath.section][indexPath.row] as? RepairOrgItem
        // Configure the cell...
        cell.textLabel?.text = model?.objName
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let type = UITableViewCellEditingStyle.delete.rawValue | UITableViewCellEditingStyle.insert.rawValue
        return UITableViewCellEditingStyle(rawValue: type)!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section][indexPath.row] as? RepairOrgItem
        self.selectArray.append(model!)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section][indexPath.row] as? RepairOrgItem
        self.selectArray.remove(at: self.selectArray.index(of: model!)!)
    }
    @IBAction func submitAction(_ sender: Any) {
        if self.selectArray.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择报修事件")
            return
        }
        self.delegate?.selectRepairEvent(events: self.selectArray)
        self.navigationController?.popViewController(animated: true)
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
