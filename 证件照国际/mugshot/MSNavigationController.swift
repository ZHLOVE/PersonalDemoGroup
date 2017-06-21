//
//  MSNavigationController.swift
//  mugshot
//
//  Created by Venpoo on 15/8/20.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class MSNavigationController: UINavigationController, UINavigationControllerDelegate {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func navigationController(navigationController: UINavigationController,
        willShowViewController viewController: UIViewController, animated: Bool) {
        //隐藏状态栏
        navigationController.setNavigationBarHidden(
            viewController.respondsToSelector("hideNavigationController"),
            animated: false)

        MSAfx.removeGestureAll(self)
    }
}
