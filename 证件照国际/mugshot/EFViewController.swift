//
//  EFUIController.swift
//  mugshot
//
//  Created by Venpoo on 15/9/12.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class EFViewController: UIViewController {

    //将跳转后的VC的导航栏返回按钮标题设为“ ”
    override func viewWillDisappear(animated: Bool) {
        let returnButtonItem: UIBarButtonItem = UIBarButtonItem()
        returnButtonItem.title = " "
        self.navigationItem.backBarButtonItem = returnButtonItem
    }
}
