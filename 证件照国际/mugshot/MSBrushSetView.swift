//
//  MSBrushSetView.swift
//  mugshot
//
//  Created by Venpoo on 15/8/31.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class MSBrushSetView: UIView {
    weak var controller: MSChangeBGViewController?

    //按钮列表
    var btnArr1: [UIButton] = Array<UIButton>()
    var btnArr2: [UIButton] = Array<UIButton>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControllers()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupControllers()
    }

    private var firstAppear = true
    func setupControllers() {
        if firstAppear {
            btnArr1.removeAll(keepCapacity: false)
            var scroll: UIScrollView? = self.viewWithTag(4399) as? UIScrollView
            if scroll != nil {
                scroll?.removeFromSuperview()
            }
            scroll = UIScrollView()
            scroll!.tag = 4399
            self.addSubview(scroll!)

            let marginTry: CGFloat = (UIScreen.mainScreen().bounds.width -
                CGFloat(21 * 2 + 29 * 6)) / CGFloat(5)
            let margin: CGFloat = (marginTry > 0 ? marginTry : 19)
            scroll!.frame = CGRect(x: 0, y: 0,
                width: UIScreen.mainScreen().applicationFrame.size.width,
                height: self.frame.height)
            scroll!.contentSize = CGSize(width: CGFloat(margin + 29) * 6 -
                margin + 21 * 2, height: CGFloat(90))
            scroll!.bounces = false
            scroll!.showsHorizontalScrollIndicator = false

            let cha = scroll!.frame.width - scroll!.contentSize.width
            var x: CGFloat = 21 - margin
            if cha > 0 {
                x += cha / 2
            }

            let imgArr_1 = ["button_brush_s", "button_brush_m",
                "button_brush_l", "button_brush_s_sel",
                "button_brush_m_sel", "button_brush_l_sel"]
            let nameArr_1 = [" ", NSLocalizedString("Pen size", comment: ""), " "]
            for var i: Int = 0; i < imgArr_1.count / 2; ++i {
                //按钮间距
                x += margin

                let btn: UIButton = UIButton(frame: CGRect(x: x, y: 22, width: 29, height: 29))
                btnArr1.append(btn)
                btn.tag = i
                btn.setImage(UIImage(named: imgArr_1[i]), forState: UIControlState.Normal)
                btn.setImage(UIImage(named: imgArr_1[i + 3]), forState: UIControlState.Selected)
                btn.contentMode = UIViewContentMode.ScaleAspectFill
                btn.addTarget(self, action: "selectSize:",
                    forControlEvents: UIControlEvents.TouchUpInside)
                scroll!.addSubview(btn)

                let txt: UILabel = UILabel()
                txt.text = nameArr_1[i]
                txt.font = UIFont.systemFontOfSize(11)
                txt.textColor = UIColor(white: 122 / 255.0, alpha: 1)
                txt.sizeToFit()
                txt.center = CGPoint(x: CGRectGetMidX(btn.frame), y: 72)
                scroll!.addSubview(txt)

                //按钮宽度
                x += 29
            }

            let imgArr_2 = ["button_eraser", "button_brush"]
            let nameArr_2 = [NSLocalizedString("Erase", comment: ""),
                NSLocalizedString("Paint", comment: "")]
            for var i: Int = 0; i < imgArr_2.count; ++i {
                //按钮间距
                x += margin

                let btn: EFRoundButton = EFRoundButton(frame: CGRect(x: x, y: 22,
                    width: 29, height: 29))
                btnArr2.append(btn)
                btn.tag = i
                btn.setImage(UIImage(named: imgArr_2[i]), forState: UIControlState.Normal)
                btn.contentMode = UIViewContentMode.ScaleAspectFill
                btn.addTarget(self, action: "selectTool:",
                    forControlEvents: UIControlEvents.TouchUpInside)
                scroll!.addSubview(btn)

                let txt: UILabel = UILabel()
                txt.text = nameArr_2[i]
                txt.numberOfLines = 3
                txt.font = UIFont.systemFontOfSize(11)
                txt.textColor = UIColor(white: 122 / 255.0, alpha: 1)
                txt.sizeToFit()
                txt.center = CGPoint(x: CGRectGetMidX(btn.frame), y: 72)
                scroll!.addSubview(txt)

                //按钮宽度
                x += 29
            }

            //按钮间距
            x += margin

            let btn: UIButton = UIButton(frame: CGRect(x: x, y: 22, width: 29, height: 29))
            btnArr2.append(btn)
            btn.tag = btnArr2.count
            btn.setImage(UIImage(named: "button_back"), forState: UIControlState.Normal)
            btn.setImage(UIImage(named: "button_back_sel"), forState: UIControlState.Selected)
            btn.contentMode = UIViewContentMode.ScaleAspectFill
            btn.addTarget(self, action: "selectTool:",
                forControlEvents: UIControlEvents.TouchUpInside)
            scroll!.addSubview(btn)

            let txt: UILabel = UILabel()
            txt.text = NSLocalizedString("Cancel", comment: "")
            txt.font = UIFont.systemFontOfSize(11)
            txt.textColor = UIColor(white: 122 / 255.0, alpha: 1)
            txt.sizeToFit()
            txt.center = CGPoint(x: CGRectGetMidX(btn.frame), y: 72)
            scroll!.addSubview(txt)

            //初始化控件状态
            btnArr1[1].selected = true
            btnArr2[1].selected = true
        }
    }

    func selectSize(sender: AnyObject) {
        if let btn = sender as? UIButton {
            for ele in btnArr1 {
                if btn.tag == ele.tag {
                    ele.selected = true
                    controller?.frontView.setTouchWidthValue([14, 25, 38][btn.tag])
                } else {
                    ele.selected = false
                }
            }
        }
    }

    func selectTool(sender: AnyObject) {
        if let btn = sender as? UIButton {
            if btnArr2.count == btn.tag {
                if btn.selected {
                    btn.selected = false
                    controller?.frontView.clearLastOne()
                }
            } else {
                for ele in btnArr2 {
                    if btn.tag == ele.tag {
                        ele.selected = true
                        controller?.frontView.setTouchState(ele.tag == 0 ? true : false)
                    } else {
                        ele.selected = false
                    }
                }
            }
        }
    }
}
