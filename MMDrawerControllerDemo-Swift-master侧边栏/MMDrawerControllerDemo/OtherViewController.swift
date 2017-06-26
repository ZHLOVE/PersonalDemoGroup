//
//  OtherViewController.swift
//  MMDrawerControllerDemo
//
//  Created by wjl on 15/11/13.
//  Copyright © 2015年 Martin. All rights reserved.
//
/*
    Github： https://github.com/Wl201314
    微博：http://weibo.com/5419850564/profile?rightmod=1&wvr=6&mod=personnumber
*/
import UIKit

class OtherViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "通用页"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Done_2"), style: UIBarButtonItemStyle.Plain, target: self, action: "doneSlide")
        self.view.backgroundColor = UIColor.grayColor()
    }
    
    func doneSlide(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        
        
    }

}
