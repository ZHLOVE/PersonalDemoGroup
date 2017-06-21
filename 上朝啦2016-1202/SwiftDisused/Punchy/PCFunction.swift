//
//  PCFunction.swift
//  Punchy
//
//  Created by MBP on 16/4/7.
//  Copyright © 2016年 leqi. All rights reserved.
//

import UIKit
import DAAlertController
import SystemConfiguration.CaptiveNetwork

//获取构建信息
struct BuildConfigInfo {
    var buildTime: String!
    var gitSha: String!
}

func getBuildConfigInfo() -> BuildConfigInfo {
    var rtn = BuildConfigInfo()
    if let buildConfigFilePath = NSBundle.mainBundle()
        .pathForResource("BuildConfig", ofType: "plist") {
        if let dict = NSDictionary(contentsOfFile: buildConfigFilePath) {
            rtn.buildTime = dict["BUILD_TIME"] as? String
            rtn.gitSha = dict["GIT_SHA"] as? String
        }
    }
    return rtn
}

//SHA1
func getDataSHA1(data: NSData,
                 length: Int32 = CC_SHA1_DIGEST_LENGTH) -> String {
    let digestLen = Int(length)
    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
    CC_SHA1(data.bytes, UInt32(data.length), result)
    let hash = NSMutableString()
    for i in 0..<digestLen {
        hash.appendFormat("%02x", result[i])
    }
    result.dealloc(digestLen)
    return String(hash)
}

//获取 wifi 信息
func getWifiInfo() -> (success: Bool, ssid: String, mac: String) {
    if let cfas: NSArray = CNCopySupportedInterfaces() {
        for cfa in cfas {
            if let dict = CFBridgingRetain(
                CNCopyCurrentNetworkInfo(cfa as! CFString)) {
                let ssid = dict["SSID"]!
                let mac  = dict["BSSID"]!
                return (true,ssid as! String,mac as! String)
            }
        }
    }
    return (false, "", "")
}

//获取手机型号
func getDeviceModel() -> String {
    return UIDevice.currentDevice().model
}

//获取系统版本号
func getSystemVersion() -> String {
    return UIDevice.currentDevice().systemVersion
}

//获取屏幕宽度
func getScreenSize() -> CGSize {
    return UIScreen.mainScreen().bounds.size
}

//状态栏高度
func getHeightStatusBar() -> CGFloat {
    return UIApplication.sharedApplication().statusBarFrame.height
}

//导航栏高度
func getHeightNavigationBar(controller: UIViewController) -> CGFloat {
    if let navi = controller.navigationController {
        return navi.navigationBar.frame.height
    }
    return 0
}

//简单提示对话款-操作失败
func messageBox(
    controller: UIViewController,
    content: String,
    actions: [AnyObject]! = [DAAlertAction(
    title: "确定", style: .Default, handler: nil)]
    ) {
    DAAlertController.showAlertViewInViewController(
        controller,
        withTitle: nil,
        message: content,
        actions: actions
    )
}

//是否为手机号
func isPhoneNumber(stringToTest: String) -> Bool {
    let regex = "^(?:(?:\\+|00)?(86|886|852|853))?(1\\d{10})$"
    return NSPredicate(format: "SELF MATCHES %@", regex)
        .evaluateWithObject(stringToTest)
}

//是否为验证码
func isCaptcha(stringToTest: String) -> Bool {
    let regex = "[0-9]{6}"
    return NSPredicate(format: "SELF MATCHES %@", regex)
        .evaluateWithObject(stringToTest)
}

//检查accessToken
func checkTokens(finish: (Bool) -> Void) {
    if let rfsToken = refreshToken {
        if let _ = accessToken {
            PunchyAPIProvider.request(.Employers(page: 1, perPage: 1, name: "")) {
                result in
                if case let .Success(response) = result {
                    finish(true)
                } else {
                    PunchyAPIProvider.request(.TokensAccess(refreshToken: rfsToken)) {
                        result in
                        if case let .Success(response) = result {
                            if let json = (try? response.mapJSON()) as? NSDictionary {
                                if let tokens = json["tokens"] as? NSDictionary {
                                    if let access_token = tokens["access_token"] as? String {
                                        accessToken = access_token
                                        finish(true)
                                    }
                                }
                            }
                        } else {
                            finish(false)
                        }
                    }
                }
            }
        } else {
            PunchyAPIProvider.request(.TokensAccess(refreshToken: rfsToken)) {
                result in
                if case let .Success(response) = result {
                    if let json = (try? response.mapJSON()) as? NSDictionary {
                        if let tokens = json["tokens"] as? NSDictionary {
                            if let access_token = tokens["access_token"] as? String {
                                accessToken = access_token
                                finish(true)
                            }
                        }
                    }
                } else {
                    finish(false)
                }
            }
        }
    } else {
        finish(false)
    }
}

func logout() {
    userAvatar = nil
    userInfo = nil
    refreshToken = nil
    accessToken = nil
    userID = nil
}

// MARK: - 下载图片
func getImages(urls: [String], finish: ([UIImage]) -> Void) {
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            var arrImgs: [UIImage] = [UIImage]()
            for ele in urls {
                arrImgs.append(UIImage(url: ele) ?? UIImage(named: "placeholder.jpg")!)
            }
            dispatch_async(dispatch_get_main_queue()) {
                finish(arrImgs)
            }
    })
}
