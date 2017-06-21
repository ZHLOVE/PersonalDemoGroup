//
//  MSChangeBGViewController.swift
//  mugshot
//
//  Created by Venpoo on 15/8/27.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit
import DAAlertController

class MSChangeBGViewController: EFViewController {

    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var frontView: EFTrajectoryView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midViewL: UIView!
    @IBOutlet weak var midViewLLabel: UILabel!
    @IBOutlet weak var midViewLHigh: UIView!
    @IBOutlet weak var midViewR: UIView!
    @IBOutlet weak var midViewRLabel: UILabel!
    @IBOutlet weak var midViewRHigh: UIView!
    @IBOutlet weak var bottomView: UIView!
    //底部view里的容器，用于隐藏右侧控件
    @IBOutlet weak var setRongQi: UIView!
    //放大镜
    var scaleView: MSScaleView!
    enum ToolSwitch {
        case 更换背景色
        case 微调背景
    }
    var toolSwitch: ToolSwitch = .更换背景色
    var colorsBar: MSColorSelectView!
    var toolSetBar: MSBrushSetView!

    override func viewDidLoad() {
        var spec_backdrops: [BackdropModel] = [BackdropModel]()
        for var i: Int = 0; i < MSAfx.infoTaoCan.backdrops.count; ++i {
            for var j = 0; j < MSAfx.infoTaoCan.cateInfoSpec.backdropIds.count; ++j {
                if MSAfx.infoTaoCan.backdrops[i].backdropID ==
                    MSAfx.infoTaoCan.cateInfoSpec.backdropIds[j] {
                    spec_backdrops.append(MSAfx.infoTaoCan.backdrops[i])
                }
            }
        }
        colorsBar = MSColorSelectView(
            frame: CGRect(x: 0, y: 0, width: bottomView.frame.width,
                height: bottomView.frame.height),
            colors: spec_backdrops
        )
        colorsBar.controller = self
        toolSetBar = MSBrushSetView(
            frame: CGRect(x: 0, y: 0, width: bottomView.frame.width,
                height: bottomView.frame.height)
        )
        toolSetBar.controller = self
        changeTool(.更换背景色)
        let tapL: UITapGestureRecognizer =
        UITapGestureRecognizer(target: self, action: "changeToolL")
        midViewL.addGestureRecognizer(tapL)
        let tapR: UITapGestureRecognizer =
        UITapGestureRecognizer(target: self, action: "changeToolR")
        midViewR.addGestureRecognizer(tapR)
        //涂抹区
        frontView.setParm(
            MSAfx.imageExt,
            startColor: spec_backdrops[0].beginColor!,
            endColor: spec_backdrops[0].endColor!,
            lineWidth: 1, blurDegree: 0.1,
            state: false, controller: self
        )
        backView.image = UIColor.whiteColor().createImageWithRect(frontView.getOriginImage().size)
        scaleView = MSScaleView(frame: CGRect(x: 4, y: 4, width: 60, height: 60))
        scaleView.setController(self)
        scaleView.hidden = true
    }

    //析构函数
    deinit {
        MSAfx.loadingView.Hide(nil)
    }

    func processPicture() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {

            if let JYManager: MSJYManager = MSJYManager.sharedInstance() as? MSJYManager {
                let maskExt: UIImage = JYManager.shengChengMask()
                //这里是从扩展图的阴影图中抠出原图部分阴影图的区域
                let oriX: CGFloat = MSAfx.modelImage.area.origin.x > 0 ?
                    MSAfx.modelImage.area.origin.x : 0
                let oriY: CGFloat = MSAfx.modelImage.area.origin.y > 0 ?
                    MSAfx.modelImage.area.origin.y : 0
                let offsetX: CGFloat = MSAfx.modelImage.area.origin.x < 0 ?
                    (-MSAfx.modelImage.area.origin.x) : 0
                let offsetY: CGFloat = MSAfx.modelImage.area.origin.y < 0 ?
                    (-MSAfx.modelImage.area.origin.y) : 0
                let getRext: CGRect = CGRect(
                    x: oriX,
                    y: oriY,
                    width: min(MSAfx.contextImage.oriImg.size.width
                        - offsetX, MSAfx.modelImage.area.width - oriX),
                    height: min(MSAfx.contextImage.oriImg.size.height -
                        offsetY, MSAfx.modelImage.area.height - oriY)
                )
                MSAfx.contextImage.param["maskImage"] =
                    maskExt.cropImageWithRect(getRext).resizeWith(
                        maskExt.size,
                        inRect: getRext,
                        withColor: UIColor.whiteColor()
                )
                dispatch_async(dispatch_get_main_queue(), {
                    //这里返回主线程，写需要主线程执行的代码
                    [weak self] in
                    if nil != self {
                        self!.setTouchView()
                        self!.autoMske = true
                    }
                    MSAfx.loadingView.Hide(nil)
                    })
            }
        })
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //预先与初始化maskImage
        if (MSAfx.contextImage.param.objectForKey("maskImage") == nil)
            && (MSAfx.modelImage.maskImage == nil) {
            processPicture()
        } else {
            self.setTouchView()
            self.autoMske = true
            MSAfx.loadingView.Hide(nil)
        }
    }

    private var firstAppear = true
    func setTouchView() {
        if firstAppear {
            firstAppear = false

            //涂抹区
            frontView.previewVM = MSAfx.modelImage
            if MSAfx.contextImage.param.objectForKey("maskImage") != nil {
                frontView.setMaskImage(MSAfx.contextImage.param["maskImage"] as? UIImage)
            } else {
                frontView.setMaskImage(MSAfx.modelImage.maskImage)
            }
            frontView.refresh()
        }
    }

    //更改撤销按钮状态
    var touchMark = false
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchMark {
            touchMark = false
            toolSetBar.btnArr2[2].selected = true
        }
    }

    func changeToolL() {
        changeTool(.更换背景色)
    }

    func changeToolR() {
        if MSAfx.infoTaoCan.backdropNull == true {
            DAAlertController.showAlertViewInViewController(
                self,
                withTitle: "Info",
                message:
                "You chose to preserve the original background, no need to do fine-tuning.",
                actions: [DAAlertAction(title: "OK", style: .Default, handler:nil)
                ]
            )
        } else {
            changeTool(.微调背景)
        }
    }

    func changeTool(newTool: ToolSwitch) {
        toolSwitch = newTool
        if toolSwitch == .更换背景色 {
            midViewLLabel.textColor = MSColor.mainBlue
            midViewLHigh.hidden = false
            midViewRLabel.textColor = MSColor.wordBlack1
            midViewRHigh.hidden = true
            toolSetBar.removeFromSuperview()
            bottomView.addSubview(colorsBar!)
            frontView?.userInteractionEnabled = false
        } else {
            midViewLLabel.textColor = MSColor.wordBlack1
            midViewLHigh.hidden = true
            midViewRLabel.textColor = MSColor.mainBlue
            midViewRHigh.hidden = false
            colorsBar.removeFromSuperview()
            bottomView.addSubview(toolSetBar)
            frontView?.userInteractionEnabled = true
        }
    }

    var autoMske: Bool = false
    @IBAction func nextButtonClick(sender: AnyObject) {
        if autoMske {
            MSAfx.loadingView.Show(self, withString: "Preprocessing")

            //关于:从 storyboard 创建 MUGAddrController
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            if let beauController: MSBeautifyViewController =
                storyboard.instantiateViewControllerWithIdentifier(
                    "MSBeautifyViewController")
                as? MSBeautifyViewController {
                //去掉cont里的值减少空间
                if MSAfx.contextImage.param.objectForKey("maskImage") != nil {
                    MSAfx.modelImage.maskImage = MSAfx.contextImage.param["maskImage"] as? UIImage
                    MSAfx.contextImage.param.removeObjectForKey("maskImage")
                    //重尺寸
                    if let JYManager: MSJYManager = MSJYManager.sharedInstance() as? MSJYManager {
                        JYManager.jiSuanKuangAgain(MSAfx.modelImage.maskImage)
                    }
                }
                frontView.resetChangeCount()
                self.navigationController?.pushViewController(beauController, animated: true)
            }
        }
    }

    //截获nav的默认返回事件我们自己处理
    override func navigationShouldPopOnBackButton() -> Bool {
        let maskExists = MSAfx.contextImage.param.objectForKey("maskImage") != nil
        let maskChanged = frontView.isMaskChanged()
        if maskExists && maskChanged {
            let cancelMessage = NSLocalizedString("Cancel", comment: "")
            let cancel = DAAlertAction(title: cancelMessage, style: .Cancel, handler: nil)

            let okMessage = NSLocalizedString("Don't Save", comment: "")
            let ok = DAAlertAction(title: okMessage, style: .Default) {
                [weak self] in
                MSAfx.contextImage.param.removeObjectForKey("maskImage")
                self?.navigationController!.popViewControllerAnimated(true)
            }

            DAAlertController.showAlertViewInViewController(self,
                withTitle: nil,
                message: NSLocalizedString("Confirm to go back?", comment: ""),
                actions: [ok, cancel])

            return false
        }
        return true
    }
}
