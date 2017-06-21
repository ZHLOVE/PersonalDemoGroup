//
//  EFRectTool.swift
//  mugshot
//
//  Created by Venpoo on 15/9/14.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import Foundation

extension CGSize {

    //贴边内嵌,自适应边框
    static func autoSize(staticSize: CGSize, targetSize: CGSize) -> CGSize {
        let targetScale: CGFloat = targetSize.width / targetSize.height
        let usableScale: CGFloat = staticSize.width / staticSize.height

        return (targetScale > usableScale ?
            CGSize(width: staticSize.width, height: CGFloat(staticSize.width / targetScale)) :
            CGSize(width: CGFloat(staticSize.height * targetScale), height: staticSize.height)
        )
    }

    //贴边包裹,和上面这个效果相反
    static func eatSize(staticSize: CGSize, targetSize: CGSize) -> CGSize {
        let targetScale: CGFloat = targetSize.width / targetSize.height
        let usableScale: CGFloat = staticSize.width / staticSize.height

        return (targetScale < usableScale ?
            CGSize(width: staticSize.width, height: CGFloat(staticSize.width / targetScale)) :
            CGSize(width: CGFloat(staticSize.height * targetScale), height: staticSize.height)
        )
    }
}
