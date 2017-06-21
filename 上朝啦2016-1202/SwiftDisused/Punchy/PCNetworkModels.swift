//
//  PCNetworkModels.swift
//  Punchy
//
//  Created by MBP on 16/4/7.
//  Copyright © 2016年 leqi. All rights reserved.
//

import Foundation

//雇员
class employeeModel: NSObject {

    var id: String!
    var avatar_url: String!
    var phone_number: String!
    var name: String!
    var created_at: String!

    init?(_ data: AnyObject?) {
        super.init()
        if nil == data {
            return nil
        }
        if let dict = data as? NSDictionary {
            id = dict["id"] as? String
            avatar_url = dict["avatar_url"] as? String
            phone_number = dict["phone_number"] as? String
            name = dict["name"] as? String
            created_at = dict["created_at"] as? String
        }
        if nil == id || nil == avatar_url || nil == phone_number || nil == name || nil == created_at {
            return nil
        }
    }
}

class employersModel: NSObject {

    var address: String!
    var id: String!
    var created_at: String!
    var image_url: String!
    var phone_number: String!
    var is_verified: Bool!
    var name: String!

    init?(_ data: AnyObject?) {
        super.init()
        if nil == data {
            return nil
        }
        if let dict = data as? NSDictionary {
            address = dict["address"] as? String
            id = dict["id"] as? String
            created_at = dict["created_at"] as? String
            image_url = dict["avatar_url"] as? String
            phone_number = dict["phone_number"] as? String
            is_verified = dict["is_verified"] as? Bool
            name = dict["name"] as? String
        }
        if nil == address
            || nil == id
            || nil == created_at
            || nil == phone_number
            || nil == is_verified
            || nil == name {
            return nil
        }
    }
}

class punchyModel: NSObject {

    var id: String!
    var created_at: String!

    init?(_ data: AnyObject?) {
        super.init()
        if nil == data {
            return nil
        }
        if let dict = data as? NSDictionary {
            id = dict["id"] as? String
            created_at = dict["created_at"] as? String
        }
        if nil == id || nil == created_at {
            return nil
        }
    }
}