//
//  SELoginViewController.swift
//  Service
//
//  Created by Murphy on 02/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SELoginViewController: UIViewController {

    @IBOutlet weak var logTitleLabel: UILabel!
    @IBOutlet weak var logImageView: UIImageView!
    @IBOutlet weak var ipSettingBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var severIPLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginUserBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.severIPLabel.text = "重新设置IP及端口号"
        self.ipSettingBtn.setTitle("去设置", for: .normal)
        self.loginBtn.setTitle("登录", for: .normal)
        self.accountTextField.placeholder = "请输入账号"
        self.passwordTextField.placeholder = "请输入密码"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goSettingSeverIP(_ sender: Any) {
        let hostSetting = SESettingHostViewController(nibName: "SESettingHostViewController", bundle: nil)
        self.navigationController?.pushViewController(hostSetting, animated: true)
    }
    
    @IBAction func goLoginAction(_ sender: Any) {
        self.accountTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        let account = self.accountTextField.text;
        let pwd = self.passwordTextField.text;
        self.handleAccountAndPwd(ac: account!, pwd: pwd!)
    }
    
    @IBAction func goLoginUserList(_ sender:Any) {
        let loginUserList = SELoginUserTableViewController()
        self.navigationController?.pushViewController(loginUserList, animated: true)
    }
    
    func handleAccountAndPwd(ac:String,pwd:String) -> Void {
        if ac.isEmpty {
            
        }
        if pwd.isEmpty {
            
        }
        let ac_base64 = ac.encodeBase64()
        let pwd_base64 = pwd.encodeBase64()
        
        self.login(ac: ac_base64, pwd: pwd_base64)
    }
    
    func login(ac:String!,pwd:String!) {
        SENetworkAPI.sharedInstance.login(ac: ac, pwd: pwd)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let tab = SETabBarViewController()
//        appDelegate.window?.rootViewController = tab
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
