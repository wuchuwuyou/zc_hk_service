//
//  SEMainCollectionViewCell.swift
//  Service
//
//  Created by Murphy on 24/01/2018.
//  Copyright © 2018 Murphy. All rights reserved.
//

import UIKit
import Kingfisher
class SEMainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configCell(imageName:String?,title:String?) {
        let url:URL? = URL(string: imageName!)
        iconImageView.kf.setImage(with: url)
        titleLabel.text = title
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
