//
//  EFMultiSpaceBar.swift
//  mugshot
//
//  Created by dexter on 15/4/27.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

import UIKit
import SnapKit

class EFMultiSpaceBar: UIView {

    let sec1: Int = 35
    let sec2: Int = 80

    @IBInspectable var multi: Int = 5
    @IBInspectable var frontColor: UIColor {
        get {
            return frontView.backgroundColor!
        }
        set {
            frontView.backgroundColor=newValue
        }
    }
    @IBInspectable var duration100: Double = 1.0

    private weak var frontView: UIView!

    required
    init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        backgroundColor=UIColor(white: 211/255.0, alpha: 1)

        let view=UIView()
        view.backgroundColor=UIColor.blackColor()
        self.addSubview(view)

        view.snp_makeConstraints { make in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0)
        }
        frontView=view
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        cutWithPoints(self, number: multi)
    }

    //剪切
    private func cutWithPoints(view: UIView, number: Int) {
        //切块
        if 1 < number {
            //间距
            let margin: CGFloat = 1.0
            //拆分
            let step = view.frame.width / CGFloat(number)
            let height = view.frame.height
            //遮罩
            let maskLayer = CAShapeLayer()
            let path = CGPathCreateMutable()
            for i in 0..<number {
                CGPathAddRect(path, nil, CGRect(x: step * CGFloat(i), y: 0,
                    width: step - ((i + 1) == number ? 0.0 : margin), height: height))
            }
            maskLayer.path = path
            view.layer.mask = maskLayer
        }

        //圆角矩形
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 1.0
    }

    //只能放在didApear里
    func countToValue(value: Int, clr: [UIColor]? = nil) {
        if clr != nil {
            frontView.backgroundColor=clr![0]
        }
        if value==0 {return}
        let per=Double(value)/100.0
        let durad=duration100/100.0
        let dura=durad*Double(value)
        layoutIfNeeded()
        UIView.animateWithDuration(dura, delay: 0,
            options: .CurveLinear, animations: {
                [weak self] in
                self?.frontView.snp_remakeConstraints(
                    "Unknown", line: 0, closure: { make in
                        make.left.top.bottom.equalTo(self!)
                        make.width.equalTo(self!).multipliedBy(per)
                })
                self?.layoutIfNeeded()
            }, completion: nil)

        if clr == nil || value < sec1 {
            return
        }
        let dura2 = durad * Double(sec1)
        let dura3 = durad * Double(sec2)
        UIView.animateKeyframesWithDuration(dura, delay: 0,
            options: .CalculationModeDiscrete, animations: {
                [weak self] in
                UIView.addKeyframeWithRelativeStartTime(dura2/dura,
                    relativeDuration: 0, animations: {
                    self?.frontView.backgroundColor=clr![1]
                })

                if value >= self?.sec2 {
                    UIView.addKeyframeWithRelativeStartTime(dura3/dura,
                        relativeDuration: 0, animations: {
                        self?.frontView.backgroundColor=clr![2]
                    })
                }
            }, completion: nil)
    }
}
