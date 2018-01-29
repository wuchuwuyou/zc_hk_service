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
        let main_item = UITabBarItem(title: "主页", image: UIImage(named:"主页"), selectedImage: nil)
        let set_item = UITabBarItem(title: "设置", image: UIImage(named:"设置"), selectedImage: nil)
        let personal_item = UITabBarItem(title: "我的", image: UIImage(named:"我"), selectedImage: nil)
        let main_vc = SEMainViewController(nibName: "SEMainViewController", bundle: nil);

        let set_vc = SESettingTableViewController(nibName: "SESettingTableViewController", bundle: nil);
        let per_vc = SEPersonalTableViewController(nibName: "SEPersonalTableViewController", bundle: nil);
        
        let nav_main = SENavigationViewController(rootViewController: main_vc)
    
        
        let nav_set = SENavigationViewController(rootViewController: set_vc)
        
        
        let nav_per = SENavigationViewController(rootViewController: per_vc)
        
        
        nav_main.tabBarItem = main_item;
        nav_set.tabBarItem = set_item;
        nav_per.tabBarItem = personal_item;

        self.viewControllers = [nav_main,nav_set,nav_per];
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
