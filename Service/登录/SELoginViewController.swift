//
//  SELoginViewController.swift
//  Service
//
//  Created by Murphy on 02/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import SVProgressHUD

class SELoginViewController: UIViewController,SelectUserDelegate,UITextFieldDelegate {

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
        self.loginBtn.setTitleColor(UIColor.white, for: .normal)
        self.loginBtn.backgroundColor = UIColor.AppColor()
        self.loginBtn.layer.cornerRadius = 3
        self.view.backgroundColor = UIColor.bgColor()
        
        self.accountTextField.layer.borderWidth = 1
        self.accountTextField.layer.borderColor = UIColor.black.cgColor
        self.accountTextField.layer.cornerRadius = 3
        
        self.passwordTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderColor = UIColor.black.cgColor
        self.accountTextField.layer.cornerRadius = 3
        
        let left_view_1 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 44))
        let left_view_2 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 44))
        self.accountTextField.leftView = left_view_1
        self.accountTextField.leftViewMode = .always
//
        self.passwordTextField.leftView = left_view_2
        self.passwordTextField.leftViewMode = .always
//
        self.accountTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.accountTextField.placeholder = "请输入账号"
        self.passwordTextField.placeholder = "请输入密码"
        
        self.passwordTextField.isSecureTextEntry = true
//        #if DEBUG
//            self.accountTextField.text = "pingguozhongxin"
//            self.passwordTextField.text = "123"
//        #endif
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.buttonColor().cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
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
        
        let host = HostUserDefaults.currentHost()
        if (host.host.isEmpty||host.port.isEmpty) {
            SVProgressHUD.showInfo(withStatus: "请设置网络地址")
            return;
        }
        
        let account = self.accountTextField.text;
        let pwd = self.passwordTextField.text;
        self.handleAccountAndPwd(ac: account!, pwd: pwd!)
    }
    
    @IBAction func goLoginUserList(_ sender:Any) {
        let loginUserList = SELoginUserTableViewController()
        loginUserList.delegate = self
        self.navigationController?.pushViewController(loginUserList, animated: true)
    }
    func selectUser(user: LoginUser) {
        self.accountTextField.text = user.username
        self.passwordTextField.text = user.password
    }
    
    func handleAccountAndPwd(ac:String,pwd:String) -> Void {
        if ac.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请输入登录账号")
            return
        }
        if pwd.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请输入登录密码")
            return
        }
        self.login(ac: ac, pwd: pwd)
    }
    
    func login(ac:String!,pwd:String!) {
        SVProgressHUD.show(withStatus: "登录中")
        let ac_base64 = ac.encodeBase64()
        let pwd_base64 = pwd.encodeBase64()

        SENetworkAPI.sharedInstance.login(ac: ac_base64, pwd: pwd_base64) { (response) in
            if response.error != nil {
                
                SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
                return;
            }
            let decoder = JSONDecoder()
            let login_model = try! decoder.decode(LoginModel.self, from: response.response!)
            SEModel.shared.loginModel = login_model
            SEModel.shared.loginUser = LoginUser.initWithInfo(username: ac, password: pwd, name: (SEModel.shared.loginModel?.userName)!)
            LoginUserDefaults.addLoginUser(info: SEModel.shared.loginUser!)
            
            SENetworkAPI.sharedInstance.menuList(ac: ac, complete: { (resp) in
                if resp.error != nil {
                    
                    SVProgressHUD.showError(withStatus: resp.error?.localizedDescription)
                    return;
                }
                let decoder = JSONDecoder()
                let menu = try! decoder.decode(SEMenuResp.self, from: resp.response!)
                SEModel.shared.menu = menu.menus
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let tab = SETabBarViewController()
                appDelegate.window?.rootViewController = tab
                SVProgressHUD.dismiss()

            })
            
        }
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
