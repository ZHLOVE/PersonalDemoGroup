//
//  EFStringTool.swift
//  mugshot
//
//  Created by Venpoo on 15/8/23.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

func isBlankString(str: String?) -> Bool {
    if nil != str {
        if "" != str! {
            return false
        }
    }
    return true
}
