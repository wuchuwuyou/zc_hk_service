//
//  SEPersonalInfoViewController.swift
//  Service
//
//  Created by Murphy on 30/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEPersonalInfoViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "用户信息"

        
        let model = SEModel.shared.loginModel
        self.label1.text = "姓名：" + (model?.userName)!
        self.label2.text = "公司：" + (model?.company)!
        self.label3.text = "角色：" + (model?.roleName)!
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
