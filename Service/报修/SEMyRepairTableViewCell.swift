//
//  SEMyRepairTableViewCell.swift
//  Service
//
//  Created by Murphy on 30/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEMyRepairTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var indexView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var areaView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.indexView.backgroundColor = UIColor.AppColor()
        self.areaView.layer.cornerRadius = 5
        self.areaView.layer.masksToBounds = true
        
        self.areaView.layer.borderColor = UIColor.black.cgColor
        self.areaView.layer.borderWidth = 0.5

        
    }
    public func configRepairCell(model:RepairListItem,index:String) {
        self.indexLabel.text = index
        self.label1.text = "报修科室:" + model.repairOrgName!
        
        self.label2.text = "报修人电话:" + model.repairUserPhone!
        self.label3.text =  "报修内容:" + model.repairContent!
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
