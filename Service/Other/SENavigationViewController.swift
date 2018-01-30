//
//  SENavigationViewController.swift
//  Service
//
//  Created by Murphy on 29/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SENavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationBar.barTintColor = UIColor.AppColor()
        self.navigationItem.title = "我的建议"
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationBar.setBackgroundImage(UIImage(color: UIColor.AppColor(), size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
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
