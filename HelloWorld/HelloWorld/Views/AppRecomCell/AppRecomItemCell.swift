//
//  AppRecomItemCell.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 29/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit

class AppRecomItemCell: UICollectionViewCell {
    let CellID = "AppRecomItemCellID"
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appCategoryLabel: UILabel!
    @IBOutlet weak var appIconImageView: UIImageView!
    
    var AppItem : RLM_RecomAppItem? {
        didSet{
            if (AppItem != nil) {
                appNameLabel.text = AppItem?.name
                appCategoryLabel.text = AppItem?.category
                let url = URL(string: (AppItem?.icon)!)
                let image = UIImage(named: "Placeholder-Icon")
                appIconImageView.kf.setImage(with: url, placeholder:image)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        appIconImageView.layer.cornerRadius = 8.0
        appIconImageView.clipsToBounds = true
    }
}
