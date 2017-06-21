//
//  AppDelegate.swift
//  mugshot
//
//  Created by Venpoo on 15/8/13.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {

        setupUmeng()

        let mainColor = UIColor(redColor: 33, greenColor: 150, blueColor: 243, alpha: 1)
        setGlobalStyle(mainColor)

        loadStory()

        // Enable automated usage reporting.
        #if IS_PRO

        #else
            ACTAutomatedUsageTracker.enableAutomatedUsageReportingWithConversionID("948649756")
            ACTConversionReporter.reportWithConversionID("948649756",
                label: "K993CMysxmMQnP6sxAM", value: "0.10", isRepeatable: false)
        #endif
        return true
    }

    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {

    }

    func applicationWillTerminate(application: UIApplication) {

    }


    func setGlobalStyle(mainColor: UIColor) {
        let whiteColor: UIColor = UIColor.whiteColor()

        // 全局的各种颜色
        if nil != self.window {
            self.window!.tintColor = mainColor
        }

        // 导航栏
        let navigationBarProxy: UINavigationBar = UINavigationBar.appearance()
        navigationBarProxy.backgroundColor = mainColor
        navigationBarProxy.barTintColor = mainColor     // 背景色
        navigationBarProxy.tintColor = whiteColor       // 按钮、图标等颜色
        navigationBarProxy.titleTextAttributes = [
            NSForegroundColorAttributeName: whiteColor, // 标题色
            NSFontAttributeName:UIFont.systemFontOfSize(19)
        ]
        navigationBarProxy.barStyle = UIBarStyle.Black

        // 去除导航栏底边白线
        let bgImg: UIImage = mainColor.createImageWithRect(
            CGSize(width: UIScreen.mainScreen().bounds.width, height: 20))
        navigationBarProxy.setBackgroundImage(bgImg,
            forBarPosition: .TopAttached, barMetrics: .Default)
        navigationBarProxy.shadowImage = UIImage()

        // 设置状态栏字体颜色
        let app = UIApplication.sharedApplication()
        app.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    }

    //MARK:-友盟设置
    func setupUmeng() {
        let appKey = "563318a9e0f55a306a0000de"

        // 反馈
        UMFeedback.setAppkey(appKey)
        // 统计 unused
        MobClick.setCrashReportEnabled(false)
        MobClick.startWithAppkey(appKey)
        // 在线参数
        MobClick.updateOnlineConfig()
        //分享
        UMSocialData.setAppKey("563318a9e0f55a306a0000de")
        //打开友盟日志
        UMSocialData.openLog(false)
        //Instagram
        UMSocialInstagramHandler.openInstagramWithScale(false, paddingColor: UIColor.blackColor())
        //Line只能分享纯文本消息或者纯图片消息
        UMSocialLineHandler.openLineShare(UMSocialLineMessageTypeText)
        //Whatsapp只能分享纯文本或者纯图片消息
        UMSocialWhatsappHandler.openWhatsapp(UMSocialWhatsappMessageTypeText)
        //Tumblr
        UMSocialTumblrHandler.openTumblr()
        //隐藏指定没有安装客户端的平台
        hiddenSharePlant()
    }

    func hiddenSharePlant() {
        let appUrlArray: NSArray = ["instagram://",
                                    "whatsapp://",
                                    "line://",
                                    "fbshareextension://",
                                    "twitter://",
                                    "tumblr://"]
        let appHidArray: NSMutableArray = []
        for appUrlStr in appUrlArray {
            let appUrl: NSURL = NSURL(string: appUrlStr as! String)!
            if !UIApplication.sharedApplication().canOpenURL(appUrl) {
                switch appUrlStr as! String {
                case "instagram://" : appHidArray.addObject(UMShareToInstagram)
                    break
                case "whatsapp://" : appHidArray.addObject(UMShareToWhatsapp)
                    break
                case "line://" : appHidArray.addObject(UMShareToLine)
                    break
                case "fbshareextension://" : appHidArray.addObject(UMShareToFacebook)
                    break
                case "twitter://" : appHidArray.addObject(UMShareToTwitter)
                    break
                case "tumblr://" : appHidArray.addObject(UMShareToTumblr)
                    break
                default:
                    break
                }
            }
        }
        print(appHidArray.count)
        MSAfx.shareHiddenCount = appHidArray.count
        UMSocialConfig.hiddenNotInstallPlatforms(appHidArray.copy() as! [AnyObject])
    }


    func setupFirstRun() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let infoDictionary = NSBundle.mainBundle().infoDictionary!  // 有 Info.plist 则不为空
        let versionKey = "CFBundleVersion"
        let savedVersionKey = "MUG_SAVE_VERSION"
        if let currentVersion = infoDictionary[versionKey] as? String,
           let savedVersion = defaults.stringForKey(savedVersionKey) {
            // 当前版本高于已记录的版本
            if currentVersion.compare(savedVersion, options: .NumericSearch) == .OrderedDescending {
                let firstRunKey = "MUG_FIRST_RUN"
                defaults.setBool(false, forKey: firstRunKey)  // 设置欢迎页为未显示状态
            }
            defaults.setObject(currentVersion, forKey: savedVersionKey)
        }
    }

    func loadStory() {
        // 设置欢迎页显示状态
        setupFirstRun()

        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navi = storyboard.instantiateInitialViewController() as? UINavigationController {
            let defaults = NSUserDefaults.standardUserDefaults()
            if defaults.boolForKey("MUG_FIRST_RUN") {
                window?.rootViewController = navi
            } else {
                let open = DEXOpenController()
                open.nextView = navi.topViewController!.view
                open.nextCtrl = navi

                window?.rootViewController = open
            }
            window?.makeKeyAndVisible()
        }
    }
}
