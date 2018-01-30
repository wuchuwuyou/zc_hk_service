//
//  SESettingHostViewController.swift
//  Service
//
//  Created by Murphy on 02/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SESettingHostViewController: UIViewController,UITextFieldDelegate,SelectHostDelegate {

    
    @IBOutlet weak var hostTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "设置"
        self.hostTextField.delegate = self
        let host = HostUserDefaults.currentHost()
        if (host.host.isEmpty != true && host.port.isEmpty != true){
            self.hostTextField.text = host.stringText()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let settingHost = SESettingTableViewController(nibName: "SESettingTableViewController", bundle: nil)
        settingHost.delegate = self
        self.navigationController?.pushViewController(settingHost, animated: true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectHost(host: HostModel) {
        HostUserDefaults.setCurrentHost(host: host)
        self.hostTextField.text = host.stringText()
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
