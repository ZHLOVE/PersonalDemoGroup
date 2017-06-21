//
//  MSAfx.swift
//  mugshot
//
//  Created by Venpoo on 15/9/22.
//  Copyright (c) 2015年 junyu. All rights reserved.
//
//  对，你没有猜错，这是全局变量存放点，污
//

import UIKit
import DAAlertController

//证件照合成参数
class MSCateInfoPKG: NSObject {
    var catePre: CategoryModel!
    var cateInfoSpec: CateInfoSpecModel!
    var backdrops: Array<BackdropModel>!
    //背景色 id
    var backdropId: Int = 0
    //背景为空
    var backdropNull: Bool = false
}

class MSAfx {
    //隐藏平台数量
    static var shareHiddenCount: Int = 0
    //清理数据
    static func clearAfx(all: Bool = false) {
        MSAfx.imageMask = nil
        MSAfx.imageBack = nil
        MSAfx.imageMix = nil
        MSAfx.imageExt = nil

        MSAfx.contextImage = nil
        MSAfx.modelImage = nil

        MSAfx.preViewController = nil

        MSAfx.infoTaoCan.backdropNull = false
        MSAfx.infoTaoCan.backdropId = 0

        if all {
            MSAfx.infoTaoCan.catePre = nil
            MSAfx.infoTaoCan.cateInfoSpec = nil
            MSAfx.infoTaoCan.backdrops = nil
        }
    }

    //通用灰色背景色
    static let bgColor = UIColor(redColor: 239, greenColor: 239, blueColor: 244, alpha: 1)

    //加载
    static let loadingView: UILoadingView = UILoadingView()
    //身份证号码
    static var cardNum: String!
    //套餐信息
    static let infoTaoCan: MSCateInfoPKG = MSCateInfoPKG()

    //图片结构
    static var contextImage: CAMPicContext!
    static var modelImage: MUGImageVM!

    //订单用图
    static var imageMask: UIImage!
    static var imageBack: UIImage!
    static var imageMix: UIImage!
    //暂存区
    static var imageExt: UIImage!

    //aaaaa
    weak static var preViewController: MSPreviewViewController!
    weak static var menuController: MSMenuViewController!
    static var gotoMyOrder: Bool = false
    static var ordersNeedRefresh: Bool = false
    static var ordersSatisfiedNeedRefresh: Bool = false

    //获取小图
    static func getBoxImage(bigImg: UIImage, area: CGRect) -> UIImage {
        let tarArea = CGRect(
            x: MSAfx.modelImage.area.minX + area.minX,
            y: MSAfx.modelImage.area.minY + area.minY,
            width: area.size.width,
            height: area.size.height
        )
        return bigImg.cropImageWithRect(tarArea)
    }

    //获取当前的顶层视图
    static func getTopView(controller: UIViewController) -> UIView {
        var recentView: UIViewController = controller
        while recentView.parentViewController != nil {
            recentView = recentView.parentViewController!
        }
        return recentView.view
    }

    //状态栏高度
    static func getHeightStatusBar() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height
    }

    //导航栏高度
    static func getHeightNavigationBar(controller: UIViewController) -> CGFloat {
        return controller.navigationController!.navigationBar.frame.height
    }

    //从 backdrops 中获取
    static func getBackdropModelByID(index: Int) -> BackdropModel! {
        for ele in MSAfx.infoTaoCan.backdrops {
            if ele.backdropID == index {
                return ele
            }
        }
        return nil
    }

    //简单提示对话款-操作失败
    static func messageBox(
        controller: UIViewController,
        content: String,
        actions: [AnyObject]! = [DAAlertAction(title: "确定", style: .Default, handler: nil)]
        ) {
            DAAlertController.showAlertViewInViewController(
                controller,
                withTitle: "操作失败",
                message: content,
                actions: actions
            )
    }

    //获取日期
    static func getTimeString() -> String {
        let date: NSDate = NSDate()
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        return formatter.stringFromDate(date)
    }

    //转换
    static func dictionaryToData(dict: AnyObject? ) -> NSData? {
        if nil == dict {
            return nil
        }
        do {
            return try NSJSONSerialization.dataWithJSONObject(dict!,
                options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            return nil
        }
    }
    static func dataToDictionary(data: NSData?) -> AnyObject? {
        if nil == data {
            return nil
        }
        do {
            return try NSJSONSerialization.JSONObjectWithData(data!,
                options: NSJSONReadingOptions.AllowFragments)
        } catch {
            return nil
        }
    }

    //去除所有手势
    static func removeGestureAll(controller: UIViewController) {
        if nil != controller.navigationController {
            if controller.navigationController!.respondsToSelector(
                "interactivePopGestureRecognizer") {
                // 禁用返回手势
                controller.navigationController!.interactivePopGestureRecognizer!.enabled = false
            }
        }

        //移除当前视图和顶层视图的所有手势，所有！丧心病狂怎么了！！！
        for ele in [controller.view, getTopView(controller)] {
            if let gestures = ele.gestureRecognizers {
                for gesture in gestures {
                    ele.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    
    //拼合图像
    static func createBigImg(
        info: CateInfoSpecModel,
        smallImg: UIImage) -> UIImage {
        //垂直翻转
        let area = CGRect(origin: CGPoint(x: 0, y: 0), size: smallImg.size)
        UIGraphicsBeginImageContext(smallImg.size)
        let currentContext = UIGraphicsGetCurrentContext()
        CGContextClipToRect(currentContext, area)
        CGContextDrawImage(currentContext, area, smallImg.CGImage)
        let smallImg_fix = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //拼合
        let tarSize = CGSize(
            width: (info.paper?.widthPx)!, height: (info.paper?.heightPx)!
        )
        UIGraphicsBeginImageContext(tarSize)
        let context = UIGraphicsGetCurrentContext()
        //填充白色背景
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(
            context, CGRect(origin: CGPoint(x: 0, y: 0), size: tarSize)
        )
        //画小图
        for ele in (info.paper?.slots)! {
            let isChangeRotation = 0 != ele.rotationCcw! % 180
            CGContextDrawImage(
                context,
                CGRect(
                    origin: CGPoint(x: ele.originX!, y: ele.originY!),
                    size: (isChangeRotation ?
                        CGSize(width: info.heightPx!, height: info.widthPx!+((MSAfx.cardNum != nil)&&(info.textAreaPx != nil) ? info.textAreaPx!:0)) :
                        CGSize(width: info.widthPx!, height: info.heightPx!+((MSAfx.cardNum != nil)&&(info.textAreaPx != nil) ? info.textAreaPx!:0)))
                ),
                //旋转指定角度
                smallImg_fix.imageRotatedByDegrees(CGFloat(ele.rotationCcw!))
                    .CGImage
            )
            let singleV = UIColor.blackColor().createImageWithRect(CGSize(width: 1, height: 1))
            singleV.drawInRect(CGRect(x: ele.originX!-3, y: 0, width: 3, height: (info.paper?.heightPx)!))
            singleV.drawInRect(CGRect(x: ele.originX!+(isChangeRotation ? info.heightPx! : info.widthPx!), y: 0, width: 3, height: (info.paper?.heightPx)!))
            singleV.drawInRect(CGRect(x: 0, y: ele.originY!-3, width: (info.paper?.widthPx)!, height: 3))
            singleV.drawInRect(CGRect(x: 0, y: ele.originY!+(isChangeRotation ? info.widthPx! : info.heightPx!)+((MSAfx.cardNum != nil)&&(info.textAreaPx != nil) ? info.textAreaPx!:0), width: (info.paper?.widthPx)!, height: 3))
        }
        //再循环一遍画边框
        for elr in (info.paper?.slots)! {
            let isChangeRotation = 0 != elr.rotationCcw! % 180
            let bounds = CGRect(x: elr.originX!-4, y: elr.originY!-4,
                                width: (isChangeRotation ? info.heightPx! : info.widthPx!)+8, height: (isChangeRotation ? info.widthPx! : info.heightPx!)+((MSAfx.cardNum != nil)&&(info.textAreaPx != nil) ? info.textAreaPx!:0)+8)
            let pathRect = CGRectOffset(bounds, 0, 0)
            let path = UIBezierPath(rect: pathRect)
            path.lineWidth = 8
            UIColor.whiteColor().setStroke()
            path.stroke()
        }
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    //MARK:-检测是否需要隐藏微信相关内容
    static func isWXUmengHidden() -> Bool {
        let parm = MobClick.getConfigParams("WXHide")
        return parm == (NSBundle.mainBundle()
            .infoDictionary!["CFBundleShortVersionString"] as? String ?? "Beta")
    }
}
