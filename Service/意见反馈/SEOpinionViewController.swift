//
//  SEOpinionViewController.swift
//  Service
//
//  Created by Murphy on 25/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import SVProgressHUD

class SEOpinionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = SEModel.shared.loginModel?.userName

        self.navigationItem.title = "意见建议"
        let item = UIBarButtonItem(title: "我的建议", style: .plain, target: self, action: #selector(showMyOpinion))
        self.navigationItem.rightBarButtonItem = item
        self.contentTextView.layer.cornerRadius = 2
        self.contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentTextView.layer.borderWidth = 1
        self.titleTextField.layer.cornerRadius = 2
        self.titleTextField.layer.borderWidth = 1
        self.titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        self.submitBtn.setTitle("匿名提交", for: .normal)
        self.submitBtn.setTitleColor(UIColor.white, for: .normal)
        self.submitBtn.backgroundColor = UIColor.AppColor()
        self.submitBtn.layer.cornerRadius = 2
         
    }

    @objc func showMyOpinion() {
        let my = SEMyOpinionViewController(nibName: "SEMyOpinionViewController", bundle: nil)
        self.navigationController?.pushViewController(my, animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if (self.titleTextField.text?.isEmpty)! {
            SVProgressHUD.showInfo(withStatus: "请输入标题")
            return
        }
        if self.contentTextView.text.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请输入详细内容")
            return
        }
        
        SENetworkAPI.sharedInstance.addOpinion(title: self.titleTextField.text, content: self.contentTextView.text) { (response) in
            if response.error != nil {
                
                SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
                return;
            }
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            self.navigationController?.popViewController(animated: true)
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
