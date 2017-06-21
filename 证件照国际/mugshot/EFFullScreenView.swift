//
//  EFFullScreenView.swift
//  mugshot
//
//  Created by Venpoo on 15/11/26.
//  Copyright © 2015年 junyu. All rights reserved.
//

import UIKit

class EFFullScreenView: UIViewController {

    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clearColor()
    }

    private var firstAppear = true
    override func viewDidAppear(animated: Bool) {
        if nil != image && firstAppear {
            scaleIn()
            firstAppear = false
        }
    }

    func setParm(image: UIImage) {
        self.image = image
    }

    //图片浏览
    func scaleIn() {
        let topView = self.topViewEF()
        let mid: CGPoint = self.view.center
        let preView = UIImageView(frame: CGRect(x: mid.x - 1, y: mid.y - 1, width: 2, height: 2))
        preView.hidden = false
        preView.backgroundColor = UIColor.blackColor()
        preView.contentMode = UIViewContentMode.ScaleAspectFit
        preView.userInteractionEnabled = true
        preView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "scaleOut:"))
        preView.image = image
        topView.addSubview(preView)
        UIView.animateWithDuration(0.3,
            animations: {
                preView.frame = topView.bounds
            },
            completion:nil)
    }

    func scaleOut(sender: UITapGestureRecognizer) {
        if let targetView = sender.view {
            let mid: CGPoint = self.view.center
            UIView.animateWithDuration(0.3,
                animations: {
                    targetView.frame = CGRect(x: mid.x - 1, y: mid.y - 1, width: 2, height: 2)
                },
                completion: { (_:Bool) -> Void in
                    targetView.removeFromSuperview()
                    self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
}
