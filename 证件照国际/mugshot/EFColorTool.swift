//
//  EFColorTool.swift
//  mugshot
//
//  Created by Venpoo on 15/8/21.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(redColor: Int, greenColor: Int, blueColor: Int, alpha: CGFloat) {
        self.init(red: CGFloat(redColor)/255.0, green: CGFloat(greenColor)/255.0,
            blue: CGFloat(blueColor)/255.0, alpha: alpha)
    }

    convenience init(rgbValue: UInt) {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    //绘制纯色图片
    func createImageWithRect(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

//获取两个 UIColor 均值（只支持 RGB 空间颜色）
func midColor(firstColor: UIColor, secondColor: UIColor) -> UIColor {
    let rgbArr_1 = CGColorGetComponents(firstColor.CGColor)
    let rgbArr_2 = CGColorGetComponents(secondColor.CGColor)

    return UIColor(
        red: (rgbArr_1[0] + rgbArr_2[0]) / 2,
        green: (rgbArr_1[1] + rgbArr_2[1]) / 2,
        blue: (rgbArr_1[2] + rgbArr_2[2]) / 2,
        alpha: 1.0
    )
}
