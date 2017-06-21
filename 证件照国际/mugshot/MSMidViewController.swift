//
//  MSMidViewController.swift
//  mugshot
//
//  Created by 沈阳 on 16/1/26.
//  Copyright © 2016年 junyu. All rights reserved.
//

import Foundation

class MSMidViewController: EFViewController {
    let centerV = UIView()

    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createMidView()
    }

    func createMidView() -> UIButton {
        self.addGreyBack()

        //中央弹出框
        centerV.frame = CGRect(x: (self.view.frame.width-210)/2, y: self.view.frame.height+125,
            width: 210, height: 187)
        centerV.layer.cornerRadius = 5
        centerV.backgroundColor = UIColor.whiteColor()
        backBtn.addSubview(centerV)

        let messageL = UILabel()
        messageL.frame = CGRect(x: 0, y: 35,
            width: CGRectGetWidth(centerV.frame), height: 15)
        messageL.text = NSLocalizedString("Already saved.", comment: "")
        messageL.textColor = MSColor.wordBlack2
        messageL.font = UIFont.systemFontOfSize(15)
        messageL.textAlignment = NSTextAlignment.Center
        centerV.addSubview(messageL)

        let info = NSLocalizedString("Already saved.", comment: "")
        let width = countSize(info)
        let okView = UIImageView()
        okView.image = UIImage(named: "icon_succeed")
        okView.frame = CGRect(x: (centerV.frame.width-width)/2-30, y: 30,
            width: 25, height: 25)
        centerV.addSubview(okView)

        let checkBtn = UIButton()
        checkBtn.frame = CGRect(x: 10, y: CGRectGetMaxY(messageL.frame)+25,
            width: CGRectGetWidth(centerV.frame)-20, height: 40)
        checkBtn.backgroundColor = MSColor.mainLightBlue
        checkBtn.layer.cornerRadius = 5
        checkBtn.tag = 1
        checkBtn.setTitle(NSLocalizedString("Check my photos.", comment: ""),
            forState: UIControlState.Normal)
        checkBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        checkBtn.setTitleColor(UIColor(rgbValue: 0xffffff), forState: UIControlState.Normal)
        checkBtn.addTarget(self, action: Selector("hideMidPopView:"),
            forControlEvents: UIControlEvents.TouchUpInside)
        centerV.addSubview(checkBtn)

        let shutBtn = UIButton()
        shutBtn.frame = CGRect(x: 10, y: CGRectGetMaxY(checkBtn.frame)+15,
            width: CGRectGetWidth(centerV.frame)-20, height: 40)
        shutBtn.setTitle(NSLocalizedString("Close", comment: ""),
            forState: UIControlState.Normal)
        shutBtn.setTitleColor(MSColor.mainLightBlue, forState: UIControlState.Normal)
        shutBtn.layer.borderColor = MSColor.mainLightBlue.CGColor
        shutBtn.layer.borderWidth = 1.0
        shutBtn.layer.cornerRadius = 5
        shutBtn.tag = 0
        shutBtn.addTarget(self, action: Selector("hideMidPopView:"),
            forControlEvents: UIControlEvents.TouchUpInside)
        centerV.addSubview(shutBtn)

        let tarView = MSAfx.getTopView(self)
        UIView.animateWithDuration(0.5,
            animations: {
                self.centerV.frame.origin.y = (tarView.frame.height - 125) / 2
                self.view.backgroundColor = UIColor(red: 153/255, green: 153/255,
                    blue: 153/255, alpha: 1)
            },
            completion: nil
        )

        return backBtn
    }

    //隐藏弹出框
    func hideMidPopView(sender: AnyObject) {
        NSLog("hideMidPopView")
        let tarView = MSAfx.getTopView(self)
        if let btn = sender as? UIButton {
            let index = btn.tag
            if 0 == index {
                NSLog("hideMidPopView:0")
                UIView.animateWithDuration(0.5,
                    animations: {
                        self.centerV.frame.origin.y = tarView.frame.height + 125
                    },
                    completion: {
                        (Bool) -> Void in
                        self.removeGreyBack()
                })
            } else {
                NSLog("hideMidPopView:1")
                self.centerV.frame.origin.y = tarView.frame.height + 125
                self.removeGreyBack()

                switch index {
                case 1:
                    //查看我的证件照，这不能展示只好这么干咯
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        "showMyIDphoto", object: nil)
                    break
                default:
                    break
                }
            }
        }
    }

    //添加底部灰色遮罩
    func addGreyBack() {
        let tarView = MSAfx.getTopView(self)
        //底层暗色背景
        backBtn.tag = 0
        backBtn.backgroundColor = UIColor(redColor: 0,
            greenColor: 0, blueColor: 0, alpha: 0.35)
        backBtn.frame = CGRect(x: 0, y: 0,
            width: tarView.frame.width, height: tarView.frame.height)
        backBtn.addTarget(
            self,
            action: Selector("hideMidPopView:"),
            forControlEvents: UIControlEvents.TouchUpInside
        )
        tarView.addSubview(backBtn)
    }

    //移除底部灰色遮罩
    func removeGreyBack() {
        if backBtn != nil {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    func countSize(content: String) -> CGFloat {
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(13)]
        let option = NSStringDrawingOptions.UsesFontLeading
        let rect = content.boundingRectWithSize(CGSize(width: 1000, height: 15),
            options: option, attributes: attributes, context: nil)
        let width = rect.size.width
        return width
    }
}
