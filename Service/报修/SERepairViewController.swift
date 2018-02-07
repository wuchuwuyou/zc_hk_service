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


let cellSpace:CGFloat = 5

class SERepairViewController: UIViewController,UITextFieldDelegate,SelectOrgItemDelegate,RepairEventDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
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
    
    
    
    var orgItem:RepairOrgItem?
    
    var repairInfo:RepairInfo?
    
    var repairAreaInfo:RepairAreaInfo?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var areaPickerView: UIView!
    
    var cell_width:CGFloat = 0
    
    var selectBuilding:RepairOrgItem?
    var selectFloor:RepairOrgItem?
    var selectRange:RepairOrgItem?
    // 0 区域  1 范围
    var pickViewType = 0
    
    var imageDataArray:[DKAsset]?  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "临时报修"
        let item = UIBarButtonItem(title: "我的报修", style: .plain, target: self, action: #selector(showMyRepair))
        self.titleLabel.text = SEModel.shared.loginModel?.userName
        self.navigationItem.rightBarButtonItem = item
        self.locationTextField.delegate = self;
        let screen_width = UIScreen.main.bounds.width
        self.cell_width = (screen_width - (4 * cellSpace)) / 3
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "SEImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SEImageCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.cell_width, height: self.cell_width)
        layout.minimumLineSpacing = cellSpace
        layout.minimumInteritemSpacing = cellSpace
        layout.sectionInset = UIEdgeInsets(top: cellSpace, left: cellSpace, bottom: cellSpace, right: cellSpace)
        self.collectionView.collectionViewLayout = layout
        
        self.initView()
        self.requestRepairInfo()
        self.requestRepairArea()
    }
    
    func requestRepairInfo() {
        SENetworkAPI.sharedInstance.repairInfo { (response) in
            if response.error != nil {
                
                SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
                return;
            }
            let decoder = JSONDecoder()
            self.repairInfo = try! decoder.decode(RepairInfo.self, from: response.response!)
            let building = self.repairInfo?.infos?.buildingNumber
            let floor = self.repairInfo?.infos?.floor
            let org = self.repairInfo?.infos?.orgName
            let phone = self.repairInfo?.infos?.phoneNumber
            if (building?.isEmpty != true) {
                self.buildBtn.setTitle(building, for: .normal)
                self.selectBuilding = RepairOrgItem(objId: -1, objName: building!)
            }
            if (floor?.isEmpty != true) {
                self.floorBtn.setTitle(floor, for: .normal)
                self.selectFloor = RepairOrgItem(objId: -1, objName: floor!)
            }
            if (org?.isEmpty != true) {
//                self.areaBtn.setTitle(org, for: .normal)
                self.locationTextField.text = org
                self.orgItem = RepairOrgItem(objId: (self.repairInfo?.infos?.orgId)!, objName: org!)
            }
            self.contactTextField.text = phone
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

        self.buildBtn.setTitle("区域", for: .normal)
        self.floorBtn.setTitle("层数", for: .normal)
        self.areaBtn.setTitle("范围", for: .normal)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.uploadImageBtn.setTitle("上传相册", for: .normal)
        
        self.submitBtn.setTitleColor(UIColor.white, for: .normal)
        self.submitBtn.backgroundColor = UIColor.AppColor()
        self.submitBtn.setTitle("提交", for: .normal)
        self.submitBtn.layer.cornerRadius = 3

    }
    
    
    
    @objc func showMyRepair() {
        let list = SERepairListViewController(nibName: "SERepairListViewController", bundle: nil)
        self.navigationController?.pushViewController(list, animated: true)
    }
    
    func requestRepairArea() {
        
        SENetworkAPI.sharedInstance.repairRegionInfo { (response) in
            if response.error != nil {
                SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
                return;
            }
            let decoder = JSONDecoder()
            self.repairAreaInfo = try! decoder.decode(RepairAreaInfo.self, from: response.response!)
        }
    }
    
    func selectRepairEvent(events: [RepairOrgItem]) {
        let content = self.contentTextView.text
        var str:String = ""
        for item in events {
            str = str + item.objName! + "\n"
        }
        self.contentTextView.text = content! + str
    }
    
    @IBAction func buildingAction(_ sender: Any) {
        self.pickViewType = 0
        self.areaPickerView.isHidden = false
        self.pickerView.reloadAllComponents()
    }
    @IBAction func floorAction(_ sender: Any) {
        self.pickViewType = 0
        self.areaPickerView.isHidden = false
        self.pickerView.reloadAllComponents()
    }
    @IBAction func areaAction(_ sender: Any) {
        self.pickViewType = 1
        self.areaPickerView.isHidden = false
        self.pickerView.reloadAllComponents()
    }
    
    @IBAction func eventAction(_ sender: Any) {
        let event = SERepairEventViewController(nibName: "SERepairEventViewController", bundle: nil)
        event.delegate = self
        self.navigationController?.pushViewController(event, animated: true)
    }
    
    
    @IBAction func uploadImageAction(_ sender: Any) {
        self.collectionViewHeight.constant = cell_width * 1
        self.collectionView.reloadData()
        self.uploadImageBtn.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitAction(_ sender: Any) {
        
        
        if (self.selectBuilding == nil || self.selectBuilding?.objName?.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "请选择报修区域")
            return
        }
        if (self.selectFloor == nil || self.selectFloor?.objName?.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "请选择报修层数")
            return
        }
        if (self.selectRange == nil || self.selectRange?.objName?.isEmpty == true) {
            SVProgressHUD.showInfo(withStatus: "请选择报修范围")
            return
        }
        if self.contentTextView.text.isEmpty {
            SVProgressHUD.showInfo(withStatus: "请输入报修内容")
            return
        }
        
        if (self.orgItem?.objName?.isEmpty)! {
            SVProgressHUD.showInfo(withStatus: "请选择报修科室")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let time = formatter.string(from: Date())

        self.addRepair(time: time)
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
    func selectOrgItem(orgItem: RepairOrgItem) {
        self.orgItem = orgItem
        self.locationTextField.text = self.orgItem?.objName
    }
    
    // MARK: - picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if (self.pickViewType == 0) {
            return 2
        }else if(self.pickViewType == 1) {
            return 1
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(self.pickViewType == 0) {
            let areaItems = self.repairAreaInfo?.infos?.areaItems
            if areaItems == nil {
                return 0
            }
            if(component == 0) {
                return (areaItems?.count)!
            }else if(component == 1) {
                let index = pickerView.selectedRow(inComponent: 0)
                return areaItems![index].items!.count
            }
            return 0
        }else if (self.pickViewType == 1) {
            
            let areaItems = self.repairAreaInfo?.infos?.areaTypeItems
            if areaItems == nil {
                return 0
            }
            return (areaItems?.count)!
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (self.pickViewType == 0) {
            let areaItems = self.repairAreaInfo?.infos?.areaItems
            if (areaItems == nil) {
                return ""
            }
            if(component == 0){
                return areaItems![row].objName
            }else if(component == 1) {
                let index = pickerView.selectedRow(inComponent: 0)
                return areaItems![index].items![row].objName
            }
            return ""
        }else if(self.pickViewType == 1) {
            let areaItems = self.repairAreaInfo?.infos?.areaTypeItems
            if areaItems == nil {
                return ""
            }
            return areaItems![row].objName
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let areaItems = self.repairAreaInfo?.infos?.areaItems
        if (self.pickViewType == 0) {
            if component == 0 {
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            }
        }
    }
    
    @IBAction func pickerViewCancel(_ sender: Any) {
        self.areaPickerView.isHidden = true
    }
    
    @IBAction func pickerViewDone(_ sender: Any) {
        if (self.pickViewType == 0) {
            self.areaPickerView.isHidden = true
            let areaItems = self.repairAreaInfo?.infos?.areaItems
            
            let buliding_index = self.pickerView.selectedRow(inComponent: 0)
            let floor_index = self.pickerView.selectedRow(inComponent: 1)
            
            let buliding = areaItems![buliding_index]
            let floor = buliding.items![floor_index]
            self.selectBuilding = RepairOrgItem(objId: buliding.objId!, objName: buliding.objName!)
            self.selectFloor = floor
            self.buildBtn.setTitle(self.selectBuilding?.objName, for: .normal)
            self.floorBtn.setTitle(self.selectFloor?.objName, for: .normal)
        }else if (self.pickViewType == 1) {
            self.areaPickerView.isHidden = true
            let areaItems = self.repairAreaInfo?.infos?.areaTypeItems
            let area_index = self.pickerView.selectedRow(inComponent: 0)
            let area = areaItems![area_index]
            self.selectRange = area
            self.areaBtn.setTitle(self.selectRange?.objName, for: .normal)
        }
    }
    // MARK: - collection view
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageDataArray?.count == 9 {
            return 9
        }else {
            return (self.imageDataArray?.count)! + 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SEImageCollectionViewCell", for: indexPath) as! SEImageCollectionViewCell
        if indexPath.row < (self.imageDataArray?.count)! {
            let asset:DKAsset = (self.imageDataArray?[indexPath.row])!
            asset.fetchOriginalImageWithCompleteBlock({ (image, dict) in
                cell.imageView.image = image
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = self.imageDataArray?.count
        if count == 9 {
            return
        }
        // index = 8 count= 8
        if (indexPath.row == count) {
            let num = 9 - count!
            self.showImagePicker(maxCount: num)
        }
    }
    // MARK: - show image
    func showImagePicker(maxCount:Int) {
        let imagePicker = DKImagePickerController()
        imagePicker.maxSelectableCount = maxCount
        imagePicker.assetType = .allPhotos
        imagePicker.showsCancelButton = true
        imagePicker.didSelectAssets = { (assets:[DKAsset]) in
            self.imageDataArray?.append(contentsOf: assets)
            var count = self.imageDataArray?.count
            if count != 9 {
                count = count! + 1
            }
            let line = (count! % 3) > 0 ?((count! / 3)+1):(count! / 3)
            self.collectionViewHeight.constant = (self.cell_width * CGFloat(line)) + cellSpace * 4
            self.collectionView.reloadData()
        }
        self.present(imagePicker, animated: true) {
            
        }

    }
    
    /// add repair report
    
    func addRepair(time:String) {
      
        let content = ((self.selectBuilding?.objName)! + (self.selectFloor?.objName)! + (self.selectRange?.objName)!) + self.contentTextView.text
        
        SVProgressHUD.show()
        SENetworkAPI.sharedInstance.addRepairReport(content: content, number: time, orgId: (self.orgItem?.objId)!, phone: self.contactTextField.text!) { (response) in
            if response.error != nil {
                SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
                return;
            }
            let image_count = self.imageDataArray?.count
            if(image_count! > 0) {
                self.uploadImage(time: time)
            }else {
                SVProgressHUD.showSuccess(withStatus: "上传成功")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func uploadImage(time:String) {
        var imageArray:[UIImage] = []
        for asset in self.imageDataArray! {
            asset.fetchOriginalImage(true, completeBlock: { (image, dict) in
                imageArray.append(image!)
            })
        }
        
        SENetworkAPI.sharedInstance.uploadImages(number: time, images: imageArray, closure: { (progress) in
            SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "上传图片")
        }) { (response) in
            if response.error != nil {
                SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
                return;
            }
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            self.navigationController?.popViewController(animated: true)
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
