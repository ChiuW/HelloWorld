//
//  BaseResponse.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 27/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import Foundation

struct AppListingResponse {
    var author : AuthorResponse?
    var entries : [App]?
    var updated : String?
    var rights : String?
    var title : String?
    var icon : String?
    var id : String?
    init() {
        
    }
}

struct AuthorResponse {
    var name : String?
    var uri : String?
    init() {
        
    }
}

struct App {
    var name : String?
    var iconsData : IconsResponse?
    var summary : String?
    var price : price?
    var rights : String?
    var title : String?
    var link : link?
    var id : id?
    var artist : artist?
    var category : CategoryResponse?
    var releaseDate : releaseDate?
}

struct IconsResponse {
    var s_icon : icon?
    var m_icon : icon?
    var l_icon : icon?
}

struct icon {
    var uri : String?
    var size : Int?
}

struct price {
    var name : String?
    var ammount : String?
    var currency : String?
}

struct link {
    var rel : String?
    var type : String?
    var href : String?
}

struct id {
    var name : String?
    var href : String?
}

struct artist {
    var name : String?
    var href : String?
}

struct CategoryResponse {
    var name : String?
    var id : String?
    var terms : String?
    var scheme : String?
    init() {
        
    }
}

struct releaseDate {
    var UTM : String?
    var date : String?
}
