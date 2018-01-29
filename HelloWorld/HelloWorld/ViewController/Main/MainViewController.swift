//
//  MainViewController.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 24/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit
import SnapKit


protocol MainView : class{
    func reloadData()
    func showDetail(with Item: NSObject)
}

class MainViewController: UIViewController, MainView {
    var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.decelerationRate = UIScrollViewDecelerationRateFast
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    var searchView : UISearchBar = {
        let sv = UISearchBar()
        sv.placeholder = "search"
        return sv
    }()
    
    private(set) lazy var presenter: MainPresenter = MainViewPresenter(view: self)
    private lazy var dataSource: MainViewDataSource = .init(presenter: self.presenter)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "App Store"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        self.view.addSubview(searchView)
        self.dataSource.configure(with: collectionView, with: searchView)
        self.presenter.fetchAppListingData(limit: 10)
        self.presenter.fetchRecomendListData()
        searchView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
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
}
