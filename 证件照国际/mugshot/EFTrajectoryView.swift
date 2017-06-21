//
//  EFTrajectoryView.swift
//  beiSaiErQuXian
//
//  Created by junyu on 15/4/17.
//  Copyright (c) 2015年 eyrefree. All rights reserved.
//

import UIKit
import Accelerate
import QuartzCore

class EFTrajectoryView: UIView {

    //setPram 初始化
    weak var controller: MSChangeBGViewController?
    private var blurValue: CGFloat = 0.1
    private var lineWidth: CGFloat = 20.0
    private var oriImage: UIImage!       //原图
    private var backImage: UIImage!      //背景的渐变色图（可以设置成任意图片）

    //init 初始化
    private var maskImage: UIImage!      //算法图
    private var pathImage: UIImage!      //涂抹图
    //可为空
    private var oldPathImage: UIImage!   //用于撤销的图

    override init(frame: CGRect) {
        super.init(frame: frame)

        initCommon()
        return
    }

    //sb 加载
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        initCommon()
        return
    }

    func initCommon() {
        maskImage = UIColor(red: 0, green: 0, blue: 0,
            alpha: 1).createImageWithRect(self.bounds.size)
        pathImage = UIColor(red: 1, green: 1, blue: 1,
            alpha: 0).createImageWithRect(self.bounds.size)
    }

    //初始化，注意这个bgColor必须是rgb颜色空间的
    static func initTrajectoryView(
        frame: CGRect,
        image: UIImage,
        startColor: UIColor,
        endColor: UIColor,
        lineWidth: CGFloat,
        blurDegree: CGFloat,
        state: Bool,
        controller: MSChangeBGViewController?
        ) -> EFTrajectoryView {
            let rtn = EFTrajectoryView(frame: frame)
            rtn.setParm(
                image,
                startColor: startColor,
                endColor: endColor,
                lineWidth: lineWidth,
                blurDegree: blurDegree,
                state: state,
                controller: controller
            )
            return rtn
    }

    func setParm(
        image: UIImage,
        startColor: UIColor,
        endColor: UIColor,
        lineWidth: CGFloat,
        blurDegree: CGFloat,
        state: Bool,
        controller: MSChangeBGViewController?) {
            self.setOriginImage(image)
            self.setBackgroundImage(startColor, colorEnd: endColor)
            self.setTouchState(state)
            self.setTouchWidth(lineWidth)
            self.setBlurDegree(blurDegree)
            self.controller = controller
    }

    private var pointOld: CGPoint!       //最旧的点
    private var pointLast: CGPoint!      //上一个点
    private var pointNow: CGPoint!       //最新的点
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pointOld = (touches as NSSet).anyObject()?.locationInView(self)
        pointLast = (touches as NSSet).anyObject()?.locationInView(self)
        pointNow = (touches as NSSet).anyObject()?.locationInView(self)

        //这是为了可以撤销做的副本
        oldPathImage = pathImage.copy() as? UIImage

        //替换为目标controller
        controller?.touchMark = true

        //发送到上层
        if nil != self.finalCutImage {
            let realP = (touches as NSSet).anyObject()!.locationInView(self)
            controller?.scaleView.touchBegan(
                self.finalCutImage,
                point: CGPoint(x: realP.x - realRect.origin.x, y: realP.y - realRect.origin.y)
            )
        }
        ++touchCount

        //触发Moved
        touchesMoved(touches, withEvent:event)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pointOld = pointLast
        pointLast = pointNow
        pointNow = (touches as NSSet).anyObject()?.locationInView(self)
        //计算中间点
        let mid1: CGPoint = midPoint(pointOld, secondPoint: pointLast)
        let mid2: CGPoint = midPoint(pointNow, secondPoint: pointLast)
        //创建这一次touchu的新的path
        let path: CGMutablePath? = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, mid1.x, mid1.y)
        CGPathAddQuadCurveToPoint(path, nil, pointLast.x, pointLast.y, mid2.x, mid2.y)
        //获取包围path的矩形区域，减少重绘工作量
        var drawBox = CGPathGetBoundingBox(path)
        //计算线宽因素扩大矩形区域使得能够完全容纳path区域
        drawBox.origin.x -= lineWidth * 2
        drawBox.origin.y -= lineWidth * 2
        drawBox.size.width += lineWidth * 4
        drawBox.size.height += lineWidth * 4
        //好像是创建一个上下文（上下文是什么...）
        UIGraphicsBeginImageContext(bounds.size)
        let currentContext: CGContextRef = UIGraphicsGetCurrentContext()!
        //绘制path到当前context
        if nil != path {
            CGContextSetLineWidth(currentContext, lineWidth)
            CGContextSetLineCap(currentContext, CGLineCap.Round)
            CGContextSetStrokeColorWithColor(currentContext, lineColor.CGColor)
            CGContextAddPath(currentContext, path)
            CGContextDrawPath(currentContext, CGPathDrawingMode.Stroke)
        }
        //获取刚画的这一笔
        let yibiPathImage = UIGraphicsGetImageFromCurrentImageContext()
        //将刚画的这一笔合成到pathimage上去
        pathImage.drawInRect(bounds)
        yibiPathImage.drawInRect(bounds)
        pathImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //重绘包围path的矩形区域
        setNeedsDisplayInRect(drawBox)
        //发送到上层
        if nil != self.finalCutImage {
            let realP = (touches as NSSet).anyObject()!.locationInView(self)
            controller?.scaleView.touchMove(
                self.finalCutImage,
                point:CGPoint(x: realP.x - realRect.origin.x, y: realP.y - realRect.origin.y)
            )
        }
    }

    //把这个消息传上去
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //发送到上层
        if nil != self.finalCutImage {
            let realP = (touches as NSSet).anyObject()!.locationInView(self)
            controller?.scaleView.touchEnd(
                self.finalCutImage,
                point:CGPoint(x: realP.x - realRect.origin.x, y: realP.y - realRect.origin.y)
            )
        }

        //发送到上层
        controller?.touchesEnded(touches, withEvent: event)
    }

    private var finalCutImage: UIImage!
    var previewVM: MUGImageVM!
    private var firstDrawRect = true
    private var realRect: CGRect!
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        if firstDrawRect {
            firstDrawRect = false
            let realSize = CGSize.autoSize(bounds.size, targetSize: oriImage.size)
            realRect = CGRect(x: (bounds.width - realSize.width) / 2,
                y: (bounds.height - realSize.height) / 2,
                width: realSize.width,
                height: realSize.height)
        }

        //绘制渐变背景色
        backImage?.drawInRect(realRect)

        //path高斯模糊,并绘制与前景的叠加图
        if nil != pathImage && nil != previewVM {
            MSAfx.contextImage.param["maskImage"] = createFinalMaskImage()
            if let image = MSAfx.contextImage.param["maskImage"] as? UIImage {
                finalCutImage = oriImage.maskImage(image)
                finalCutImage.drawInRect(realRect)
                finalCutImage = finalCutImage.fixOrientationWithSize(realRect.size)
            }
        } else {
            oriImage.drawInRect(realRect)
        }
    }

    //生成遮罩
    private func createFinalMaskImage() -> UIImage {
        if let JYManager = MSJYManager.sharedInstance() as? MSJYManager {
            let area: CGSize = JYManager.getOriArea()

            //这里先将涂抹路径羽化+裁剪，然后在与算法黑白图合并，再与原图做遮罩
            let bigPath_test: UIImage = blur(pathImage).scalingToSize(
                CGSize.eatSize(oriImage.size, targetSize: pathImage.size))
            let tarArea = CGRect(
                x: previewVM.area.minX + (bigPath_test.size.width - maskImage.size.width) / 2,
                y: maskImage.size.height - (previewVM.area.height - previewVM.area.minY)
                    + (bigPath_test.size.height - maskImage.size.height) / 2,
                width: area.width,
                height: area.height
            )
            let tarAreaExp = CGRect(
                x: previewVM.area.minX,
                y: maskImage.size.height - (previewVM.area.height - previewVM.area.minY),
                width: area.width,
                height: area.height
            )
            return mixImagesCenter(maskImage, frontImage:
                bigPath_test.cropImageWithRect(tarArea).resizeWith(maskImage.size,
                    inRect: tarAreaExp))
        } else {
            return UIImage()
        }
    }

    func getMixedImage() -> UIImage {
        if let image = MSAfx.contextImage.param["maskImage"] as? UIImage {
            return mixImagesCenter(backImage, frontImage:
                oriImage.maskImage(image))
        } else {
            return UIImage()
        }
    }

    private func blur(theImage: UIImage) -> UIImage {
        //降低图像质量，提高处理速度，灰度图用不了，好难过。
        /*var quality:CGFloat = 0.00001
        var imageData:NSData = UIImageJPEGRepresentation(theImage, quality)
        var blurredImage:UIImage = UIImage(data:imageData)!
        return gaussianBlur(blurredImage, blurParm: blurValue)*/

        return gaussianBlur(theImage, blurParm: blurValue)
    }

    //获取两个点的中点
    private func midPoint(firstPoint: CGPoint,
        secondPoint: CGPoint) -> CGPoint {
        return CGPoint(x: (firstPoint.x + secondPoint.x) * 0.5,
            y: (firstPoint.y + secondPoint.y) * 0.5)
    }

    //自定义高斯模糊
    private func gaussianBlur(souImg: UIImage, blurParm: CGFloat) -> UIImage {
        //添加alpha通道
        let sourceImg = addAlphaChannel(souImg.CGImage!)
        var blurAmount: CGFloat = blurParm
        //高斯模糊参数(0-1)之间，超出范围强行转成0.5
        if blurAmount < 0.0 || blurAmount > 1.0 {
            blurAmount = 0.5
        }
        var boxSize = Int(blurAmount * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        let img: CGImage = sourceImg
        //手动申请内存＋1
        let inBuffer = UnsafeMutablePointer<vImage_Buffer>.alloc(1)
        //手动申请内存＋2
        let outBuffer = UnsafeMutablePointer<vImage_Buffer>.alloc(1)
        var error: vImage_Error!
        let inProvider =  CGImageGetDataProvider(img)
        let inBitmapData =  CGDataProviderCopyData(inProvider)

        inBuffer.memory.width = vImagePixelCount(CGImageGetWidth(img))
        inBuffer.memory.height = vImagePixelCount(CGImageGetHeight(img))
        inBuffer.memory.rowBytes = CGImageGetBytesPerRow(img)
        inBuffer.memory.data = UnsafeMutablePointer<Void>(CFDataGetBytePtr(inBitmapData))

        //手动申请内存＋3
        let pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img))
        outBuffer.memory.width = vImagePixelCount(CGImageGetWidth(img))
        outBuffer.memory.height = vImagePixelCount(CGImageGetHeight(img))
        outBuffer.memory.rowBytes = CGImageGetBytesPerRow(img)
        outBuffer.memory.data = pixelBuffer

        error = vImageBoxConvolve_ARGB8888(inBuffer,
            outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
            UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        if nil != error {
            error = vImageBoxConvolve_ARGB8888(inBuffer,
                outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            if nil != error {
                error = vImageBoxConvolve_ARGB8888(inBuffer,
                    outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                    UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            }
        }

        let colorSpace =  CGColorSpaceCreateDeviceRGB()
        let ctx = CGBitmapContextCreate(outBuffer.memory.data,
            Int(outBuffer.memory.width),
            Int(outBuffer.memory.height),
            8,
            outBuffer.memory.rowBytes,
            colorSpace,
            //CGBitmapInfo(CGImageAlphaInfo.Last.rawValue))
            CGImageAlphaInfo.PremultipliedLast.rawValue
        )
        let imageRef = CGBitmapContextCreateImage(ctx)
        //手动申请的内存释放
        inBuffer.destroy()
        inBuffer.dealloc(1)
        //手动申请内存＋2
        outBuffer.destroy()
        outBuffer.dealloc(1)
        //手动申请内存＋1
        free(pixelBuffer)
        //手动申请内存＋0
        return UIImage(CGImage:imageRef!)
    }

    //混合两张图片
    private func mixImages(backImage: UIImage, frontImage: UIImage) -> UIImage {
        if backImage.size.width != frontImage.size.width
            || backImage.size.height != frontImage.size.height {
                NSLog("mixImages warning: bg 和 fg 尺寸不同，请确认这是有意义的混合。")
        }
        let rect = CGRect(
            x: 0,
            y: 0,
            width: frontImage.size.width > backImage.size.width
                ? frontImage.size.width : backImage.size.width,
            height: frontImage.size.height > backImage.size.height
                ? frontImage.size.height : backImage.size.height
        )
        UIGraphicsBeginImageContext(rect.size)
        backImage.drawInRect(rect)
        frontImage.drawInRect(rect)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    //混合两张不同尺寸的图片
    private func mixImagesCenter(backImage: UIImage, frontImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(backImage.size)
        backImage.drawInRect(
            CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: backImage.size
            )
        )
        frontImage.drawInRect(
            CGRect(
                origin: CGPoint(x: (backImage.size.width - frontImage.size.width) / 2, y: 0),
                size: frontImage.size
            )
        )
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    //图片尺寸改变
    private func imageByScalingToSize(targetSize: CGSize, image: UIImage) -> UIImage {
        let sourceImage = image
        var newImage: UIImage
        let imageSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat =  targetSize.width
        let targetHeight: CGFloat =  targetSize.height
        var scaleFactor: CGFloat =  0.0
        var scaledWidth: CGFloat =  targetWidth
        var scaledHeight: CGFloat =  targetHeight
        var thumbnailPoint =  CGPoint(x: 0.0, y: 0.0)
        if (CGSizeEqualToSize(imageSize, targetSize) == false) {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat =  targetHeight / height

            if widthFactor < heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            scaledWidth  = width * scaleFactor
            scaledHeight = height * scaleFactor
            if widthFactor < heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else if widthFactor > heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect =  CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.drawInRect(thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    func createSize(usableRect: CGRect, targetSize: CGSize) -> CGSize {
        var width: CGFloat = 0, height: CGFloat = 0
        let usableSize: CGSize = CGSize(width: usableRect.width, height: usableRect.height)

        let targetScale: CGFloat = targetSize.width / targetSize.height
        let usableScale: CGFloat = usableSize.width / usableSize.height

        if targetScale > usableScale {
            width = usableSize.width
            height = CGFloat(Int(usableSize.width / targetScale))
        } else {
            width = CGFloat(Int(usableSize.height * targetScale))
            height = usableSize.height
        }

        return CGSize(width: width, height: height)
    }

    //设置前景图片
    func setOriginImage(image: UIImage) {
        self.oriImage = image
    }
    func getOriginImage() -> UIImage {
        return self.oriImage
    }

    //设置背景颜色
    private var backColor: UIColor!
    func setBackgroundImage(bgImg: UIImage?) {
        if nil == bgImg {
            MSAfx.modelImage.backColors = nil
            self.backImage = oriImage
        } else {
            self.backImage = bgImg
        }
    }
    func setBackgroundImage(colorStart: UIColor, colorEnd: UIColor) {
        backColor = midColor(colorStart, secondColor: colorEnd)
        MSAfx.modelImage.backColors = [colorStart, colorEnd]
        self.setBackgroundImage(createGradientImage(colorStart,
            endColor: colorEnd, size: self.oriImage.size))
    }
    func getBackColor() -> UIColor {
        return backColor
    }

    //设置mask
    func setMaskImage(maskImg: UIImage?) {
        if nil == maskImg {
            self.maskImage = UIColor(red: 255/255.0, green: 255/255.0,
                blue: 255/255.0, alpha: 1).createImageWithRect(self.bounds.size)
        } else {
            self.maskImage = maskImg
        }
    }

    //设置path
    func setPathImage(pathImage: UIImage?) {
        if nil == pathImage {
            self.pathImage = UIColor(red: 255/255.0, green: 255/255.0,
                blue: 255/255.0, alpha: 0).createImageWithRect(self.bounds.size)
        } else {
            self.pathImage = pathImage
        }
    }

    //设置模糊度
    func setBlurDegree(blur: CGFloat) {
        self.blurValue = blur
    }

    //设置线宽
    func setTouchWidth(percentage: CGFloat) {
        self.lineWidth = percentage * 25 / 2.0
    }
    func setTouchWidthValue(value: CGFloat) {
        self.lineWidth = value / 2.0
    }
    func getTouchWidth() -> CGFloat {
        return self.lineWidth
    }

    //设置触摸状态
    private var lineColor: UIColor = UIColor.blackColor()
    func setTouchState(isCover: Bool) {
        self.lineColor = isCover ? UIColor.whiteColor() : UIColor.blackColor()
    }

    //还原所有涂抹
    func clearView() {
        pathImage = UIColor(red: 1, green: 1, blue: 1,
            alpha: 0).createImageWithRect(self.bounds.size)
        refresh()
    }

    //撤销最近的一次触摸(重复调用只触发第一次)
    func clearLastOne() {
        if nil != oldPathImage {
            pathImage = oldPathImage
            refresh()
            oldPathImage = nil
            --touchCount
        }
    }

    var touchCount: Int = 0
    func isMaskChanged() -> Bool {
        return (touchCount > 0)
    }
    func resetChangeCount() {
        touchCount = 0
    }

    //刷新
    func refresh() {
        setNeedsDisplayInRect(self.bounds)
    }
}
