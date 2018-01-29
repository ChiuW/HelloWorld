//
//  RLM_DB_STATUS.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 29/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import Foundation
import RealmSwift

class RLM_DbStatus: Object {
    @objc dynamic var isListingFetchSuccess: Bool = false;
    @objc dynamic var isRecommendFetchSuccess: Bool = false;
}
