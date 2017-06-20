//
//  HomeModels.swift
//  weiBo
//
//  Created by MBP on 16/5/24.
//  Copyright © 2016年 qianliM. All rights reserved.
//

import Foundation

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
        if let dict = data as? NSDictionary{
            id = dict["id"] as? String
            avatar_url = dict["avatar_url"] as? String
            phone_number = dict["phone_number"] as? String
        }
        if nil == id || nil == avatar_url || nil == phone_number || nil == name || nil == created_at {
            return nil
        }
    }
}