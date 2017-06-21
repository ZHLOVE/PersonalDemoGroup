//
//  MSBeautifyViewController.swift
//  mugshot
//
//  Created by Venpoo on 15/8/28.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class MSBeautifyViewController: EFViewController {
    @IBOutlet weak var bottomView: UIImageView!
    @IBOutlet weak var surfaceView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var showMinValue: UILabel!
    @IBOutlet weak var showMaxValue: UILabel!
    var beautifulBtns: [EFRoundButton]!
    @IBOutlet weak var leftEyeBtn: EFRoundButton!
    @IBOutlet weak var rightEyeBtn: EFRoundButton!
    @IBOutlet weak var mouthBtn: EFRoundButton!
    @IBOutlet weak var smoothBtn: EFRoundButton!
    @IBOutlet weak var lightBtn: EFRoundButton!

    private var model: MUGFixVM!

    private var originImg: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        //创建model
        model = MUGFixVM(cont: MSAfx.contextImage, prev: MSAfx.modelImage, controller: self)

        beautifulBtns = [leftEyeBtn, rightEyeBtn, mouthBtn,
            smoothBtn, lightBtn]
        for var i = 0; i < beautifulBtns.count; ++i {
            beautifulBtns[i].tag = i
            beautifulBtns[i].addTarget(self, action: "btnClicked:",
                forControlEvents: UIControlEvents.TouchUpInside)
        }
        //初始化图片
        surfaceView.image = MSAfx.modelImage.lastMixImgWithColor(MSAfx.modelImage.backColors)
        bottomView.image = UIColor.whiteColor().createImageWithRect(surfaceView.image!.size)
        //原始对比图
        originImg = surfaceView.image

        //初始化按钮
        selectTool(0)
    }

    private var firstAppear = true
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if firstAppear {
            firstAppear = false

            //右上角 对比 按钮
            let tarSize = CGSize.autoSize(surfaceView.frame.size,
                targetSize: surfaceView.image!.size)
            let compareBtn: UIButton = UIButton(frame:
                CGRect(
                    x: surfaceView.frame.width - 11 - 48 -
                        (surfaceView.frame.width - tarSize.width) / 2,
                    y: 10,
                    width: 50,
                    height: 21)
            )
            compareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            compareBtn.setImage(UIImage(named: "button_contrast"), forState: UIControlState.Normal)
            compareBtn.titleLabel?.font = UIFont.systemFontOfSize(11)
            surfaceView.userInteractionEnabled = true
            surfaceView.addSubview(compareBtn)
            compareBtn.addTarget(self, action: "comBtnTouchDown",
                forControlEvents: UIControlEvents.TouchDown)
            compareBtn.addTarget(self, action: "comBtnTouchUp",
                forControlEvents: UIControlEvents.TouchUpInside)
            compareBtn.addTarget(self, action: "comBtnTouchUp",
                forControlEvents: UIControlEvents.TouchUpOutside)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
        if segue.identifier == "Beautify2Preview" {
            //获取最新扩展图
            MSAfx.imageExt = model.previewVM.lastImgFix
            //完成美化
            //点击完成后就复制最终图给预览Model
            MSAfx.modelImage?.lastImgFix = model.previewVM.lastImgFix
            //并且设置新参数
            MSAfx.contextImage?.mergeParam(model.nowDict)
            //下次不用初始化参数了
            MSAfx.contextImage?.setInt(1, forKey: "initfix")
        }
    }

    //不知道这个bool是干嘛的，感觉完全没存在的意义
    private var toolFirst = true
    func selectTool(index: Int) {
        for ele in beautifulBtns {
            if index == ele.tag {
                ele.selected = true
                selectToolIndex = index
                model.selectItem(selectToolIndex, first: toolFirst)
            } else {
                ele.selected = false
            }
        }
        if toolFirst {
            toolFirst = false
        }
    }

    var selectToolIndex: Int = 0
    func btnClicked(sender: AnyObject) {
        if let index = (sender as? UIButton)?.tag {
            selectTool(index)
        }
    }

    func comBtnTouchDown() {
        surfaceView.image = originImg
    }

    func comBtnTouchUp() {
        surfaceView.image = model.previewVM.lastMixImgWithColor(
            MSAfx.modelImage.backColors,
            areaIn: CGRect(origin: CGPoint(x: 0, y: 0), size: (model.previewVM.lastImgFix.size))
        )
    }

    @IBAction func sliderTouchEnd(sender: AnyObject) {
        model.changeValue(Int(valueSlider.value))
    }
}
