//
//  MainViewDataSource.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 24/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit

final class MainViewDataSource: NSObject {
    fileprivate let presenter : MainPresenter
    let appItemCellID = "appItemCellID"
    let appRecomCellID = "appRecomCellID"
    let textCellID = "cell"
    
    init(presenter : MainPresenter) {
        self.presenter = presenter
    }
    
    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AppItemCell", bundle: nil), forCellWithReuseIdentifier:appItemCellID)
        collectionView.register(AppRecomCell.self, forCellWithReuseIdentifier: appRecomCellID)
    }
}

extension MainViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        }else{
            return presenter.numberOfItem
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell : AppRecomCell = collectionView.dequeueReusableCell(withReuseIdentifier: appRecomCellID, for: indexPath) as! AppRecomCell
            if (self.presenter.recommendItemList().count != 0){
                cell.recommendItems = self.presenter.recommendItemList()
            }
            return cell
        }else{
            let cell : AppItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: appItemCellID, for: indexPath) as! AppItemCell
            let appItem = presenter.appItem(at: indexPath.row)
            cell.AppItem = appItem
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.section == 1){
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}
