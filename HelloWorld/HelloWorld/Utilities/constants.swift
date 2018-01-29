//
//  constants.swift
//  HelloWorld
//
//  Created by Wing Chiu Choi on 24/1/2018.
//  Copyright © 2018 Wing Chiu Choi. All rights reserved.
//

import Foundation
//https://itunes.apple.com/hk/rss/topfreeapplications/limit=100/json and
//
//https://itunes.apple.com/hk/lookup?id=%5bapp_id
//
//https://itunes.apple.com/hk/rss/topgrossingapplications/limit=10/json

let API_SSL_PROTOCOL = "https://"

let API_SERVICE_DOMAIN = "itunes.apple.com/hk/"
let API_SERVICE_APLICTION_GET_LIST = "rss/topfreeapplications/limit=100/json"
let API_SERVICE_APLICTION_GET_GROSSING_LIST = "rss/topgrossingapplications/limit=10/json"
let API_SERVICE_APLICTION_GET_APP_DETAIL = "lookup?id="


func getApplicationList() -> String{
    let URL = "\(API_SSL_PROTOCOL)\(API_SERVICE_DOMAIN)\(API_SERVICE_APLICTION_GET_LIST)"
    return URL
}

func getTopGrossingAppListing() -> String{
    let URL = "\(API_SSL_PROTOCOL)\(API_SERVICE_DOMAIN)\(API_SERVICE_APLICTION_GET_GROSSING_LIST)"
    return URL
}

func getApplicationDetailByID(appID : String) ->String{
    let searchURL = "\(API_SSL_PROTOCOL)\(API_SERVICE_DOMAIN)\(API_SERVICE_APLICTION_GET_APP_DETAIL)\(appID)"
    return searchURL
}
