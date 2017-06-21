//
//  EFRoundButton.swift
//  mugshot
//
//  Created by dexter on 15/4/29.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

import UIKit

class EFRoundButton: UIButton {
    //图片文字中间空行
    private static let midSpace: CGFloat = 2.0

    private static let grayClr = UIColor(white: 224/255.0, alpha: 1)
    private static let blueClr = MSColor.mainLightBlue
    @IBInspectable var colorImage: [UIColor]! {
        didSet {
            if colorImage != nil {
                setImage(
                    createGradientImage(
                        colorImage[0], endColor: colorImage[1],
                        size: CGSize(width: bounds.width * 2,
                            height: bounds.height * 2) ).circleImage(3),
                    forState: .Normal
                )
            }
        }
    }

    @IBInspectable var contentInset: CGFloat = -1.0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var fontSize: CGFloat = 18 {
        didSet {
            titleLabel?.font=UIFont.systemFontOfSize(fontSize)
        }
    }

    override
    var selected: Bool {
        didSet {
            //切换边缘颜色
            layer.borderColor = selected ? EFRoundButton.blueClr.CGColor
                : EFRoundButton.grayClr.CGColor
        }
    }

    private var firstFrame = true
    private var lastSize=CGSizeZero
    private func sizeChange(size: CGSize) {
        if lastSize != size || firstFrame {
            firstFrame=false
            //半圆角
            layer.cornerRadius=frame.height/2.0
            lastSize=size
            //更新颜色
            let bak=colorImage
            colorImage=bak
        }
    }

    override var frame: CGRect {
        didSet {
            sizeChange(frame.size)
        }
    }
    override var bounds: CGRect {
        didSet {
            sizeChange(bounds.size)
        }
    }

    override func contentRectForBounds(bounds: CGRect) -> CGRect {
        //有值就使用缩减范围
        if contentInset >= 0 {
            return bounds.insetBy(dx: contentInset, dy: contentInset)
        }
        return super.contentRectForBounds(bounds)
    }

    private func trueContentRect(contentRect: CGRect) -> CGRect {
        if contentInset >= 0 {
            return contentRect
        }

        //没值自己计算
        let imgsz=imgSize()
        let txtsz=txtSize()
        return sizeCenterInRect(CGSize(width: max(imgsz.width, txtsz.width),
            height: imgsz.height + EFRoundButton.midSpace + txtsz.height),
            src: contentRect).intersect(contentRect)
    }

    private func _imageRectForContentRect(contentRect: CGRect) -> CGRect {
        if currentTitle == nil {
            //没标题、有缩进返回所有空间
            if contentInset >= 0 {
                return contentRect
            }
            //返回图片居中大小
            return sizeCenterInRect(imgSize(), src: contentRect).intersect(contentRect)
        }

        //有标题减去标题高度
        let txtsz=txtSize()
        var ret=trueContentRect(contentRect)
        ret.size.height -= txtsz.height + EFRoundButton.midSpace
        if ret.size.height<0 {
            ret.size.height=0
        }
        return ret
    }

    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        let ret=_imageRectForContentRect(contentRect)
        let scale=currentImage!.size.width/currentImage!.size.height
        var sz=CGSizeZero
        if scale > ret.width/ret.height {
            sz.width = ret.width
            sz.height = ret.width/scale
        } else {
            sz.width = ret.height*scale
            sz.height = ret.height
        }
        return sizeCenterInRect(sz, src: ret)
    }

    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        if currentTitle == nil {
            return super.titleRectForContentRect(contentRect)
        }
        let txtsz=txtSize()
        var ret=trueContentRect(contentRect)
        ret.origin.y=ret.maxY-txtsz.height
        ret.size.height=txtsz.height
        return sizeCenterInRect(txtsz, src: ret).intersect(contentRect)
    }

    private func imgSize() -> CGSize {
        return currentImage!.size
    }
    private func txtSize() -> CGSize {
        return (currentTitle! as NSString).sizeWithAttributes(
            [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)])
    }
    private func sizeCenterInRect(fsz: CGSize, src: CGRect) -> CGRect {
        return CGRect(x: src.midX-fsz.width/2.0, y: src.midY-fsz.height/2.0,
            width: fsz.width, height: fsz.height)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layer.borderWidth=1
        layer.borderColor=EFRoundButton.grayClr.CGColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth=1
        layer.borderColor=EFRoundButton.grayClr.CGColor
    }
}
