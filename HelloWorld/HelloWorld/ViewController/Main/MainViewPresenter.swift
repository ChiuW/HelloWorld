//
//  MainViewPresenter.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 24/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit

protocol MainPresenter : class{
    init(view: MainView)
    var numberOfItem: Int { get }
    var shouldPresentItem: Int { get }
    func appItem(at index: Int) -> RLM_AppItem
    func recommendItemList() -> [RLM_RecomAppItem]
    func viewWillAppear()
    func viewWillDisappear()
    func fetchAppListingData(limit: Int)
    func fetchAppListingData(limit: Int, terms: String)
    func fetchRecomendListData()
}

final class MainViewPresenter: MainPresenter {
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        
    }
    
    private weak var view: MainView?
    
    private var listItem: [RLM_AppItem] = [] {
        willSet{
        }
        didSet {
            view?.reloadData()
        }
    }
    
    private var recommendItem : [RLM_RecomAppItem] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    init(view: MainView) {
        self.view = view;
    }
    
    var numberOfItem: Int{
        print("numberOfItem", listItem.count)
        return listItem.count
    }
    
    var shouldPresentItem: Int{
        if (listItem.count > 10){
            return (listItem.count % 10) * 10
        }else{
            return 10
        }
    }
    
    func appItem(at index: Int) -> RLM_AppItem {
        return self.listItem[index]
    }
    
    func recommendItemList() -> [RLM_RecomAppItem] {
        return self.recommendItem
    }
    
    func fetchAppListingData(limit: Int) {
        print("fetchAppListingData : ",limit)
        dataService.sharedInstance.getAppListing(searchTerms: "", limit: limit, page: 0) { (data) in
            self.listItem = data
        }
    }
    func fetchAppListingData(limit: Int, terms: String) {
        print("fetchAppListingData : ",limit, " terms :", terms)
        dataService.sharedInstance.getAppListing(searchTerms: terms, limit: limit, page: 0) { (data) in
            self.listItem = data
        }
    }
    func fetchRecomendListData(){
        print("fetchRecomendListData")
        dataService.sharedInstance.getGrossingAppListing { (data) in
            print("fetchRecomendListData success", data.count)
            self.recommendItem = data
        }
    }
}
