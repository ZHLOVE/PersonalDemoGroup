//
//  EFThinLine.swift
//  mugshot
//
//  Created by Venpoo on 15/8/14.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class EFThinLine: UIView {
    var color: UIColor?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        if self.backgroundColor == nil {
            self.backgroundColor = UIColor.clearColor()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.backgroundColor == nil {
            self.backgroundColor = UIColor.clearColor()
        }
    }

    override func drawRect(rect: CGRect) {
        var flip: Bool = false
        if self.frame.origin.x == self.superview!.bounds.size.width - 1
            || self.frame.origin.y == self.superview!.bounds.size.height - 1 {
                flip = true
        }

        let g: CGContext = UIGraphicsGetCurrentContext()!
        if flip {
            //CGContextSaveGState(g)
            CGContextRotateCTM(g, CGFloat(M_PI))
            CGContextTranslateCTM(g, -self.bounds.size.width, -self.bounds.size.height)
        }

        var color: UIColor? = self.color
        if nil == color {
            color = UIColor(white: 211 / 255.0, alpha: 1)
        }
        color?.setStroke()

        let rc: CGRect = self.bounds
        let path: UIBezierPath = UIBezierPath()
        //path.lineWidth = 0.5
        if rc.size.height == 1 {
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: rc.size.width, y: 0))
        } else {
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: 0, y: rc.size.height))
        }
        path.stroke()

        //if(flip)
        //CGContextRestoreGState(g);
    }
}
