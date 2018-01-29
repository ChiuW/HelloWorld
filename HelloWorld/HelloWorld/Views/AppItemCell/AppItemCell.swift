//
//  AppItemCell.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 28/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit
import Kingfisher

class AppItemCell: UICollectionViewCell {
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appCategoryLabel: UILabel!
    @IBOutlet weak var appIconImageView: UIImageView!
    
    var AppItem : RLM_AppItem? {
        didSet{
            if (AppItem != nil) {
                appNameLabel.text = AppItem?.name
                appCategoryLabel.text = AppItem?.category
                let url = URL(string: (AppItem?.icon)!)
                let image = UIImage(named: "Placeholder-Icon")
                appIconImageView.kf.setImage(with: url, placeholder:image)
                let ranking : Int = (AppItem?.ranking)!
                rankingLabel.text = String(ranking)
                if ((AppItem?.ranking)! % 2 == 0){
                    appIconImageView.layer.cornerRadius = 8.0
                    appIconImageView.clipsToBounds = true
                }else{
                    appIconImageView.layer.cornerRadius = 35.0
                    appIconImageView.clipsToBounds = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
