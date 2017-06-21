//
//  network.swift
//  mugshot
//
//  Created by Venpoo on 15/8/18.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit
import Alamofire


// API 基础 URL，包含所有 API 节点
//let baseURL = NSURL(string: "http://192.168.1.223:5000/v1")!
let baseURL = NSURL(string: "http://api-global.camcap.us/v1")!


// API 节点，用来拼接生成 URL
enum EndPoint {
    case Tokens
    case Backdrops
    case Categories
    case SpecsInCategory(Int)
    case StorageService

    func url() -> NSURL {
        switch self {
        case .Tokens:
            return baseURL.URLByAppendingPathComponent("/tokens")

        case .Backdrops:
            return baseURL.URLByAppendingPathComponent("/backdrops")

        case .Categories:
            return baseURL.URLByAppendingPathComponent("/categories")

        case .SpecsInCategory(let category_id):
            return baseURL.URLByAppendingPathComponent("/categories/\(category_id)/specs")

        case .StorageService:
            return baseURL.URLByAppendingPathComponent("/services/storage")
        }
    }
}

class MSNetwork {

    static let sharedInstance = MSNetwork()

    static var modelOnline = true

    private static let appLanguage: String = {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let languages = defaults.objectForKey("AppleLanguages") as? [String],
           let language = languages.first {
            let start = language.startIndex
            let end = start.advancedBy(2, limit: language.endIndex)
            return language[start..<end]
        }
        return "en"  // 如果获取系统语言失败，则默认是英语
    }()

    let manager: Alamofire.Manager

    init() {
        var defaultHeaders = Alamofire.Manager.defaultHTTPHeaders
        defaultHeaders["Accept-Language"] = MSNetwork.appLanguage

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        configuration.timeoutIntervalForRequest = 60  // 单位秒；默认 60 秒
        configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
        manager = Alamofire.Manager(configuration: configuration)
    }
    //UUID
    private static let lastUUIDKey = "MSAfx_lastUUIDKey"
    dynamic var uuid: String! = NSUserDefaults.standardUserDefaults()
        .stringForKey(MSNetwork.lastUUIDKey) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(uuid,
                forKey: MSNetwork.lastUUIDKey)
        }
    }
    func getUUID() -> String {
        if nil != uuid {
            return uuid
        }
        return String(CFStringCreateCopy(nil, CFUUIDCreateString(nil, CFUUIDCreate(nil))))
    }

    //登录 /tokens
    private static let lastTokenKey="MSNetwork_lastTokenKey"
    dynamic var networkToken: String! = NSUserDefaults.standardUserDefaults()
        .stringForKey(MSNetwork.lastTokenKey) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(networkToken,
                forKey: MSNetwork.lastTokenKey)
        }
    }
    func getTokens(finish: (String?, NSError?, String?) -> Void) {
        if nil == networkToken {
            manager.request(.POST, EndPoint.Tokens.url(),
                parameters: ["install_id":getUUID()],
                encoding: .JSON).response() {
                    (request, response, dataOri, error) in
                    let data = MSAfx.dataToDictionary(dataOri!)
                    if nil != error || nil == data {
                        print(error)
                        finish(nil, nil, NSLocalizedString("Loading failed, please try again",
                            comment: ""))
                        return
                    }
                if let dic = data as? NSDictionary {
                    switch response!.statusCode {
                    case 201:
                        let res: String? = dic["token"] as? String
                        self.networkToken = res
                        finish(res, nil, nil)
                        break
                    case 400:
                        let res: String? = dic["message"] as? String
                        finish(nil, nil, res)
                        break
                    default:
                        finish(nil, nil, "服务器状态异常")
                        break
                    }
                }
            }
        } else {
            finish(networkToken, nil, nil)
        }
    }

    //背景板信息 /backdrops
    func getBackdrops(finish: ([BackdropModel]?, NSError?) -> Void) {
        let convertData = { (data: AnyObject) -> [BackdropModel] in
            var backdrops = [BackdropModel]()
            if let dict = data as? [String : AnyObject],
                let raw_backdrops = dict["backdrops"] as? [AnyObject] {
                for raw_backdrop in raw_backdrops {
                    if let backdrop = BackdropModel(data: raw_backdrop) {
                        backdrops.append(backdrop)
                    }
                }
            } else {
                debugPrint(data)
            }
            return backdrops
        }
        if MSNetwork.modelOnline {
            manager.request(.GET, EndPoint.Backdrops.url(),
                parameters: nil, encoding: .JSON).validate().responseJSON() {
                response in

                switch response.result {
                case .Success(let data):
                    MSNetworkDefault.sharedInstance.setBackdrops(data,
                        language: MSNetwork.appLanguage)
                    finish(convertData(data), nil)

                case .Failure(let error):
                    debugPrint(error)
                    finish(nil, error)
                }
            }
        } else {
            let data = MSNetworkDefault.sharedInstance.getBackdrops(MSNetwork.appLanguage)
            finish(convertData(data), nil)
        }
    }

    //证件照分类信息 /categories
    func getCategories(finish: ([CategoryModel]?, NSError?) -> Void) {
        if MSNetwork.modelOnline {
            manager.request(.GET, EndPoint.Categories.url(), parameters: nil,
                encoding: .JSON).response() {
                (request, response, dataOri, error) in
                let data = MSAfx.dataToDictionary(dataOri!)
                if nil != error || 200 != response!.statusCode {
                    MSNetwork.modelOnline = false
                    finish(nil, nil)
                    return
                }
                MSNetworkDefault.sharedInstance.setCategories(data!,
                    language:MSNetwork.appLanguage)
                var res = [CategoryModel]()
                if let dic = data as? NSDictionary {
                    if let raw_categories = dic["categories"] as? NSArray {
                        for raw_category in raw_categories {
                            if let category = CategoryModel(data: raw_category) {
                                res.append(category)
                            }
                        }
                    }
                }
                finish(res, nil)
            }
        } else {
            if let dic = MSNetworkDefault.sharedInstance.getCategories(
                MSNetwork.appLanguage) as? NSDictionary {
                let raw_categories = dic["categories"] as? NSArray
                var res = [CategoryModel]()
                if let raw_categories = raw_categories {
                    for raw_category in raw_categories {
                        if let category = CategoryModel(data: raw_category) {
                            res.append(category)
                        }
                    }
                }
                finish(res, nil)
            }
        }
    }

    //证件照分类信息 /categories/{category_id}/specs
    func getCategorieDetailByID(categoryId: Int,
        finish: (CateInfoModel?, NSError?, String?) -> Void) {
        if MSNetwork.modelOnline {
            manager.request(.GET, EndPoint.SpecsInCategory(categoryId).url(),
                parameters: nil,
                encoding: .JSON).response() {
                (request, response, dataOri, error) in
                let data = MSAfx.dataToDictionary(dataOri!)
                if nil != error || nil == data {
                    print(error)
                    finish(nil, nil, NSLocalizedString(
                        "Loading failed, please try again", comment: ""))
                    return
                }
                switch response!.statusCode {
                case 200:
                    MSNetworkDefault.sharedInstance.setCategorieDetailByID(data!,
                        categoryId: categoryId, language:MSNetwork.appLanguage)
                    let res: CateInfoModel? = CateInfoModel(data: data ?? [])
                    finish(res, nil, nil)
                    break
                case 404:
                    finish(nil, nil, "The specified classification is not found")
                    break
                default:
                    finish(nil, nil, "Server failure")
                    break
                }
            }
        } else {
            let res: CateInfoModel? = CateInfoModel(data: MSNetworkDefault
                .sharedInstance.getCategorieDetailByID(categoryId, language: MSNetwork.appLanguage))
            finish(res, nil, nil)
        }
    }

    // MARK: - 价目表
    func getStorageService(finish: (StorageServiceModel?, NSError?) -> Void) {
        manager.request(.GET, EndPoint.StorageService.url(),
            parameters: nil, encoding: .JSON).validate().responseJSON() {
            response in

            switch response.result {
            case .Success(let data):
                if let model = StorageServiceModel(data: data) {
                    finish(model, nil)
                } else {
                    finish(nil, nil)
                }

            case .Failure(let error):
                debugPrint(error)
                finish(nil, error)
            }
        }
    }
}
