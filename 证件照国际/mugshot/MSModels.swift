//
//  Models.swift
//  mugshot
//
//  Created by Venpoo on 15/8/18.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit


// 分类

class CategoryModel {
    var iconUrl: NSURL?
    var categoryID: Int!
    var name: String!

    init?(data: AnyObject) {
        if let dict = data as? [String : AnyObject] {
            if let urlString = dict["icon_url"] as? String {
                self.iconUrl = NSURL(string: urlString)
            }
            if let id = dict["id"] as? Int {
                self.categoryID = id
            }
            if let name = dict["name"] as? String {
                self.name = name
            }
        }
        if nil == iconUrl || nil == categoryID || nil == name {
            return nil
        }
    }
}


// 背景板

class BackdropModel {
    var beginColor: UIColor!
    var endColor: UIColor!
    var backdropID: Int!
    var name: String!

    init?(data: AnyObject) {
        if let dict = data as? [String : AnyObject] {
            if let color = dict["begin_color"] as? UInt {
                self.beginColor = UIColor(rgbValue: color)
            }
            if let color = dict["end_color"] as? UInt {
                self.endColor = UIColor(rgbValue: color)
            }
            if let id = dict["id"] as? Int {
                self.backdropID = id
            }
            if let name = dict["name"] as? String {
                self.name = name
            }
        }
        if nil == beginColor || nil == endColor || nil == backdropID || nil == name {
            return nil
        }
    }
}


// 槽信息

class CateInfoSpecSlotModel {
    var rotationCcw: Int!
    var originX: Int!
    var originY: Int!

    init?(data: AnyObject) {
        if let dict = data as? [String : AnyObject] {
            if let rotation = dict["rotation_ccw"] as? Int {
                self.rotationCcw = rotation
            }
            if let x = dict["x"] as? Int {
                self.originX = x
            }
            if let y = dict["y"] as? Int {
                self.originY = y
            }
        }
        if nil == rotationCcw || nil == originX || nil == originY {
            return nil
        }
    }
}


// 相纸信息

class CateInfoSpecPaperModel {
    var heightMm: Int!
    var heightPx: Int!
    var widthMm: Int!
    var widthPx: Int!
    var slots: [CateInfoSpecSlotModel]!

    init?(data: AnyObject) {
        if let dict = data as? [String : AnyObject] {
            if let height_mm = dict["height_mm"] as? Int {
                self.heightMm = height_mm
            }
            if let height_px = dict["height_px"] as? Int {
                self.heightPx = height_px
            }
            if let width_mm = dict["width_mm"] as? Int {
                self.widthMm = width_mm
            }
            if let width_px = dict["width_px"] as? Int {
                self.widthPx = width_px
            }
            if let raw_slots = dict["slots"] as? [AnyObject] {
                var slots = [CateInfoSpecSlotModel]()
                for raw_slot in raw_slots {
                    if let slot = CateInfoSpecSlotModel(data: raw_slot) {
                        slots.append(slot)
                    }
                }
                self.slots = slots
            }
        }
        if heightMm == nil ||
            heightPx == nil ||
            widthMm == nil ||
            widthPx == nil ||
            slots == nil {
                return nil
        }
    }
}


// 规格说明

class CateInfoSpecModel {
    var specId: Int!
    var name: String!
    var backdropIds: [Int]!
    var widthMm: Int!
    var widthPx: Int!
    var heightMm: Int!
    var heightPx: Int!
    var paper: CateInfoSpecPaperModel!
    var ratios: [Double]!
    var sizeRequirement: String!        //尺寸
    var maxBytes: Int?                  //大小:最大值
    var minBytes: Int?                  //大小:最小值
    var otherRequirement: String?       //其他


    //添加身份证
    var textRequired: Bool?            //是否需要填写文本信息
    var textAreaPx: Int?               //图片下增加的额外高度，用来显示文字，单位像素
    var fontSizePt: Int?               //文字字号，单位 Point
    var textMaxL: Int?                 //文字最大长度，单位字符

    init?(data: AnyObject) {
        if let dict = data as? [String : AnyObject] {
            if let spec_id = dict["id"] as? Int {
                self.specId = spec_id
            }
            if let name = dict["name"] as? String {
                self.name = name
            }
            if let width_mm = dict["width_mm"] as? Int {
                self.widthMm = width_mm
            }
            if let width_px = dict["width_px"] as? Int {
                self.widthPx = width_px
            }
            if let height_mm = dict["height_mm"] as? Int {
                self.heightMm = height_mm
            }
            if let height_px = dict["height_px"] as? Int {
                self.heightPx = height_px
            }
            if let size_requirement = dict["size_requirement"] as? String {
                self.sizeRequirement = size_requirement
            }
            if let raw_paper = dict["paper"], let paper = CateInfoSpecPaperModel(data: raw_paper) {
                self.paper = paper
            }
            if let ratios = dict["ratios"] as? [Double] {
                self.ratios = ratios
            }
            if let backdrop_ids = dict["backdrop_ids"] as? [Int] {
                self.backdropIds = backdrop_ids
            }
            maxBytes = dict["max_bytes"] as? Int
            minBytes = dict["min_bytes"] as? Int
            otherRequirement = dict["other_requirement"] as? String
        }
        if specId == nil ||
            backdropIds == nil ||
            widthMm == nil ||
            widthPx == nil ||
            heightMm == nil ||
            heightPx == nil ||
            name == nil ||
            paper == nil ||
            ratios == nil ||
            sizeRequirement == nil {
                return nil
        }
    }

    //尺寸
    func getSizeInfo() -> String {
        return self.sizeRequirement.isEmpty ? "-" : self.sizeRequirement
    }

    //像素
    func getPxInfo() -> String {
        return "\(self.widthPx)×\(self.heightPx)px"
    }

    //大小
    func getByteInfo() -> String {
        var requirement = [String]()
        if let min_bytes = self.minBytes {
            requirement.append("≥\(min_bytes / 1024)KB")
        }

        if let max_bytes = self.maxBytes {
            requirement.append("≤\(max_bytes / 1024)KB")
        }

        return requirement.isEmpty ? "-" : requirement.joinWithSeparator(" ")
    }

    //颜色
    func getColorInfo(backdrops: [BackdropModel]) -> String {
        let models = backdrops.filter() {
            return self.backdropIds.contains($0.backdropID!)
        }
        let names = models.flatMap() {
            return $0.name!
        }
        let separator = NSLocalizedString("seperate", comment: "")
        return names.joinWithSeparator(separator)
    }

    //其他
    func getOtherInfo() -> String {
        if let requirement = otherRequirement where !requirement.isEmpty {
            return requirement
        }
        return "-"
    }
}

// 价目表

class StorageServiceModel {
    var price: Int!            // 单价，单位为分
    var shareDiscount: Int!  // 分享优惠价格，单位为分

    init?(data: AnyObject) {
        guard let dict = data as? [String : AnyObject] else {
            return nil
        }
        if let price = dict["price"] as? Int,
           let shareDiscount = dict["share_discount"] as? Int {
            self.price = price
            self.shareDiscount = shareDiscount
        } else {
            return nil
        }
    }
}


// 分类与规格

class CateInfoModel {
    var categoryId: Int!
    var specs: [CateInfoSpecModel]!

    init?(data: AnyObject) {
        if let dict = data as? [String : AnyObject] {
            if let category_id = dict["category_id"] as? Int {
                self.categoryId = category_id
            }
            if let raw_specs = dict["specs"] as? [AnyObject] {
                var specs = [CateInfoSpecModel]()
                for raw_spec in raw_specs {
                    if let spec = CateInfoSpecModel(data: raw_spec) {
                        specs.append(spec)
                    }
                }
                self.specs = specs
            }
        }
        if nil == categoryId || nil == specs {
            return nil
        }
    }
}
