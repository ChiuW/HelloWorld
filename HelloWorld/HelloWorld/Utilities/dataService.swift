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
    static var sharedInstance : dataService = dataService()
    
    let realm = try! Realm()
    override init() {
        
    }
    
   
    
    public func getAppListing(searchTerms:String, limit:Int, page:Int, completed: @escaping (([RLM_AppItem])->Void) ){
        let isNeedToUpdated = realm.objects(RLM_DbStatus.self)
        if (isNeedToUpdated.count == 0 || !isNeedToUpdated[0].isListingFetchSuccess) {
            fetchListingData(completed: { (isSuccess) in
                let appList = self.realm.objects(RLM_AppItem.self).sorted(byKeyPath: "ranking")
                let result : [RLM_AppItem]
                result = Array(appList)
                completed(result.takeElements(elementCount: limit))
            })
        }else{
            var searchStr : String
            if (!searchTerms.isEmpty){
                print("search : ",searchTerms)
                searchStr = String(format: "name CONTAINS '%@'",searchTerms)
                let appList = self.realm.objects(RLM_AppItem.self).sorted(byKeyPath: "ranking").filter(searchStr)
                print("search result : ",appList.count)
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
        networkService.sharedInstance.getAppList { (data) in
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
                let dbStatus = self.realm.objects(RLM_DbStatus.self).last
                var isRecommendFetchSuccess : Bool = false
                if ((dbStatus) != nil){
                     isRecommendFetchSuccess = (dbStatus?.isRecommendFetchSuccess)!
                }
                
                let oldDbStatus = self.realm.objects(RLM_DbStatus.self)
                try! self.realm.write {
                    self.realm.delete(oldDbStatus)
                }
                
                let newDbStatus = RLM_DbStatus()
                newDbStatus.isRecommendFetchSuccess = isRecommendFetchSuccess
                newDbStatus.isListingFetchSuccess = true
                try! self.realm.write {
                    self.realm.add(newDbStatus)
                }
                completed(true)
            }
        }
    }
    
    public func getGrossingAppListing(completed: @escaping (([RLM_RecomAppItem])->Void) ){
        let isNeedToUpdated = realm.objects(RLM_DbStatus.self)
        if (isNeedToUpdated.count == 0 || !isNeedToUpdated[0].isRecommendFetchSuccess) {
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
        networkService.sharedInstance.getGrossingAppList { (data) in
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
                let dbStatus = self.realm.objects(RLM_DbStatus.self).last
                var isListingFetchSuccess : Bool = false
                if ((dbStatus) != nil){
                    isListingFetchSuccess = (dbStatus?.isListingFetchSuccess)!
                }
                
                let oldDbStatus = self.realm.objects(RLM_DbStatus.self)
                try! self.realm.write {
                    self.realm.delete(oldDbStatus)
                }
                
                let newDbStatus = RLM_DbStatus()
                newDbStatus.isRecommendFetchSuccess = true
                newDbStatus.isListingFetchSuccess = isListingFetchSuccess
                try! self.realm.write {
                    self.realm.add(newDbStatus)
                }
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
