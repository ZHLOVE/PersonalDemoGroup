//
//  MSScoreViewController.swift
//  mugshot
//
//  Created by Venpoo on 15/8/26.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class MSScoreViewController: EFViewController {

    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var frontView: UIImageView!
    @IBOutlet weak var firstPoint: EFMultiSpaceBar!
    @IBOutlet weak var secondPoint: EFMultiSpaceBar!
    @IBOutlet weak var thirdPoint: EFMultiSpaceBar!
    @IBOutlet weak var forthPoint: EFMultiSpaceBar!
    @IBOutlet weak var firstCounting: EFCountingLabel!
    @IBOutlet weak var secondCounting: EFCountingLabel!
    @IBOutlet weak var thirdCounting: EFCountingLabel!
    @IBOutlet weak var forthCounting: EFCountingLabel!
    var pointBars: Array<EFMultiSpaceBar>!
    var countingLabs: Array<EFCountingLabel>!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    private let pointBarColors = [
        MSColor.mainRed,
        MSColor.mainLightBlue,
        MSColor.mainGreen,
    ]

    var photoPoints: [Int]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let navColor: UIColor = MSColor.mainGrey
        let appView = AppDelegate()
        appView.setGlobalStyle(navColor)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: "actionGuide")
        tapLabel.userInteractionEnabled = true
        tapLabel.addGestureRecognizer(tap)
        //初始原图
        frontView.image = MSAfx.contextImage.oriImg
        //拿到5框再建立model
        self.setupModel()
    }

    private func setupModel() {
        if MSAfx.contextImage == nil {
            return
        }

        MSAfx.modelImage = MUGImageVM(cont: MSAfx.contextImage)
        frontView.image = MSAfx.modelImage.lastMixImg()
        backView.image = UIColor.whiteColor().createImageWithRect(frontView.image!.size)

        //获取打分
        photoPoints = MSAfx.contextImage.param["judge"] as? [Int]
        //init
        pointBars = [firstPoint, secondPoint, thirdPoint, forthPoint]
        countingLabs = [firstCounting, secondCounting, thirdCounting, forthCounting]
        //check
        setWarning()
    }

    //根据分数设置下方提示文字
    func setWarning() {
        let minValue = photoPoints.minElement() ?? 100
        if minValue < 35 {
            warningLabel.text = NSLocalizedString(
                "Not bad, but it may be better to try again", comment: "")
            self.navigationItem.rightBarButtonItem = nil
        } else {
            warningLabel.text = NSLocalizedString(
                "Not bad, but it may be better to try again", comment: "")
        }
    }

    private var firstAppear = true
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //条状动画
        if firstAppear {
            firstAppear = false
            //4个动画条
            for i in 0..<pointBars.count {
                pointBars[i].countToValue(photoPoints[i], clr: pointBarColors)
                countingLabs[i].countFrom(CGFloat(0), endValue: CGFloat(photoPoints[i]),
                    duration: Double(photoPoints[i]) / 100.0)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
        if segue.identifier == "Score2ChangeBG" {
            MSAfx.loadingView.Show(self, withString: NSLocalizedString("Processing", comment: ""))
        }
    }

    func actionGuide() {
        //攻略
        let web = EFWebViewController.createWithURL(
            NSLocalizedString("http://www.camcap.us/m/guide_global/", comment: ""),
            title: NSLocalizedString("Raiders", comment: ""))
        self.navigationController?.pushViewController(web, animated: true)
    }
}
