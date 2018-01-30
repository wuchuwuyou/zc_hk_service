//
//  SEMyOpinionTableViewCell.swift
//  Service
//
//  Created by Murphy on 30/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEMyOpinionTableViewCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var indexView: UIView!
    
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
    //// 意见反馈
    public func configOpinionCell(model:ListDataModel,index:String) {
        self.indexLabel.text = index
        self.label1.text = "建议标题:" + model.title!
        self.label2.text = "建议内容:" + model.content!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
