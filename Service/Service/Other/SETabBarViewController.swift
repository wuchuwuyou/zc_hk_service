//
//  SETabBarViewController.swift
//  Service
//
//  Created by Murphy on 07/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SETabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let main_item = UITabBarItem(title: "主页", image: nil, selectedImage: nil)
        let set_item = UITabBarItem(title: "设置", image: nil, selectedImage: nil)
        let personal_item = UITabBarItem(title: "我的", image: nil, selectedImage: nil)
        let main_vc = SEMainViewController(nibName: "SEMainViewController", bundle: nil);
        let set_vc = SESettingTableViewController(nibName: "SESettingTableViewController", bundle: nil);
        let per_vc = SEPersonalTableViewController(nibName: "SEPersonalTableViewController", bundle: nil);
        main_vc.tabBarItem = main_item;
        set_vc.tabBarItem = set_item;
        per_vc.tabBarItem = personal_item;
        self.viewControllers = [main_vc,set_vc,per_vc];
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
