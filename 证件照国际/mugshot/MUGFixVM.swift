//
//  MUGFixVM.swift
//  mugshot
//
//  Created by dexter on 15/5/4.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

import UIKit

class MUGFixVM: NSObject {

    private weak var lastCont: CAMPicContext!
    var previewVM: MUGImageVM!

    //最大值最小值
    private static let itemArr = [
        ("Left Eye", -100, 100),
        ("Right Eye", -100, 100),
        ("Mouth", -100, 100),
        ("Smooth", 0, 100),
        ("Whitening", 0, 10)
    ]
    private static let initDict: [NSString:NSNumber] = [
        "Left Eye":40,
        "Right Eye":60,
        "Mouth":-20,
        "Smooth":25,
        "Whitening":2
    ]

    //当前值
    dynamic var curItem: String = ""
    dynamic var curMix: Int = 0
    dynamic var curMax: Int = 100
    dynamic var curValue: Int = 0
    private var bakDict: [NSString:NSNumber] = [:]
    var nowDict: [NSString:NSNumber]!

    //给外面调入的数据
    dynamic var inValue: Int = 0

    init(cont: CAMPicContext, prev: MUGImageVM,
        controller: MSBeautifyViewController) {
        super.init()

        self.controller = controller
        lastCont = cont
        previewVM = MUGImageVM(from: prev)
        //开启美颜模式
        lastCont.mode = CAMPicMode(rawValue: lastCont.mode.rawValue | CAMPicMode.Meiyan.rawValue)
        //备份原值
        for (key, _, _) in MUGFixVM.itemArr {
            bakDict[key] = NSNumber(int: lastCont.intForKey(key))
        }
        if lastCont.intForKey("initfix") == 0 {
            nowDict = MUGFixVM.initDict
        } else {
            //应该是复制
            nowDict = bakDict
        }
    }

    weak var controller: MSBeautifyViewController?

    //选择项目即是预处理
    func selectItem(index: Int, first: Bool = false) {
        //如果已经选择 则啥都不做
        if self.curItem == MUGFixVM.itemArr[index].0 {
            MSAfx.loadingView.Hide(nil)
        } else {
            //当前值
            self.curItem = MUGFixVM.itemArr[index].0
            self.curMix = MUGFixVM.itemArr[index].1
            self.curMax = MUGFixVM.itemArr[index].2
            self.curValue = Int(self.nowDict[MUGFixVM.itemArr[index].0]!)

            if let cont = self.lastCont {
                MSAfx.loadingView.Show(controller!, withString: "Preprocessing")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    [weak self] in
                    cont.mergeParam(self!.bakDict)

                    if first {
                        //初始化强制美化
                        let JYManager = MSJYManager.sharedInstance() as? MSJYManager
                        self?.previewVM.lastImgFix = JYManager!.meiYan(
                            Double(self!.nowDict[MUGFixVM.itemArr[0].0]!),
                            Double(self!.nowDict[MUGFixVM.itemArr[1].0]!),
                            Double(self!.nowDict[MUGFixVM.itemArr[2].0]!),
                            Double(self!.nowDict[MUGFixVM.itemArr[4].0]!),
                            Double(self!.nowDict[MUGFixVM.itemArr[3].0]!),
                            Double(1)
                        )
                    }

                    dispatch_async(dispatch_get_main_queue(), {
                        //这里返回主线程，写需要主线程执行的代码
                        if nil != self?.controller {
                            self?.controller?.valueSlider.minimumValue = Float(self!.curMix)
                            self?.controller?.valueSlider.maximumValue = Float(self!.curMax)
                            self?.controller?.valueSlider.value = Float(self!.curValue)
                            self?.controller?.showMinValue.text = "\(self!.curMix)"
                            self?.controller?.showMaxValue.text = "\(100)"//"\(self!.curMax)"

                            if first {
                                //初始化强制美化
                                self?.controller?.surfaceView.image = self?.previewVM
                                    .lastMixImgWithColor(
                                    MSAfx.modelImage.backColors,
                                    areaIn: CGRect(origin: CGPoint(x: 0, y: 0),
                                        size: (self?.previewVM.lastImgFix.size)!)
                                )
                            }
                            MSAfx.loadingView.Hide(nil)
                        }
                    })
                    })
            }
        }
    }

    func changeValue(inValue: Int, must: Bool = false) {
        if (self.nowDict[self.curItem] != inValue) || must {
            //变动值
            self.nowDict[self.curItem] = inValue

            if let cont = self.lastCont {
                MSAfx.loadingView.Show(controller!, withString: "Beautifying")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    [weak self] in
                    let JYManager = MSJYManager.sharedInstance() as? MSJYManager
                    self?.previewVM.lastImgFix = JYManager!.meiYan(
                        Double(self!.nowDict[MUGFixVM.itemArr[0].0]!),
                        Double(self!.nowDict[MUGFixVM.itemArr[1].0]!),
                        Double(self!.nowDict[MUGFixVM.itemArr[2].0]!),
                        Double(self!.nowDict[MUGFixVM.itemArr[4].0]!),
                        Double(self!.nowDict[MUGFixVM.itemArr[3].0]!),
                        Double(1)
                    )

                    dispatch_async(dispatch_get_main_queue(), {
                        //这里返回主线程，写需要主线程执行的代码
                        if nil != self?.controller {
                            cont.mergeParam(self!.bakDict)
                            self?.controller?.surfaceView.image = self?.previewVM
                                .lastMixImgWithColor(
                                MSAfx.modelImage.backColors,
                                areaIn: CGRect(origin: CGPoint(x: 0, y: 0),
                                    size: (self?.previewVM.lastImgFix.size)!)
                            )
                            MSAfx.loadingView.Hide(nil)
                        }
                    })
                    })
            }
        }
    }
}
