//
//  AppDelegate.swift
//  weiBo
//
//  Created by MBP on 16/5/23.
//  Copyright © 2016年 qianliM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        //1 创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        //2创建根控制器
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        return true
    }


}

