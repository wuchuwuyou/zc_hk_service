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

class SEMyOpinionViewController: UIViewController {

    var segmentedControl:HMSegmentedControl?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var index = 1
    var status = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.segmentedControl = HMSegmentedControl(sectionTitles: ["已解决","未解决"])
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
        
        let header =  MJRefreshNormalHeader {
            self.refresh()
        }
        self.tableView.mj_header = header
        let footer = MJRefreshAutoNormalFooter {
            self.loadMore()
        }
        self.tableView.mj_footer = footer
        self.refresh()
    }

    @objc func segmentedChange(control:HMSegmentedControl) {
        
        if control.selectedSegmentIndex == 0 {
//            已解决
            index = 1
            status = 0
        }else if control.selectedSegmentIndex == 1 {
//            未解决
            index = 1
            status = 1
        }
        self.refresh()
    }
    func refresh() {
        self.loadData(status: status, index: index)
    }
    func loadMore() {
        index = index+1
        self.loadData(status: status, index: index)
    }
    func loadData(status:Int,index:Int) {
        SENetworkAPI.sharedInstance.opinionList(index: index, count: 20, status: status) { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
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
