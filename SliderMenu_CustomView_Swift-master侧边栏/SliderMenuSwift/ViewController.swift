//
//  ViewController.swift
//  SliderMenuSwift
//
//  Created by MAC on 12/17/15.
//  Copyright © 2015 VVLab. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NVSliderMenuDelegate {
    var mySliderMenu:NVSliderMenu! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        mySliderMenu = NVSliderMenu.init(viewController: self);
        self.view.addSubview(mySliderMenu)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func btnClick(sender: UIButton){
        if (mySliderMenu.isShow){
            mySliderMenu.hideSliderMenu()
        } else {
            mySliderMenu.showSliderMenu()
        }
    }
    func callback() {
        print("callback function called")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

