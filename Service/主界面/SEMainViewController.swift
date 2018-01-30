//
//  SEMainViewController.swift
//  Service
//
//  Created by Murphy on 07/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEMainViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    let lineSpace = CGFloat(0.5)
    
    var header_imageView:UIImageView?
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArray:[SEMenuItem]? = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "智慧医院后勤管理平台"
        
        self.collectionView.register(UINib(nibName: "SEMainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SEMainCollectionViewCell")
        self.collectionView.register(UINib(nibName: "SEMainCollectionReusableHeaderView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader , withReuseIdentifier: "SEMainCollectionReusableHeaderView")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.calSize(col_num: 3)
        layout.minimumLineSpacing = lineSpace
        layout.minimumInteritemSpacing = lineSpace
        layout.scrollDirection = .vertical
        let screen_width = UIScreen.main.bounds.width
        layout.headerReferenceSize = CGSize(width: screen_width, height: screen_width/(2/1))
        self.collectionView.collectionViewLayout = layout
        
        self.initData()
        self.collectionView.reloadData()
//        self.view.backgroundColor = UIColor.bgColor()
//        self.collectionView.backgroundColor = UIColor.bgColor()
        
    }
    
    func calSize(col_num:Int) -> CGSize {
        let screen_width = UIScreen.main.bounds.width
        let line:Int = col_num - 1
        let line_width = CGFloat(integerLiteral: line) * lineSpace
        let width = (screen_width - line_width) / CGFloat(integerLiteral: col_num)
        let height = width / 1.3
        return CGSize(width: width - 1, height: height - 1)
    }
    func initData() {
//        let data_baoxiu = SEMainListModel.initWithInfo(title: "临时报修", imageName: "登录", type: .baoxiu_service)
//        let data_tousu = SEMainListModel.initWithInfo(title: "投诉建议", imageName: "登录", type: .tousu_service)
        self.dataArray = SEModel.shared.menu
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model:SEMenuItem? = self.dataArray?[indexPath.row]
        self.showServiceController(model: model)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SEMainCollectionViewCell", for: indexPath) as! SEMainCollectionViewCell
        let model:SEMenuItem? = self.dataArray?[indexPath.row]
        let imageURL:String? = SENetworkAPI.sharedInstance.imageURL(name: (model?.icon)!)
        cell.configCell(imageName: imageURL, title: model?.menuName)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SEMainCollectionReusableHeaderView", for: indexPath) as! SEMainCollectionReusableHeaderView
            let image = UIImage(named: "banner1")
            header.imageView.image = image
            return header
        }else {
            return UICollectionReusableView();
        }
    }
    
    func showServiceController(model:SEMenuItem?) {
        if model == nil {
            return
        }
        let type = model?.menuId
        switch type {
            case Service_type.baoxiu_service.rawValue?:
                let repair = SERepairViewController(nibName: "SERepairViewController", bundle: nil)
                repair.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(repair, animated: true)
                break
            case Service_type.tousu_service.rawValue?:
                let opinion = SEOpinionViewController(nibName: "SEOpinionViewController", bundle: nil)
                opinion.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(opinion, animated: true)
                break
            case Service_type.default_service.rawValue?:
                print("can't show service controller")
                break
            default:
                print("can't show service controller")
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
