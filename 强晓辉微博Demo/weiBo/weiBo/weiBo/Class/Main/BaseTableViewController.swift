//
//  BaseTableViewController.swift
//  weiBo
//
//  Created by MBP on 16/5/24.
//  Copyright © 2016年 qianliM. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate{
    //定义一个变量保存用户当前是否登录
    var userLogin = false
    // 定义属性保存未登录界面
    var visitorView: VisitorView?

    override func loadView() {
        userLogin ? super.loadView():setupVisitorView()
    }

    //MARK - 内部控制方法
    //创建未登陆界面
    private func setupVisitorView(){
        //1.初始化未登录界面
        let customView = VisitorView()
        customView.delegate = self
        self.view = customView

        //2.设置导航条未登录按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.registerBtnWillClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.loginBtnWillClick))
    }
    // MARK: - VisitorViewDelegate
    func loginBtnWillClick() {
        print(__FUNCTION__)
    }
    func registerBtnWillClick() {
        print(__FUNCTION__)
    }
}
