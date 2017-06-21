//
//  UIColor+valueRGB.swift
//  EyreFree
//
//  Created by EyreFree on 16/4/6.
//  Copyright © 2016年 eyrefree. All rights reserved.
//

import UIKit

extension UIColor {

    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(valueRGB: UInt) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}