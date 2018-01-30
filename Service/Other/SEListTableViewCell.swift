//
//  SEListTableViewCell.swift
//  Service
//
//  Created by Murphy on 25/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEListTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var indexView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.indexView.backgroundColor = UIColor.AppColor()
    }
    
    public func configRepairCell(model:RepairListItem,index:String) {
        self.indexLabel.text = index
        self.label1.text = "报修科室:" + model.repairOrgName! + "\n" + "报修人电话:" + model.repairUserPhone! + "\n" + "报修内容:" + model.repairContent!

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
