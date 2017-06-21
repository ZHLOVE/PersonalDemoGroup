//

//  MSNetworkDefault.swift

//  mugshot

//

//  Created by Venpoo on 15/9/28.

//  Copyright (c) 2015年 junyu. All rights reserved.

//



import UIKit



class MSNetworkDefault {
    static let sharedInstance = MSNetworkDefault()

    //背景板信息 /backdrops
    private static let lastdefaultBackdropsKey = "MSNetworkDefault_lastdefaultBackdropsKey"
    dynamic var defaultBackdrops: AnyObject! = NSUserDefaults.standardUserDefaults()
        .objectForKey(MSNetworkDefault.lastdefaultBackdropsKey) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(defaultBackdrops,
                forKey: MSNetworkDefault.lastdefaultBackdropsKey)
        }
    }

    //背景板信息 /japan
    private static let japdefaultBackdropsKey = "MSNetworkDefault_japdefaultBackdropsKey"
    dynamic var japBackdrops: AnyObject! = NSUserDefaults.standardUserDefaults()
        .objectForKey(MSNetworkDefault.japdefaultBackdropsKey) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(japBackdrops,
                forKey: MSNetworkDefault.japdefaultBackdropsKey)
        }
    }

    func getBackdrops(language: String) -> AnyObject {
        switch language {
        case "ja":
            if japBackdrops == nil {
                let path = NSBundle.mainBundle().pathForResource("getBackdrops", ofType: "json")!
                japBackdrops = NSData(contentsOfFile: path)!
            }
            return MSAfx.dataToDictionary(japBackdrops as? NSData)!

        default:
            if defaultBackdrops == nil {
                let path = NSBundle.mainBundle().pathForResource("getBackdrops", ofType: "json")!
                defaultBackdrops = NSData(contentsOfFile: path)!
            }
            return MSAfx.dataToDictionary(defaultBackdrops as? NSData)!
        }
    }

    func setBackdrops(data: AnyObject, language: String) {
        switch language {
        case "ja":
            japBackdrops = MSAfx.dictionaryToData(data)

        default:
            defaultBackdrops = MSAfx.dictionaryToData(data)
        }
    }

    //证件照分类信息 /categories
    private static let lastdefaultCategoriesKey = "MSNetworkDefault_lastdefaultCategoriesKey"
    dynamic var defaultCategories: AnyObject! = NSUserDefaults.standardUserDefaults()
        .objectForKey(MSNetworkDefault.lastdefaultCategoriesKey) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(defaultCategories,
                forKey: MSNetworkDefault.lastdefaultCategoriesKey)
        }
    }

    //证件照分类信息 /japan
    private static let japdefaultCategoriesKey = "MSNetworkDefault_japdefaultCategoriesKey"
    dynamic var japCategories: AnyObject! = NSUserDefaults.standardUserDefaults()
        .objectForKey(MSNetworkDefault.japdefaultCategoriesKey) {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(japCategories,
                forKey: MSNetworkDefault.japdefaultCategoriesKey)
        }
    }

    func getCategories(language: String) -> AnyObject {
        if language != "ja" {
            if defaultCategories == nil {
                defaultCategories = NSData(contentsOfFile: NSBundle.mainBundle()
                    .pathForResource("getCategories", ofType: "json")!)!
            }
            return MSAfx.dataToDictionary(defaultCategories as? NSData)!
        } else {
            if japCategories == nil {
                japCategories = NSData(contentsOfFile: NSBundle.mainBundle()
                    .pathForResource("getCategories", ofType: "json")!)!
            }
            return MSAfx.dataToDictionary(japCategories as? NSData)!
        }
    }
    func setCategories(data: AnyObject, language: String) {
        if language != "ja" {
            defaultCategories = MSAfx.dictionaryToData(data)
        } else {
            japCategories = MSAfx.dictionaryToData(data)
        }
    }

    //证件照分类信息 /categories/{category_id}/specs
    func getCategorieDetailByID(categoryId: Int, language: String) -> AnyObject {
        var lastdefaultCategorieDetailKey: String!
        if language != "ja" {
            lastdefaultCategorieDetailKey =
            "MSNetworkDefault_lastdefaultCategorieDetailKey_\(categoryId)"
        } else {
            lastdefaultCategorieDetailKey =
            "MSNetworkDefault_lastdefaultCategorieDetailKey\(categoryId)"
        }
        var categorie: AnyObject? = NSUserDefaults.standardUserDefaults()
            .objectForKey(lastdefaultCategorieDetailKey)
        if categorie == nil {
            categorie = NSData(contentsOfFile: NSBundle.mainBundle()
                .pathForResource("getCategorie\(categoryId)", ofType: "json")!)!
            if let cateData = categorie as? NSData {
                setCategorieDetailByID(MSAfx.dataToDictionary(cateData)!,
                    categoryId: categoryId, language:language)
            }
        }
        return MSAfx.dataToDictionary(categorie as? NSData)!
    }

    func setCategorieDetailByID(data: AnyObject, categoryId: Int, language: String) {
        if language != "ja" {
            NSUserDefaults.standardUserDefaults().setObject(MSAfx.dictionaryToData(data),
                forKey: "MSNetworkDefault_lastdefaultCategorieDetailKey_\(categoryId)")
        } else {
            NSUserDefaults.standardUserDefaults().setObject(MSAfx.dictionaryToData(data),
                forKey: "MSNetworkDefault_lastdefaultCategorieDetailKey\(categoryId)")
        }
    }
}
