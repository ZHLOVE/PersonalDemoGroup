
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {

        //获取构建信息
        print("\(getBuildConfigInfo())")

        //获取 wifi 信息
        let wifiInfo = getWifiInfo()
        if wifiInfo.0 {
            NSLog("热点名称: \(wifiInfo.1)")
        }
        //获取手机型号
        NSLog("本机型号：\(getDeviceModel())")
        //获取系统版本
        NSLog("系统版本: \(getSystemVersion())")

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
}
