//
//  EFDataTool.swift
//  mugshot
//
//  Created by Venpoo on 15/9/21.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import Foundation

func setLocalKey(key: String, value: String) {
    NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
}

func getLocalKey(key: String) -> String? {
    return NSUserDefaults.standardUserDefaults().stringForKey(key)
}
