//
//  MSColorSelectView.swift
//  mugshot
//
//  Created by Venpoo on 15/8/31.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class MSColorSelectView: UIView {
    weak var controller: MSChangeBGViewController?
    //颜色列表
    var backdrops: Array<BackdropModel> = Array<BackdropModel>()
    var btnArr: [EFRoundButton] = Array<EFRoundButton>()
    init(frame: CGRect, colors: Array<BackdropModel>!) {
        super.init(frame: frame)
        backdrops = colors
        setupControllers()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupControllers()
    }

    func setupControllers() {
        MSAfx.infoTaoCan.backdropId = MSAfx.infoTaoCan.cateInfoSpec.backdropIds[0]
        btnArr.removeAll(keepCapacity: false)
        var scroll: UIScrollView? = self.viewWithTag(23333) as? UIScrollView
        if scroll != nil {
            scroll?.removeFromSuperview()
        }
        scroll = UIScrollView()
        scroll!.tag = 23333
        self.addSubview(scroll!)
        scroll!.frame = CGRect(x: 0, y: 0,
            width: UIScreen.mainScreen().applicationFrame.size.width,
            height: self.frame.height)

        let marginTry: CGFloat = (UIScreen.mainScreen()
            .bounds.width - CGFloat(21 * 2 + 29 * 6)) / CGFloat(5)
        let margin: CGFloat = (marginTry > 0 ? marginTry : 19)
        scroll!.contentSize = CGSize(width: ((margin + 29) * CGFloat(backdrops.count + 1)
            + 42 - margin),
            height: CGFloat(90))
        scroll!.bounces = false
        scroll!.showsHorizontalScrollIndicator = false
        let cha = scroll!.frame.width - scroll!.contentSize.width
        var x: CGFloat = 21 - margin
        if cha > 0 {
            x += cha / 2
        }
        for var i: Int = 0; i < backdrops.count; ++i {
            //按钮间距
            x += margin
            let btn: EFRoundButton = EFRoundButton(frame: CGRect(x: x, y: 22,
                width: 29, height: 29))
            btnArr.append(btn)
            btn.tag = i
            btn.colorImage = [backdrops[i].beginColor!, backdrops[i].endColor!]
            btn.contentMode = UIViewContentMode.ScaleAspectFill
            btn.addTarget(self, action: "btnClicked:",
                forControlEvents: UIControlEvents.TouchUpInside)
            scroll!.addSubview(btn)
            let txt: UILabel = UILabel()
            txt.text = backdrops[i].name
            txt.font = UIFont.systemFontOfSize(11)
            txt.textColor = UIColor(white: 122 / 255.0, alpha: 1)
            txt.sizeToFit()
            txt.center = CGPoint(x: CGRectGetMidX(btn.frame), y: 72)
            scroll!.addSubview(txt)
            //按钮宽度
            x += 29
        }
        x += margin
        let btn: EFRoundButton = EFRoundButton(frame: CGRect(x: x, y: 22, width: 29, height: 29))
        btnArr.append(btn)
        btn.tag = backdrops.count
        btn.setImage(UIImage(named: "change_button_ori")!, forState: UIControlState.Normal)
        btn.contentMode = UIViewContentMode.ScaleAspectFill
        btn.addTarget(self, action: "btnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        scroll!.addSubview(btn)
        let txt = UILabel()
        txt.text = NSLocalizedString("Original", comment: "")
        txt.font = UIFont.systemFontOfSize(11)
        txt.textColor = UIColor(white: 122 / 255.0, alpha: 1)
        txt.sizeToFit()
        txt.center = CGPoint(x: CGRectGetMidX(btn.frame), y: 72)
        scroll!.addSubview(txt)
        //初始化控件状态
        btnArr[0].selected = true
    }

    func btnClicked(sender: AnyObject) {
        if let btn = sender as? UIButton {
            for ele in btnArr {
                if btn.tag == ele.tag {
                    ele.selected = true
                    if btn.tag == backdrops.count {
                        MSAfx.infoTaoCan.backdropId = backdrops[0].backdropID!
                        MSAfx.infoTaoCan.backdropNull = true
                        controller?.frontView.setBackgroundImage(nil)
                    } else {
                        MSAfx.infoTaoCan.backdropId = backdrops[btn.tag].backdropID!
                        MSAfx.infoTaoCan.backdropNull = false
                        controller?.frontView.setBackgroundImage(
                            backdrops[btn.tag].beginColor!,
                            colorEnd: backdrops[btn.tag].endColor!
                        )
                    }
                    controller?.frontView.refresh()
                } else {
                    ele.selected = false
                }
            }
        }
    }
}
