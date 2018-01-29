//
//  RLM_AppList.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 28/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import UIKit
import RealmSwift

class RLM_AppItem: Object {
    @objc dynamic var ranking : Int = 0
    @objc dynamic var isrecommend : Bool = false
    @objc dynamic var name:String = ""
    @objc dynamic var icon:String = ""
    @objc dynamic var summary:String = ""
    @objc dynamic var price:String = ""
    @objc dynamic var rights:String = ""
    @objc dynamic var title:String = ""
    @objc dynamic var link:String = ""
    @objc dynamic var id:String = ""
    @objc dynamic var artist:String = ""
    @objc dynamic var category:String = ""
    @objc dynamic var releaseDate:String = ""
}

class RLM_RecomAppItem: Object {
    @objc dynamic var ranking : Int = 0
    @objc dynamic var isrecommend : Bool = true
    @objc dynamic var name:String = ""
    @objc dynamic var icon:String = ""
    @objc dynamic var summary:String = ""
    @objc dynamic var price:String = ""
    @objc dynamic var rights:String = ""
    @objc dynamic var title:String = ""
    @objc dynamic var link:String = ""
    @objc dynamic var id:String = ""
    @objc dynamic var artist:String = ""
    @objc dynamic var category:String = ""
    @objc dynamic var releaseDate:String = ""
}
