//
//  UIImage+Ext.swift
//  Punchy
//
//  Created by MBP on 16/5/9.
//  Copyright © 2016年 leqi. All rights reserved.
//

import Foundation

extension UIImage {

    //从url初始化图片
    convenience init?(url: String) {
        var choice = false
        let ns = NSURL(string: url)
        var nd: NSData!
        if ns != nil {
            nd = NSData(contentsOfURL: ns!)
            if nd != nil {
                choice = true
            }
        }
        if choice {
            self.init(data: nd!)
        } else {
            self.init(named: "menu_init")
        }
    }
}