//
//  MainViewController.swift
//  weiBo
//
//  Created by MBP on 16/5/23.
//  Copyright © 2016年 qianliM. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置当前控制器的对应tabBar的颜色
        //在iOS7以前只有文字会变
        tabBar.tintColor = UIColor.orangeColor()
        //添加子控制器
        addChildViewController()
        //从iOS7开始不推荐大家在viewDidload中设置Frame
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //添加加号按钮
        setupComposeBtn()
    }
    //监听按钮点击方法前不能用private
    func composeBtnClick(){
        print(__FUNCTION__)
    }
    //MARK - 内部控制方法
    private func setupComposeBtn(){
        //1添加加号按钮
        tabBar.addSubview(composeBtn)
        //2调整加号按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect = CGRectMake(0, 0, width, 49)
        composeBtn.frame = rect
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
    }

    //添加所有子控制器
    private func addChildViewController() {
        //1获取JSON文件路径
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings", ofType: "json")
        //2通过文件路径创建NSData，模拟从服务器加载名字创建控制器
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            //3序列化JSON数据->Array
            //序列化可能会抛异常
            //try:发生异常会调到catch中继续执行
            //tyr!:发生异常程序会直接崩溃
            do{
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options:NSJSONReadingOptions.MutableContainers)
                //4遍历数组，动态创建控制器和设置数据
                //在swift中，遍历数组，必须明确数据类型
                for dict in dictArr as! [[String:String]]{
                    //报错原因是addChildViewController参数必须有值，但是字典返回值是可选类型
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
            }catch{
                print(error)
                //如果发生错误，就从本地加载控制器
                addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }

        }
    }

    //初始化子控制器
    private func addChildViewController(childControllerName: String,title:String, imageName:String) {

        //-1动态获取命名空间
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        //0 将字符串转换为类
        //0.1命名空间默认情况下就是项目的名字,但是命名空间是可以修改的
        let cls : AnyClass? =  NSClassFromString(ns + "." + childControllerName)
        //0.2通过类创建对象
        //0.2.1将anyClass转换为指定的类型
        let vcClS = cls as! UIViewController.Type
        //0.2.2通过class创建对象
        let vc = vcClS.init()
//        print(vc)

//        //1.1设置首页TabBar对应数据
        vc.tabBarItem.image = UIImage(named:imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        vc.title = title
//        //2给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
//        //3将导航控制器添加到当前控制器上
        addChildViewController(nav)

    }



    //MARK:-懒加载
    private lazy var composeBtn: UIButton = {
        let btn = UIButton()
        //2 设置前景图片
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        //3.设置背景图片
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        //4 添加点击监听
        btn.addTarget(self, action: Selector("composeBtnClick"), forControlEvents:UIControlEvents.TouchUpInside)

        return btn
    }()
}
