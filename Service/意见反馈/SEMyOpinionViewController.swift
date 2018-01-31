//
//  SEMyOpinionViewController.swift
//  Service
//
//  Created by Murphy on 25/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MJRefresh
import SVProgressHUD

class SEMyOpinionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var segmentedControl:HMSegmentedControl?
    
    var dataArray:[ListDataModel] = []
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var index = 0
    var status = 0
    var page_count = 20
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的建议"
        self.segmentedControl = HMSegmentedControl(sectionTitles: ["已解决","未解决"])
        self.segmentedControl?.setSelectedSegmentIndex(0, animated: true)
        self.segmentedControl?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        self.segmentedControl?.selectionStyle = .fullWidthStripe
        self.segmentedControl?.selectionIndicatorLocation = .down
        self.segmentedControl?.selectionIndicatorColor = UIColor.yellow
        self.segmentedControl?.selectionIndicatorHeight = 2
        self.segmentedControl?.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.gray]
        self.segmentedControl?.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.segmentedControl?.backgroundColor = UIColor.AppColor()
        
        self.segmentedControl?.addTarget(self, action: #selector(segmentedChange(control:)), for: UIControlEvents.valueChanged)
        self.tableView.tableFooterView = UIView()

        self.topView.addSubview(self.segmentedControl!)
        self.topView.backgroundColor = UIColor.AppColor()
        self.tableView.register(UINib(nibName: "SEMyOpinionTableViewCell", bundle: nil), forCellReuseIdentifier: "SEMyOpinionTableViewCell")
        self.tableView.separatorStyle = .none
        let header =  MJRefreshNormalHeader {
            self.refresh()
        }
        self.tableView.mj_header = header
        let footer = MJRefreshAutoNormalFooter {
            self.loadMore()
        }
        self.tableView.mj_footer = footer
        
        self.tableView.mj_footer.isHidden = true
        
        self.tableView.mj_header.beginRefreshing()
    }

    @objc func segmentedChange(control:HMSegmentedControl) {
        
        if control.selectedSegmentIndex == 0 {
//            已解决
            index = 0
            status = 0
        }else if control.selectedSegmentIndex == 1 {
//            未解决
            index = 0
            status = 1
        }
        self.tableView.mj_header.beginRefreshing()
    }
    func refresh() {
        self.loadData(status: status, index: index)
    }
    func loadMore() {
        index = index + page_count
        self.loadData(status: status, index: index)
    }
    func loadData(status:Int,index:Int) {
        SENetworkAPI.sharedInstance.opinionList(index: index, count: page_count, status: status) { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            

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
                let model = try! decoder.decode(ListRespModel.self, from: response.response!)
                self.index = (model.pageInfos?.index)!

                if(index == 0) {
                    self.dataArray = (model.infosItem?.item)!
                }else {
                    let array = model.infosItem?.item
                    self.dataArray = self.dataArray + array!
                }
                if(self.dataArray.count < 20) {
                    self.tableView.mj_footer.isHidden = true
                }else {
                    self.tableView.mj_footer.isHidden = false
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SEMyOpinionTableViewCell", for: indexPath) as! SEMyOpinionTableViewCell
//        cell.selectionStyle = .default
        let item = self.dataArray[indexPath.row]
        cell.configOpinionCell(model: item, index: String(indexPath.row + 1))
        return cell
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
