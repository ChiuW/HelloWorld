//
//  dataService.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 28/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit
import RealmSwift

class dataService: NSObject {
    static var mInstance : dataService?
    
    let realm = try! Realm()
    
    var isListingFetchSuccess: Bool = false
    var isRecommendFetchSuccess: Bool = false
    
    static func sharedInstance() -> dataService {
        if mInstance == nil {
            mInstance = dataService()
        }
        return mInstance!
    }
    
    override init() {
        super.init()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    public func getAppListing(searchTerms:String, limit:Int, page:Int, completed: @escaping (([RLM_AppItem])->Void) ){
        print("numberOfItem '%@'", searchTerms)
        if (!isListingFetchSuccess) {
            fetchListingData(completed: { (isSuccess) in
                let appList = self.realm.objects(RLM_AppItem.self).sorted(byKeyPath: "ranking")
                let result : [RLM_AppItem]
                result = Array(appList)
                completed(result.takeElements(elementCount: limit))
            })
        }else{
            var searchStr : String
            if (!searchTerms.isEmpty){
                searchStr = String(format: "name BEGINSWITH '%@'",searchTerms)
                let appList = self.realm.objects(RLM_AppItem.self).sorted(byKeyPath: "ranking").filter(searchStr)
                let result : [RLM_AppItem]
                result = Array(appList)
                completed(result)
            }else{
                let appList = self.realm.objects(RLM_AppItem.self).sorted(byKeyPath: "ranking")
                let result : [RLM_AppItem]
                result = Array(appList)
                completed(result.takeElements(elementCount: limit))
            }
        }
    }
    
    func fetchListingData(completed: @escaping ((Bool)->Void)){
        networkService.sharedInstance().getAppList { (data) in
            if (data.entries == nil){
                completed(false)
            }else{
                let listItem: [App] = data.entries!
                for (index, App) in listItem.enumerated() {
                    let AppItem = RLM_AppItem()
                    AppItem.ranking = index + 1
                    AppItem.name = App.name!
                    AppItem.price = "\(String(describing: App.price?.currency))\(String(describing: App.price?.ammount))"
                    AppItem.icon = (App.iconsData?.l_icon?.uri)!
                    AppItem.summary = App.summary!
                    AppItem.rights = App.rights!
                    AppItem.title = App.title!
                    AppItem.category = (App.category?.name)!
                    try! self.realm.write {
                        self.realm.add(AppItem)
                    }
                }
                self.isListingFetchSuccess = true
                completed(true)
            }
        }
    }
    
    public func getGrossingAppListing(completed: @escaping (([RLM_RecomAppItem])->Void) ){
        if (!isRecommendFetchSuccess) {
            fetchRecommendData(completed: { (isSuccess) in
                let appList = self.realm.objects(RLM_RecomAppItem.self).sorted(byKeyPath: "ranking")
                let result : [RLM_RecomAppItem]
                result = Array(appList)
                completed(result)
            })
        }else{
            let appList = self.realm.objects(RLM_RecomAppItem.self).sorted(byKeyPath: "ranking")
            let result : [RLM_RecomAppItem]
            result = Array(appList)
            completed(result)
        }
    }
    
    func fetchRecommendData(completed: @escaping ((Bool)->Void)){
        networkService.sharedInstance().getGrossingAppList { (data) in
            if (data.entries == nil){
                completed(false)
            }else{
                let listItem: [App] = data.entries!
                for (index, App) in listItem.enumerated() {
                    let AppItem = RLM_RecomAppItem()
                    AppItem.ranking = index + 1
                    AppItem.name = App.name!
                    AppItem.price = "\(String(describing: App.price?.currency))\(String(describing: App.price?.ammount))"
                    AppItem.icon = (App.iconsData?.l_icon?.uri)!
                    AppItem.summary = App.summary!
                    AppItem.rights = App.rights!
                    AppItem.title = App.title!
                    AppItem.category = (App.category?.name)!
                    try! self.realm.write {
                        self.realm.add(AppItem)
                    }
                }
                self.isRecommendFetchSuccess = true
                completed(true)
            }
        }
    }
}

extension Array {
    func takeElements( elementCount: Int) -> Array {
        var elementCount = elementCount
        if (elementCount > count) {
            elementCount = count
        }
        return Array(self[0..<elementCount])
    }
}
