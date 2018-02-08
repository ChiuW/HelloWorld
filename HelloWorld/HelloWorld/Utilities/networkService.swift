//
//  networkService.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 27/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import Foundation
import Alamofire
//import AlamofireObjectMapper
//import SwiftyJSON

class networkService: NSObject {
    static var sharedInstance : networkService = networkService()
    
    override init() {
    }
    
    public func getAppList(completed: @escaping ((AppListingResponse)->Void)){
        var appListingResponse: AppListingResponse?
        let requestURL = getApplicationList();
        Alamofire.request(requestURL).validate().responseJSON { (response) in
            switch response.result.isSuccess {
            case true:
                if let result  = response.result.value as? Dictionary<String, Any>{
                    var appResponse = AppListingResponse();
                    if let feed = result["feed"] as? Dictionary<String, Any>{
                        // MARK: Author
                        if let authorData = feed["author"] as? Dictionary<String, Any>{
                            var authorResponse = AuthorResponse()
                            if let name = authorData["name"] as? Dictionary<String, Any>{
                                authorResponse.name = name["label"] as! String!
                            }
                            if let uri = authorData["uri"] as? Dictionary<String, Any>{
                                authorResponse.uri = uri["label"] as! String!
                            }
                            appResponse.author = authorResponse
                        }
                        // MARK: Updated
                        if let updatedData = feed["updated"] as? Dictionary<String, Any>{
                            appResponse.updated = updatedData["label"] as! String!
                        }
                        // MARK: right
                        if let rightsData = feed["rights"] as? Dictionary<String, Any>{
                            appResponse.rights = rightsData["label"] as! String!
                        }
                        // MARK: title
                        if let titleData = feed["title"] as? Dictionary<String, Any>{
                            appResponse.title = titleData["label"] as! String!
                        }
                        // MARK: icon
                        if let iconData = feed["icon"] as? Dictionary<String, Any>{
                            appResponse.icon = iconData["label"] as! String!
                        }
                        // MARK: id
                        if let idData = feed["id"] as? Dictionary<String, Any>{
                            appResponse.id = idData["label"] as! String!
                        }
                        // MARK: entry
                        var entries = [App]()
                        if let entryList = feed["entry"] as? [Dictionary<String, Any>]{
                            for entryItem in entryList{
                                var entry = App()
                                // MARK: app name
                                if let nameData = entryItem["im:name"] as? Dictionary<String, Any>{
                                    entry.name = nameData["label"] as! String!
                                }
                                // MARK: app image
                                if let imageList = entryItem["im:image"] as? [Dictionary<String, Any>]{
                                    var iconsResponse = IconsResponse()
                                    for imageItem in imageList{
                                        var iconItem = icon()
                                        iconItem.uri = imageItem["label"] as! String!
                                        if let sizeData = imageItem["attributes"] as? Dictionary<String, Any>{
                                            iconItem.size = Int(sizeData["height"] as! String!)
                                        }
                                        if(iconItem.size == 53){
                                            iconsResponse.s_icon = iconItem
                                            continue
                                        }else if (iconItem.size == 75){
                                            iconsResponse.m_icon = iconItem
                                            continue
                                        }else{
                                            iconsResponse.l_icon = iconItem
                                        }
                                    }
                                    entry.iconsData = iconsResponse
                                }
                                
                                //MARK: summary
                                if let summaryData = entryItem["summary"] as? Dictionary<String, Any>{
                                    entry.summary = summaryData["label"] as! String!
                                }
                                
                                // MARK: rights
                                if let rightsData = entryItem["rights"] as? Dictionary<String, Any>{
                                    entry.rights = rightsData["label"] as! String!
                                }
                                
                                // MARK: title
                                if let titleData = entryItem["title"] as? Dictionary<String, Any>{
                                    entry.title = titleData["label"] as! String!
                                }
                                
                                // MARK: category
                                if let categoryData = entryItem["category"] as? Dictionary<String, Any>{
                                    var categoryResponse = CategoryResponse()
                                    if let category = categoryData["attributes"] as? Dictionary<String, Any>{
                                        categoryResponse.name = category["label"] as! String!
                                        categoryResponse.id = category["im:id"] as! String!
                                        categoryResponse.terms = category["term"] as! String!
                                        categoryResponse.scheme = category["scheme"] as! String!
                                    }
                                    entry.category = categoryResponse
                                }
                                
                                
                                
                                entries.append(entry)
                            }
                        }
                        appResponse.entries = entries
                    }
                    appListingResponse = appResponse
                    completed(appListingResponse!)
                }
                
                break
            case false:
                appListingResponse = AppListingResponse()
                completed(appListingResponse!)
                break
            }
        }
    }
    
    public func getGrossingAppList(completed: @escaping ((AppListingResponse)->Void)){
        var appListingResponse: AppListingResponse?
        let requestURL = getTopGrossingAppListing();
        Alamofire.request(requestURL).validate().responseJSON { (response) in
            switch response.result.isSuccess {
            case true:
                if let result  = response.result.value as? Dictionary<String, Any>{
                    var appResponse = AppListingResponse();
                    if let feed = result["feed"] as? Dictionary<String, Any>{
                        // MARK: Author
                        if let authorData = feed["author"] as? Dictionary<String, Any>{
                            var authorResponse = AuthorResponse()
                            if let name = authorData["name"] as? Dictionary<String, Any>{
                                authorResponse.name = name["label"] as! String!
                            }
                            if let uri = authorData["uri"] as? Dictionary<String, Any>{
                                authorResponse.uri = uri["label"] as! String!
                            }
                            appResponse.author = authorResponse
                        }
                        // MARK: Updated
                        if let updatedData = feed["updated"] as? Dictionary<String, Any>{
                            appResponse.updated = updatedData["label"] as! String!
                        }
                        // MARK: right
                        if let rightsData = feed["rights"] as? Dictionary<String, Any>{
                            appResponse.rights = rightsData["label"] as! String!
                        }
                        // MARK: title
                        if let titleData = feed["title"] as? Dictionary<String, Any>{
                            appResponse.title = titleData["label"] as! String!
                        }
                        // MARK: icon
                        if let iconData = feed["icon"] as? Dictionary<String, Any>{
                            appResponse.icon = iconData["label"] as! String!
                        }
                        // MARK: id
                        if let idData = feed["id"] as? Dictionary<String, Any>{
                            appResponse.id = idData["label"] as! String!
                        }
                        // MARK: entry
                        var entries = [App]()
                        if let entryList = feed["entry"] as? [Dictionary<String, Any>]{
                            for entryItem in entryList{
                                var entry = App()
                                // MARK: app name
                                if let nameData = entryItem["im:name"] as? Dictionary<String, Any>{
                                    entry.name = nameData["label"] as! String!
                                }
                                // MARK: app image
                                if let imageList = entryItem["im:image"] as? [Dictionary<String, Any>]{
                                    var iconsResponse = IconsResponse()
                                    for imageItem in imageList{
                                        var iconItem = icon()
                                        iconItem.uri = imageItem["label"] as! String!
                                        if let sizeData = imageItem["attributes"] as? Dictionary<String, Any>{
                                            iconItem.size = Int(sizeData["height"] as! String!)
                                        }
                                        if(iconItem.size == 53){
                                            iconsResponse.s_icon = iconItem
                                            continue
                                        }else if (iconItem.size == 75){
                                            iconsResponse.m_icon = iconItem
                                            continue
                                        }else{
                                            iconsResponse.l_icon = iconItem
                                        }
                                    }
                                    entry.iconsData = iconsResponse
                                }
                                
                                //MARK: summary
                                if let summaryData = entryItem["summary"] as? Dictionary<String, Any>{
                                    entry.summary = summaryData["label"] as! String!
                                }
                                
                                // MARK: rights
                                if let rightsData = entryItem["rights"] as? Dictionary<String, Any>{
                                    entry.rights = rightsData["label"] as! String!
                                }
                                
                                // MARK: title
                                if let titleData = entryItem["title"] as? Dictionary<String, Any>{
                                    entry.title = titleData["label"] as! String!
                                }
                                
                                // MARK: category
                                if let categoryData = entryItem["category"] as? Dictionary<String, Any>{
                                    var categoryResponse = CategoryResponse()
                                    if let category = categoryData["attributes"] as? Dictionary<String, Any>{
                                        categoryResponse.name = category["label"] as! String!
                                        categoryResponse.id = category["im:id"] as! String!
                                        categoryResponse.terms = category["term"] as! String!
                                        categoryResponse.scheme = category["scheme"] as! String!
                                    }
                                    entry.category = categoryResponse
                                }
                                entries.append(entry)
                            }
                        }
                        appResponse.entries = entries
                    }
                    appListingResponse = appResponse
                    completed(appListingResponse!)
                }
                break
            case false:
                appListingResponse = AppListingResponse()
                completed(appListingResponse!)
                break
            }
        }
    }
}
