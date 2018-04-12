//
//  SERadioTableViewCell.swift
//  Service
//
//  Created by Murphy on 10/04/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SERadioTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var btn1: SERadioBtn!
    @IBOutlet weak var btn2: SERadioBtn!
    @IBOutlet weak var btn3: SERadioBtn!
    @IBOutlet weak var btn4: SERadioBtn!
    var typeModel:[SurveyTypeModel]?
    var itemModel:SurveyProModel?
    var callBack:((SurveyProModel?)->(Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btn1.setImage(UIImage(named: "Happy"), for: .normal);
        self.btn1.setImage(UIImage(named: "Happyw"), for: .selected);
        self.btn1.setTitleColor(UIColor.white, for: .selected)
        self.btn1.setTitleColor(UIColor.black, for: .normal)
        self.btn1.layer.cornerRadius = 15.0
        self.btn1.layer.masksToBounds = true
        
        self.btn2.setImage(UIImage(named: "Smiley"), for: .normal);
        self.btn2.setImage(UIImage(named: "Smileyw"), for: .selected);
        self.btn2.setTitleColor(UIColor.white, for: .selected)
        self.btn2.setTitleColor(UIColor.black, for: .normal)
        self.btn2.layer.cornerRadius = 15.0
        self.btn2.layer.masksToBounds = true

        
        self.btn3.setImage(UIImage(named: "Neutral"), for: .normal);
        self.btn3.setImage(UIImage(named: "Neutralw"), for: .selected);
        self.btn3.setTitleColor(UIColor.white, for: .selected)
        self.btn3.setTitleColor(UIColor.black, for: .normal)
        self.btn3.layer.cornerRadius = 15.0
        self.btn3.layer.masksToBounds = true

        
        self.btn4.setImage(UIImage(named: "Sad"), for: .normal);
        self.btn4.setImage(UIImage(named: "Sadw"), for: .selected);
        self.btn4.setTitleColor(UIColor.white, for: .selected)
        self.btn4.setTitleColor(UIColor.black, for: .normal)
        self.btn4.layer.cornerRadius = 15.0
        self.btn4.layer.masksToBounds = true
    }
    public func configCell(type:[SurveyTypeModel],item:SurveyProModel) {
        self.typeModel = type;
        self.itemModel = item
        self.titleLbl.text = item.sProName;
        self.btn1.setTitle(type[0].typeName, for: .normal)
        self.btn2.setTitle(type[1].typeName, for: .normal)
        self.btn3.setTitle(type[2].typeName, for: .normal)
        self.btn4.setTitle(type[3].typeName, for: .normal)

        if item.type == nil {
            self.btn1.deselectAllButtons()
            self.selectBackgroundColor()
            return
        }
        switch item.type?.typeId {
            case 1:
                self.btn1.setSelected(true)
            case 2:
                self.btn2.setSelected(true)
            case 3:
                self.btn3.setSelected(true)
            case 4:
                self.btn4.setSelected(true)
            default:
                self.btn1.deselectAllButtons()
        }
        self.selectBackgroundColor()
    }
    
    @IBAction func clickBtnAction(_ sender: SERadioBtn) {
        switch sender {
        case self.btn1:
            self.btn1.setSelected(true)
            self.itemModel?.type = self.typeModel?[0]
        case self.btn2:
            self.btn2.setSelected(true)
            self.itemModel?.type = self.typeModel?[1]
        case self.btn3:
            self.btn3.setSelected(true)
            self.itemModel?.type = self.typeModel?[2]
        case self.btn4:
            self.btn4.setSelected(true)
            self.itemModel?.type = self.typeModel?[3]
        default:
            self.btn1.deselectAllButtons()
            self.itemModel?.type = nil
        }
        self.selectBackgroundColor()
        callBack!(self.itemModel)
    }
    func selectBackgroundColor() {
        if(self.btn1.isSelected) {
            self.btn1.backgroundColor = UIColor(red: 0.431, green: 0.827, blue: 0.780, alpha: 1.00)
        }else {
            self.btn1.backgroundColor = UIColor.white
        }
        //[UIColor colorWithRed:0.357 green:0.647 blue:0.933 alpha:1.00]
        if(self.btn2.isSelected) {
            self.btn2.backgroundColor = UIColor(red: 0.357, green: 0.647, blue: 0.933, alpha: 1.00)
        }else {
            self.btn2.backgroundColor = UIColor.white
        }
        //[UIColor colorWithRed:0.996 green:0.761 blue:0.361 alpha:1.00]
        if(self.btn3.isSelected) {
            self.btn3.backgroundColor = UIColor(red: 0.996, green: 0.761, blue: 0.361, alpha: 1.00)
        }else {
            self.btn3.backgroundColor = UIColor.white
        }
        //[UIColor colorWithRed:0.976 green:0.353 blue:0.357 alpha:1.00]
        if(self.btn4.isSelected) {
            self.btn4.backgroundColor = UIColor(red: 0.976, green: 0.353, blue: 0.357, alpha: 1.00)
        }else {
            self.btn4.backgroundColor = UIColor.white
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
