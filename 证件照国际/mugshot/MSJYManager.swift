//
//  MSJYManager.swift
//  mugshot
//
//  Created by Venpoo on 15/9/6.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class MSJYManager: MSJYManager_OC {
    //预处理
    func pretreat(imageIn: UIImage, spec: CateInfoSpecModel) -> Int {
        super.sheZhiCanShuWidth(
            NSNumber(integer: spec.widthPx!),
            height: NSNumber(integer: spec.heightPx!),
            RX1: NSNumber(double: spec.ratios[3]),
            RX2: NSNumber(double: spec.ratios[1]),
            RY1: NSNumber(double: spec.ratios[0]),
            RY2: NSNumber(double: spec.ratios[2]),
            new1: NSNumber(double: spec.ratios[4]),
            new2: NSNumber(double: spec.ratios[5]),
            new3: NSNumber(double: spec.ratios[6]),
            new4: NSNumber(double: spec.ratios[7]),
            new5: NSNumber(double: spec.ratios[8]),
            new6: NSNumber(double: spec.ratios[9])
        )

        MSAfx.contextImage = super.renLianShu(imageIn)
        let faceCount = MSAfx.contextImage.intForKey("count")
        if 1 == faceCount {
            super.jiSuanKuang()
            MSAfx.modelImage = MUGImageVM(cont: MSAfx.contextImage)
            MSAfx.imageExt = MSAfx.modelImage.lastMixImg()
            super.sheZhiTuPian(MSAfx.imageExt)
            super.daFeng()
        }
        return Int(faceCount)
    }
}
