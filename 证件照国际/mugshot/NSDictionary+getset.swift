//
//  NSDictionary_getset.swift
//  mugshot
//
//  Created by dexter on 15/4/20.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

import Foundation

extension NSDictionary {
	func intForKey(key: NSString) -> Int {
		var ret=0
		if let val: AnyObject = self.objectForKey(key) {
            if let value = val as? Int {
                ret = value
            }
		}
		return ret
	}
}

extension NSMutableDictionary {
	func setInt(val: Int, ForKey key: NSString) {
		self.setObject(val, forKey: key)
	}
}
