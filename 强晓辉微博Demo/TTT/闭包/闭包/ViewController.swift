//
//  ViewController.swift
//  闭包
//
//  Created by MBP on 16/5/23.
//  Copyright © 2016年 qianliM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         闭包和Block相似
         都是保存一段代码，在需要时候执行
         做耗时操作
        */

        // block 返回值（^block）(){}
        /*
         闭包基本格式
         in的含义用于区分形参返回值和执行代码
         {
         (形参列表)->()
         in
         需要执行的代码
         }
         */
    }

    func loadData(finash:()->())
    {
        print("执行耗时操作")
        //回调通知调用者
        finash()
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //swift 中 dispatch_async回调中是一个闭包
        dispatch_async(dispatch_get_global_queue(0, 0)) {()->Void in
            print(NSThread.currentThread())
            print("耗时操作")
        }

        dispatch_async(dispatch_get_main_queue()) { ()->Void in
            print(NSThread.currentThread())
            print("回到主线程更新UI")
        }
    }
}

