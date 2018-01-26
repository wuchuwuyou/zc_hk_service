//
//  SERepairViewController.swift
//  Service
//
//  Created by Murphy on 26/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import DKImagePickerController
import SVProgressHUD

class SERepairViewController: UIViewController,UITextFieldDelegate,SelectOrgItemDelegate {
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var uploadImageBtn: UIButton!

    @IBOutlet weak var buildBtn: UIButton!
    @IBOutlet weak var floorBtn: UIButton!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var repairEventBtn: UIButton!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var contactTextField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var repairInfo:RepairInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let item = UIBarButtonItem(title: "我的报修", style: .plain, target: self, action: #selector(showMyRepair))
        self.navigationItem.rightBarButtonItem = item
        self.locationTextField.delegate = self;
        self.initView()
        self.requestRepairInfo()
    }
    func requestRepairInfo() {
        SENetworkAPI.sharedInstance.repairInfo { (response) in
            if response.error != nil {
                
                SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
                return;
            }
            let decoder = JSONDecoder()
            self.repairInfo = try! decoder.decode(RepairInfo.self, from: response.response!)
        }
    }

    
    func initView() {
        self.contentTextView.layer.cornerRadius = 2
        self.contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentTextView.layer.borderWidth = 1
        
        self.locationTextField.layer.cornerRadius = 2
        self.locationTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.locationTextField.layer.borderWidth = 1
        
        self.contactTextField.layer.cornerRadius = 2
        self.contactTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.contactTextField.layer.borderWidth = 1
        
        self.submitBtn.layer.cornerRadius = 2
        self.submitBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.submitBtn.layer.borderWidth = 1
        
        collectionViewHeight.constant = 0
    }
    
    @objc func showMyRepair() {
        let imagePicker = DKImagePickerController()
        imagePicker.maxSelectableCount = 9
        imagePicker.assetType = .allPhotos
        imagePicker.didSelectAssets = { (assets:[DKAsset]) in
            
        }
        self.present(imagePicker, animated: true) {
        
        }
    }
    @IBAction func buildingAction(_ sender: Any) {
    }
    @IBAction func floorAction(_ sender: Any) {
    }
    @IBAction func areaAction(_ sender: Any) {
    }
    
    
    
    @IBAction func uploadImageAction(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitAction(_ sender: Any) {
    }
    

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.locationTextField) {
            let org = SESelectOrgTableViewController(nibName: "SESelectOrgTableViewController", bundle: nil)
            org.delegate = self
            self.navigationController?.pushViewController(org, animated: true)
            return false
        }
//        let settingHost = SESettingTableViewController(nibName: "SESettingTableViewController", bundle: nil)
//        settingHost.delegate = self
//        self.navigationController?.pushViewController(settingHost, animated: true)
        return true
    }

    /// select org item
    func selectOrigItem(orgItem: RepairOrgItem) {
        
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
