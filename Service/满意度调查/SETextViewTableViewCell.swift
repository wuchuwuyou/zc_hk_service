//
//  SETextViewTableViewCell.swift
//  Service
//
//  Created by Murphy on 10/04/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SETextViewTableViewCell: UITableViewCell,UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var imgView:UIImageView!
    
    var typeModel:[SurveyTypeModel]?
    var itemModel:SurveyProModel?
    var callBack:((SurveyProModel?)->(Void))?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
    }
    public func configCell(type:[SurveyTypeModel],item:SurveyProModel) {
        self.typeModel = type
        self.itemModel = item
        self.titleLbl.text = item.sProName;
        if item.complainContent == nil {
            self.textView.text = ""
        }else {
            self.textView.text = item.complainContent
        }
        var imageName = ""
        switch item.sProId {
            case 17:
                //节水
                imageName = "water"
            case 18:
                //节电
                imageName = "electricity"
            case 19:
                //不满意的具体内容
                imageName = "yawp"
            default:
                imageName = ""
        }
        self.imgView.image = UIImage(named: imageName)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.itemModel?.complainContent = textView.text
        callBack!(self.itemModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
