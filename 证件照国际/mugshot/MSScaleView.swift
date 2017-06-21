//
//  MSScaleView.swift
//  mugshot
//
//  Created by Venpoo on 15/9/10.
//  Copyright (c) 2015年 junyu. All rights reserved.
//


import UIKit

class MSScaleView: UIImageView {

    private weak var controller: MSChangeBGViewController?

    let margin: CGFloat = 4
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: CGPoint(x: margin, y: margin), size: frame.size))

        layer.cornerRadius = 8
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1
        clipsToBounds = true
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        NSLog("未定义的初始化过程!")
    }

    func setController(par: MSChangeBGViewController) {
        controller = par
        controller!.view.addSubview(self)
    }

    //开始触摸
    func touchBegan(img: UIImage, point: CGPoint) {
        self.hidden = false
        action(img, point: point)
    }

    //触摸移动中
    func touchMove(img: UIImage, point: CGPoint) {
        action(img, point: point)
    }

    //触摸结束
    func touchEnd(img: UIImage, point: CGPoint) {
        self.hidden = true
    }

    func action(img: UIImage, point: CGPoint) {
        checkPos(point)
        self.image = getScaleImage(img, point: point)
    }

    //调整放大镜位置
    func checkPos(point: CGPoint) {
        if (self.frame.height + margin - controller!.frontView.frame.origin.y + 10) > point.y {
            if point.x > (controller!.frontView.frame.width / 2) {
                self.frame = CGRect(
                    origin: CGPoint(x: margin, y: margin),
                    size: self.frame.size
                )
            } else {
                self.frame = CGRect(
                    origin: CGPoint(x: controller!.view.frame.width - margin - self.frame.width,
                        y: margin),
                    size: self.frame.size
                )
            }
        }
    }

    //设置放大镜图片
    func getScaleImage(img: UIImage, point: CGPoint) -> UIImage {
        //处理放大事件
        let x = min(max(point.x - 30, 0), img.size.width - 60 - 1)
        let y = min(max(point.y - 30, 0), img.size.height - 60 - 1)
        let rect = CGRect(x: x, y: y, width: 60, height: 60)
        let dp = CGPoint(x: point.x - x, y:point.y - y)

        let subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect)
        let smallBounds = CGRect(
            x: 0,
            y: 0,
            width: CGImageGetWidth(subImageRef),
            height: CGImageGetHeight(subImageRef)
        )

        UIGraphicsBeginImageContextWithOptions(smallBounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, controller?.frontView.getBackColor().CGColor)
        CGContextFillRect(context, CGRect(x: 0, y: 0,
            width: smallBounds.size.width, height: smallBounds.size.height))

        CGContextSaveGState(context)

        CGContextTranslateCTM(context, 0, smallBounds.height)
        CGContextScaleCTM(context, 1, -1)
        CGContextDrawImage(context, smallBounds, subImageRef)

        CGContextRestoreGState(context)

        let rValue = CGFloat((controller?.frontView)!.getTouchWidth()) / 2
        let ovalPath = UIBezierPath(
            ovalInRect: CGRect(
                x: dp.x - rValue,
                y: dp.y - rValue,
                width: rValue * 2,
                height: rValue * 2
            )
        )
        UIColor(rgbValue: 0xffb400).setStroke()
        ovalPath.stroke()

        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return ret
    }
}
