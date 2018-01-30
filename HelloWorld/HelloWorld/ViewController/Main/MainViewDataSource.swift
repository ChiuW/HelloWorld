//
//  MainViewDataSource.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 24/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit
import KRPullLoader

final class MainViewDataSource: NSObject {
    fileprivate let presenter : MainPresenter
    let appItemCellID = "appItemCellID"
    let appRecomCellID = "appRecomCellID"
    let textCellID = "cell"
    let loadMoreView = KRPullLoadView()
    var shouldDisableLoadMore : Bool = false
    var searchText : String = ""
    
    init(presenter : MainPresenter) {
        self.presenter = presenter
    }
    
    func configure(with collectionView: UICollectionView, with searchBar: UISearchBar) {
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "AppItemCell", bundle: nil), forCellWithReuseIdentifier:appItemCellID)
        collectionView.register(AppRecomCell.self, forCellWithReuseIdentifier: appRecomCellID)
        
        loadMoreView.delegate = self
        collectionView.addPullLoadableView(loadMoreView, type: .loadMore)
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

extension MainViewDataSource: UICollectionViewDelegate {
    
}

extension MainViewDataSource: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.section == 0){
            if (self.shouldDisableLoadMore || self.presenter.recommendItemList().count == 0) {
                return CGSize(width: collectionView.frame.width, height: 1.0)
            }else{
                return CGSize(width: collectionView.frame.width, height: 210.0)
            }
        }else{
            return CGSize(width: collectionView.frame.width, height: 90.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension MainViewDataSource: KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                if (shouldDisableLoadMore){
                    completionHandler()
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    self.presenter.fetchAppListingData(limit: (self.presenter.shouldPresentItem + 10))
                }
            default: break
            }
            return
        }
    }
}

extension MainViewDataSource: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != ""){
            self.presenter.fetchAppListingData(limit: self.presenter.shouldPresentItem, terms: searchText)
            self.shouldDisableLoadMore = true
        }else{
            self.presenter.fetchAppListingData(limit: (self.presenter.shouldPresentItem))
            self.shouldDisableLoadMore = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
