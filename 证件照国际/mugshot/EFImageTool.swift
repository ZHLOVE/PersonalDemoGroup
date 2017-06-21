//
//  UIImage+SP.swift
//  mugshot
//
//  Created by dexter on 15/4/29.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {

    //从url初始化图片
    convenience init?(url: String) {
        var choice = false
        let ns = NSURL(string: url)
        var nd: NSData!
        if ns != nil {
            nd = NSData(contentsOfURL:ns!)
            if nd != nil {
                choice = true
            }
        }
        if choice {
            self.init(data:nd!)
        } else {
            self.init(named: "menu_init")
        }
    }

    static func colorImageFromPath(path: UIBezierPath, clr: UIColor,
        scale: CGFloat = 0.0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(path.bounds.size, false, scale)

        clr.setFill()
        path.fill()

        let ret=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }

    func gaussianBlur(var blurAmount: CGFloat) -> UIImage {
        //高斯模糊参数(0-1)之间，超出范围强行转成0.5
        if blurAmount < 0.0 || blurAmount > 1.0 {
            blurAmount = 0.5
        }

        var boxSize = Int(blurAmount * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        let img = self.CGImage
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        let inProvider =  CGImageGetDataProvider(img)
        let inBitmapData =  CGDataProviderCopyData(inProvider)
        inBuffer.width = vImagePixelCount(CGImageGetWidth(img))
        inBuffer.height = vImagePixelCount(CGImageGetHeight(img))
        inBuffer.rowBytes = CGImageGetBytesPerRow(img)
        inBuffer.data = UnsafeMutablePointer<Void>(CFDataGetBytePtr(inBitmapData))

        //手动申请内存
        let pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img))
        outBuffer.width = vImagePixelCount(CGImageGetWidth(img))
        outBuffer.height = vImagePixelCount(CGImageGetHeight(img))
        outBuffer.rowBytes = CGImageGetBytesPerRow(img)
        outBuffer.data = pixelBuffer

        var error = vImageBoxConvolve_ARGB8888(&inBuffer,
            &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
            UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        if kvImageNoError != error {
            error = vImageBoxConvolve_ARGB8888(&inBuffer,
                &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            if kvImageNoError != error {
                error = vImageBoxConvolve_ARGB8888(&inBuffer,
                    &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                    UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            }
        }
        let colorSpace =  CGColorSpaceCreateDeviceRGB()
        let ctx = CGBitmapContextCreate(outBuffer.data,
            Int(outBuffer.width),
            Int(outBuffer.height),
            8,
            outBuffer.rowBytes,
            colorSpace,
            CGImageAlphaInfo.PremultipliedLast.rawValue
        )
        let imageRef = CGBitmapContextCreateImage(ctx)

        //手动申请内存
        free(pixelBuffer)
        return UIImage(CGImage:imageRef!)
    }

    //给图添加遮罩
    func maskImage(maskImage: UIImage) -> UIImage {
        let maskRef = maskImage.CGImage
        let mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
            CGImageGetHeight(maskRef),
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef), nil, true)

        if let image = self.copy() as? UIImage {
            let imageWithAlpha = addAlphaChannel(image.CGImage!)
            let masked = CGImageCreateWithMask(imageWithAlpha, mask)
            return UIImage(CGImage:masked!)
        } else {
            return UIImage()
        }
    }

    //反黑白色
    //本来是8位居然服务器只支持32位
    func invGray() -> UIImage {
        let imageRef=self.CGImage
        let width = CGImageGetWidth(imageRef)
        let height = CGImageGetHeight(imageRef)

        let colorSpace=CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        let buf=UnsafeMutablePointer<UInt8>.alloc(bytesPerRow*height)

        let context=CGBitmapContextCreate(buf, width, height,
            bitsPerComponent, bytesPerRow, colorSpace,
            CGImageAlphaInfo.PremultipliedLast.rawValue
        )
        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: width, height: height), imageRef)

        for var i=0;i<bytesPerRow*height;i+=4 {
            buf[i] = 255 - buf[i]
            buf[i+1] = 255 - buf[i+1]
            buf[i+2] = 255 - buf[i+2]
        }

        let ret=UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        buf.destroy()
        buf.dealloc(1)
        return ret
    }

    //裁剪出一部分
    func caijianWithRect(previewVM: MUGImageVM) -> UIImage {
        let rect = CGRect(
            x: previewVM.area.minX,
            y: previewVM.area.height - previewVM.area.minY
                - previewVM.lastImgFix.size.height + (self.size.height
                    - previewVM.lastImgFix.size.height),
            width: previewVM.lastImgFix.size.width,
            height: previewVM.lastImgFix.size.height
        )

        return (self.cropImageWithRect(rect)).resizeWith(self.size, inRect: rect)
    }
}

//给图片添加alpha通道，这个函数不知道有木有问题...
func addAlphaChannel(sourceImage: CGImage) -> CGImage {
    let width =  CGImageGetWidth(sourceImage)
    let height =  CGImageGetHeight(sourceImage)
    let colorSpace =  CGColorSpaceCreateDeviceRGB()

    let offscreenContext =  CGBitmapContextCreate(nil, width, height,
        8, 0, colorSpace,
        CGImageAlphaInfo.PremultipliedLast.rawValue
    )

    CGContextDrawImage(offscreenContext, CGRect(x: 0, y: 0, width: width, height: height),
        sourceImage)
    return CGBitmapContextCreateImage(offscreenContext)!
}

//绘制渐变图片
func createGradientImage(beginColor: UIColor, endColor: UIColor, size: CGSize) -> UIImage {
    //获取rgb
    let components_begin = CGColorGetComponents(beginColor.CGColor)
    let components_end = CGColorGetComponents(endColor.CGColor)

    //创建渐变规则
    let rgb: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
    let colors = [
        components_begin[0], components_begin[1], components_begin[2], 1.00,
        components_end[0], components_end[1], components_end[2], 1.00,
    ]

    //画图
    UIGraphicsBeginImageContext(size)
    CGContextDrawLinearGradient(
        UIGraphicsGetCurrentContext(),
        CGGradientCreateWithColorComponents(rgb, colors, nil, 2),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: size.height),
        CGGradientDrawingOptions(rawValue: 1))
    let rtImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return rtImage
}

//计算jpeg质量
func imgCompressParmSingle(testImg: UIImage, minLength: CGFloat, maxLength: CGFloat) -> CGFloat {
    let LOOP_TIME: Int = 24
    var JpegQuality: CGFloat = 1.0
    if maxLength > 0 {
        for var i = 0; i <= LOOP_TIME; ++i {
            JpegQuality = 1.0 - CGFloat(i) * (1.0 / CGFloat(LOOP_TIME))
            let JpegLength: Int = UIImageJPEGRepresentation(testImg, JpegQuality)!.length
            NSLog("imgCompressParm : %lf = %d", JpegQuality, JpegLength)
            if CGFloat(JpegLength) <= maxLength {
                break
            } else if LOOP_TIME == i {
                JpegQuality = 0.0001
            }
        }
    }
    return JpegQuality
}

//计算jpeg质量 单位B ; 带单图约束的 只支持两张图
func imgCompressParm(testImg: [UIImage], maxLength: CGFloat,
    imgLen: [CGFloat]! = nil) -> [CGFloat] {
    if nil != imgLen && (imgLen.count != 2 * testImg.count) {
        NSLog("imgCompressParm 参数异常!")
    }
    let LOOP_TIME: Int = 24
    if nil == imgLen || (imgLen.count != 2 * testImg.count) {
        var JpegQuality: CGFloat = 1.0
        for var i = 0; i <= LOOP_TIME; ++i {
            JpegQuality = 1.0 - CGFloat(i) * (1.0 / CGFloat(LOOP_TIME))
            var JpegLength: Int = 0
            for ele in testImg {
                JpegLength += UIImageJPEGRepresentation(ele, JpegQuality)!.length
            }
            NSLog("imgCompressParm : %lf = %d", JpegQuality, JpegLength)
            if CGFloat(JpegLength) <= maxLength {
                break
            } else if LOOP_TIME == i {
                JpegQuality = 0.0001
            }
        }
        var rtn = Array<CGFloat>()
        for var i = 0; i <= testImg.count; ++i {
            rtn.append(JpegQuality)
        }
        return rtn
    } else {
        let yasuo_1: CGFloat = imgCompressParmSingle(testImg[0],
            minLength: imgLen[0], maxLength: imgLen[1])
        let JpegLengthLeave = maxLength -
            CGFloat(UIImageJPEGRepresentation(testImg[0], yasuo_1)!.length)
        let yasuo_2: CGFloat = imgCompressParmSingle(testImg[1],
            minLength: 0, maxLength: JpegLengthLeave)
        return [yasuo_1, yasuo_2]
    }
}

func getMixImg(oriImg: UIImage, mask: UIImage!, backClr: [UIColor]!, area: CGRect) -> UIImage {
    UIGraphicsBeginImageContext(area.size)
    var g=UIGraphicsGetCurrentContext()
    //纯色背景
    UIColor(white: 128/255.0, alpha: 1).setFill()
    CGContextFillRect(g, CGRect(x: 0, y: 0, width: area.width, height: area.height))
    //原图指定位置
    oriImg.drawAtPoint(area.origin)

    var ret: UIImage=UIGraphicsGetImageFromCurrentImageContext()
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
