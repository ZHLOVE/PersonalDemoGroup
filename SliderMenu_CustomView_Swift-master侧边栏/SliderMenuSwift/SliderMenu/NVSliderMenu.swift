//
//  File.swift
//  SliderMenuSwift
//
//  Created by MAC on 12/17/15.
//  Copyright © 2015 VVLab. All rights reserved.
//

import UIKit
import Foundation

protocol NVSliderMenuDelegate{
    func callback()
}
class NVSliderMenu: UIView , UIGestureRecognizerDelegate {
    
    var kSLIDE_TIMING = 0.2
    var kMARGIN_LEFT:CGFloat = 100.0
    var kTOUCH_AREA:CGFloat = 30
    var kSHADOW_OFFSET:CGFloat = 2
    
    var delegate:NVSliderMenuDelegate! = nil
    
    var availableTouchPoint = false
    var isShow = false
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init( viewController: UIViewController) {
        let sliderRect = CGRectMake(kMARGIN_LEFT - viewController.view.frame.size.width, 0, viewController.view.frame.size.width - kMARGIN_LEFT, viewController.view.frame.size.height)
        super.init(frame:sliderRect)
        self.delegate = viewController as! NVSliderMenuDelegate
        self.load()
    }
    func load() {
        let view = NSBundle.mainBundle().loadNibNamed("NVSliderMenu", owner: nil, options: nil)[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
    }
    @IBAction func btnClick(sender: AnyObject) {
        delegate.callback()
    }
    //
    // overide
    //
    override func didMoveToWindow() {
        self.setupGestures();
    }
    //
    // Design.
    //
    func setViewShadow(isShow: Bool) {
        if (isShow) {
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowOpacity = 0.8
            self.layer.shadowOffset = CGSizeMake(kSHADOW_OFFSET,kSHADOW_OFFSET)
        } else {
            self.layer.shadowOffset = CGSizeMake(0,0)
        }
    }
    //
    // Show, Hide slider.
    //
    func showSliderMenu(){
        
        UIView.animateWithDuration(kSLIDE_TIMING, animations: {
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            }, completion:{(finished: Bool) -> Void in
                self.isShow = true;
                self.setViewShadow(true)
        })
    }
    func hideSliderMenu() {
        
        UIView.animateWithDuration(kSLIDE_TIMING, animations: {
            self.frame = CGRectMake( -self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.isShow = false;
                self.setViewShadow(false)
        })
    }
    //
    // Handle touch event
    //
    func setupGestures() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action:"movePanel:")
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.delegate = self
        self.superview!.addGestureRecognizer(panRecognizer);
    }
    func movePanel(sender:UIPanGestureRecognizer) {
        sender.view?.layer.removeAllAnimations()
        if(sender.state == UIGestureRecognizerState.Began){
            availableTouchPoint = fabs(sender.locationInView(self).x - self.frame.size.width) < kTOUCH_AREA
        }
        if(sender.state == UIGestureRecognizerState.Changed){
            if(availableTouchPoint){
                let touchPoint = sender.locationInView(self.superview)
                var xCenter = touchPoint.x - self.frame.size.width/2
                xCenter = xCenter > self.frame.size.width/2 ? self.frame.size.width/2: xCenter;
                self.center = CGPointMake(xCenter, self.center.y)
            }
        }
        if (sender.state == UIGestureRecognizerState.Ended){
            let velocity = sender.velocityInView(self.superview)
            if (self.center.x + velocity.x > 0) {
                self.showSliderMenu();
            } else {
                self.hideSliderMenu();
            }
            
        }
    }
    
}