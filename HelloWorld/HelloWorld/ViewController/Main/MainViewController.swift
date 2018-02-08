//
//  MainViewController.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 24/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit
import SnapKit
import KRPullLoader

protocol MainView : class{
    func reloadData()
    func showDetail(with Item: NSObject)
    func shouldDismissKeyboards()
}

class MainViewController: UIViewController, MainView ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, KRPullLoadViewDelegate  {
    var isSearching: Bool = false
    var shouldDisableLoadMore: Bool = false
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.decelerationRate = UIScrollViewDecelerationRateFast
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let searchView : UISearchBar = {
        let sv = UISearchBar()
        sv.placeholder = "search"
        return sv
    }()
    
    let loadMoreView = KRPullLoadView()
    
    private(set) lazy var presenter: MainPresenter = MainViewPresenter(view: self)
    private lazy var dataSource: MainViewDataSource = .init(presenter: self.presenter)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "App Store"
        self.view.backgroundColor = UIColor.white
        self.configSearchView()
        self.configCollectionView()
        self.configLoadmoreView()
        self.presenter.fetchAppListingData(limit: 10)
        self.presenter.fetchRecomendListData()
    }
    
    func configCollectionView(){
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        self.dataSource.configure(with: collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    func configLoadmoreView(){
        loadMoreView.delegate = self
        collectionView.addPullLoadableView(loadMoreView, type: .loadMore)
    }
    
    func configSearchView(){
        self.view.addSubview(searchView)
        self.searchView.delegate = self
        searchView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showDetail(with Item: NSObject) {
        
    }
    
    func shouldDismissKeyboards() {
        searchView.resignFirstResponder()
    }
    
    //MARK:- UISearchBarDelegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.shouldDismissKeyboards()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.shouldDismissKeyboards()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.shouldDismissKeyboards()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != ""){
            self.isSearching = true
            self.presenter.fetchAppListingData(limit: self.presenter.shouldPresentItem, terms: searchText)
        }else{
            self.isSearching = false
            self.presenter.fetchAppListingData(limit: (self.presenter.shouldPresentItem))
        }
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                         at: .top,
                                         animated: true)
    }
    
    //MARK:- KRPullLoadViewDelegate
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                if (isSearching){
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
    
    //MARK:- UICollectionViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.shouldDismissKeyboards()
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.section == 0){
            if (self.isSearching || self.presenter.recommendItemList().count == 0) {
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
