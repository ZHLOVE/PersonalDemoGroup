//
//  MUGImageVM.swift
//  mugshot
//
//  Created by dexter on 15/5/3.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

import UIKit

//这个VM专门用来处理图片
class MUGImageVM: NSObject {

    //原图数据
    dynamic var lastImgFix: UIImage!
    //大框数据
    var area: CGRect!

    //最后一次合成图像
    var backColors: [UIColor]!
    //遮罩图
    //记住第一次从王友金获得要外扩
    //匹配大图大小
    dynamic var maskImage: UIImage!

    init(cont: CAMPicContext) {
        super.init()

        lastImgFix=cont.lastImgFix ?? cont.oriImg
        if let val = cont.param["area"] as? NSValue {
            area = val.CGRectValue()
        }
    }

    init(from: MUGImageVM) {
        super.init()

        lastImgFix=from.lastImgFix
        area=from.area
        maskImage=from.maskImage
    }

    //获取扩展图
    func lastExtImg() -> UIImage {
        return self.getMixImg(lastImgFix, mask: nil, backClr: nil)
    }

    //合成用来做输出的图
    func lastMixImgNoMask() -> UIImage {
        return self.lastMixImgWithColor(nil, areaIn: CGRect(origin: CGPoint.zero,
            size: lastImgFix.size))
    }

    func lastMixImg() -> UIImage {
        return self.getMixImg(lastImgFix, mask: maskImage, backClr: nil)
    }

    func lastMixImgWithColor(colorArr: [UIColor]!, noMask: Bool = false) -> UIImage {
        return self.getMixImg(lastImgFix,
            mask: (MSAfx.infoTaoCan.backdropNull ? nil : maskImage), backClr: colorArr)
    }

    func lastMixImgWithColor(colorArr: [UIColor]!, areaIn: CGRect,
        noMask: Bool = false) -> UIImage {
        let oriImg = lastImgFix
        let mask = (MSAfx.infoTaoCan.backdropNull ? nil : maskImage)
        let backClr = colorArr
        UIGraphicsBeginImageContext(areaIn.size)
        var g=UIGraphicsGetCurrentContext()
        //纯色背景
        UIColor(white: 128/255.0, alpha: 1).setFill()
        CGContextFillRect(g, CGRect(x: 0, y: 0, width: areaIn.width, height: areaIn.height))
        //原图指定位置
        oriImg.drawAtPoint(areaIn.origin)
        var ret: UIImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //如果有mask则套用
        if mask != nil {
            ret=ret.maskImage(mask)
        }
        //如果有渐变则重上底色
        if backClr != nil {
            UIGraphicsBeginImageContext(areaIn.size)
            g=UIGraphicsGetCurrentContext()
            //绘制渐变底色
            let clr=CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
                [backClr[0].CGColor, backClr[1].CGColor], nil)
            CGContextDrawLinearGradient(
                g,
                clr,
                CGPoint(x: areaIn.width/2.0, y: 0),
                CGPoint(x: areaIn.width/2.0, y: areaIn.height),
                CGGradientDrawingOptions(rawValue: 0)
            )

            //上图
            ret.drawAtPoint(CGPoint.zero)
            ret=UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }

        return ret
    }

    private func getMixImg(oriImg: UIImage, mask: UIImage!, backClr: [UIColor]!) -> UIImage {
        UIGraphicsBeginImageContext(area.size)
        var g=UIGraphicsGetCurrentContext()

        //纯色背景
        UIColor(white: 128/255.0, alpha: 1).setFill()
        CGContextFillRect(g, CGRect(x: 0, y: 0, width: area.width, height: area.height))
        //原图指定位置
        oriImg.drawAtPoint(area.origin)
        var ret: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //如果有mask则套用
        if mask != nil {
            ret=ret.maskImage(mask)
        }

        //如果有渐变则重上底色
        if backClr != nil {
            UIGraphicsBeginImageContext(area.size)
            g=UIGraphicsGetCurrentContext()
            //绘制渐变底色
            let clr=CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
                [backClr[0].CGColor, backClr[1].CGColor], nil)

            CGContextDrawLinearGradient(
                g,
                clr,
                CGPoint(x: area.width/2.0, y: 0),
                CGPoint(x: area.width/2.0, y: area.height),
                CGGradientDrawingOptions(rawValue: 0)
            )

            //上图
            ret.drawAtPoint(CGPoint.zero)
            ret=UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }

        return ret
    }
    //这个地方需要修改传入背景色和裁剪框
    //这个裁剪框就是王友金那种噢！
    func getMixImg(backClr: [UIColor], clip: CGRect) -> UIImage {
        let ret=getMixImg(lastImgFix, mask: maskImage, backClr: backClr)

        return UIImage(CGImage:
            CGImageCreateWithImageInRect(
                ret.CGImage,
                CGRect(x: clip.minX+area.minX, y: clip.minY+area.minY,
                    width: clip.width, height: clip.height))!
            )
    }
}
