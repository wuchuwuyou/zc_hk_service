//
//  SEAboutViewController.swift
//  Service
//
//  Created by Murphy on 30/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEAboutViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "关于我们"
        self.nameLabel.text = "名称：" + "总务处信息管理中心"
        self.addressLabel.text = "地址：" + "锅炉房三层"
        self.phoneLabel.text = "电话：" + "87494948"
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
