//
//  AppRecomCell.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 29/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit

class AppRecomCell: UICollectionViewCell{
    let appRecomItemCellID = "AppRecomItemCellID";
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false;
        cv.showsHorizontalScrollIndicator = false
        return cv;
    }();
    
    let recomLabel : UILabel = {
        let label = UILabel()
        label.text = "Recommendation"
        label.font = label.font.withSize(16)
        return label
    }()

    var recommendItems : [RLM_RecomAppItem] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    
    func appItem(at index: Int) -> RLM_RecomAppItem {
        return self.recommendItems[index]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        self.addSubview(recomLabel)
        recomLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
        }
        collectionView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(recomLabel.snp.bottom)
        }
        collectionView.register(UINib(nibName: "AppRecomItemCell", bundle: nil), forCellWithReuseIdentifier:appRecomItemCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppRecomCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AppRecomItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: appRecomItemCellID, for: indexPath) as! AppRecomItemCell
        let appItem = self.appItem(at: indexPath.row)
        cell.AppItem = appItem
        return cell
    }
}

extension AppRecomCell: UICollectionViewDelegate {
    
}

extension AppRecomCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110.0, height: 153.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
