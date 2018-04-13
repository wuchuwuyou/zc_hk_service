//
//  SESurveyDetailViewController.swift
//  Service
//
//  Created by Murphy on 11/04/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class SESurveyDetailViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var items:[SurveyCommitModel]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "满意度调查详情"
        self.webView.navigationDelegate = self
        if items != nil {
            var content = "<html><body><p style=\"font-size:50px\">"
            for model in items! {
                var str = ""
                if model.evaluateType == 0 {
                    //单选
                    switch (model.evaluateValue) {
                        case "1":
                            str = "非常满意"
                        case "2":
                            str = "满意"
                        case "3":
                            str = "基本合格"
                        case "4":
                            str = "不满意"
                        default:
                            str = "未知"
                    }
                }else {
                    str = model.evaluateValue!
                }
                content.append("\(model.surveyProject!): \(str)<br/>")
            }
            content.append("</p></body></html>")
            self.webView.loadHTMLString(content, baseURL: URL(string: ""))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
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
