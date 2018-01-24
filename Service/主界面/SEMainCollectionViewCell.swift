//
//  SEMainCollectionViewCell.swift
//  Service
//
//  Created by Murphy on 24/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit

class SEMainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configCell(imageName:String?,title:String?) {
        iconImageView.image = UIImage(named: imageName!)
        titleLabel.text = title
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
