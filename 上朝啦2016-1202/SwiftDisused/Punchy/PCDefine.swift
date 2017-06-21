//
//  PCDefine.swift
//  Punchy
//
//  Created by MBP on 16/4/7.
//  Copyright © 2016年 leqi. All rights reserved.
//

import Foundation

var userInfo: employeeModel!

let defaults: NSUserDefaults = .standardUserDefaults()

let loadingView = UILoadingView()

// MARK: - Tokens
var refreshToken: String? {
get {
    return defaults.stringForKey("refreshTokenKey")
}
set(newToken) {
    defaults.setObject(newToken, forKey: "refreshTokenKey")
}
}

var accessToken: String? {
get {
    return defaults.stringForKey("accessTokenKey")
}
set(newToken) {
    defaults.setObject(newToken, forKey: "accessTokenKey")
}
}

var userID: String? {
get {
    return defaults.stringForKey("userIDKey")
}
set(newID) {
    defaults.setObject(newID, forKey: "userIDKey")
}
}

var userAvatar: UIImage!

var imageToUpLoad: UIImage!
