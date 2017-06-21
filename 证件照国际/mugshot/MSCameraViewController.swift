//
//  MSCameraViewController.swift
//  mugshot
//
//  Created by EyreFree on 15/8/25.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit
import AssetsLibrary
import DAAlertController
import JPSVolumeButtonHandler

class MSCameraViewController: MSCameraViewController_OC,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private static let library: ALAssetsLibrary = ALAssetsLibrary()
    private static var volumeButtonHandler: JPSVolumeButtonHandler!
    //是否在快门按下处理中
    private var notSnaping: Bool!
    private var notSnapingAlbumIgnore: Bool! = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        //自拍杆
        notSnaping = false
        MSCameraViewController.volumeButtonHandler = nil
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        MSAfx.clearAfx()
        let navColor: UIColor = UIColor(redColor: 33, greenColor: 150, blueColor: 243, alpha: 1)
        let appView = AppDelegate()
        appView.setGlobalStyle(navColor)

        //自拍杆
        if true == notSnapingAlbumIgnore {
            notSnapingAlbumIgnore = false
        } else {
            notSnaping = true
        }
        MSCameraViewController.volumeButtonHandler = JPSVolumeButtonHandler(upBlock: {
            [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.snapButtonPressed(nil)
            }
            }, downBlock: {
                [weak self] () -> Void in
                if let strongSelf = self {
                    strongSelf.snapButtonPressed(nil)
                }
            })
    }

    //析构函数
    deinit {
        MSAfx.loadingView.Hide(nil)
    }

    override func snapButtonPressed(button: UIButton!) {
        if true == notSnaping {
            notSnaping = false
            super.camera.capture({
                [weak self] (camera: LLSimpleCamera!,
                image: UIImage?,
                metadata: [NSObject : AnyObject]!,
                error: NSError?) -> Void in
                if let strongSelf = self {
                    if nil == error && nil != image {
                        camera?.stop()
                        strongSelf.checkPicture(image!, src: 0)
                    } else {
                        DAAlertController.showAlertViewInViewController(
                            strongSelf,
                            withTitle: NSLocalizedString("Error", comment: ""),
                            message: NSLocalizedString("Failed taking photo", comment: ""),
                            actions: [DAAlertAction(title: NSLocalizedString("OK", comment: ""),
                                style: .Default, handler: {
                                () -> Void in
                                if let strongSelfIn = self {
                                    strongSelfIn.notSnaping = true
                                }
                            })]
                        )
                    }
                }
                }, exactSeenImage: true
            )
        }
    }

    override func albumButtonPressed(button: UIButton!) {
        if true == notSnaping {
            notSnaping = false
            let pickerImage = UIImagePickerController()
            if !UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.PhotoLibrary) {
                pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(
                    pickerImage.sourceType)!
            }
            //状态栏透明去除
            pickerImage.navigationBar.translucent = false
            pickerImage.delegate = self
            pickerImage.allowsEditing = false
            self.presentViewController(pickerImage, animated: true, completion: {
                [weak self] () -> Void in
                if let strongSelf = self {
                    strongSelf.notSnapingAlbumIgnore = true
                }
                })
        }
    }

    override func backButtonPressed(button: UIButton!) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func checkPicture(img: UIImage, src: Int) {
        MSAfx.loadingView.Show(self, withString: NSLocalizedString(
            "Evaluating your shooting environment", comment: ""))
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            [weak self] in
            if let JYManager = MSJYManager.sharedInstance() as? MSJYManager {
                let num = JYManager.pretreat(img, spec: (MSAfx.infoTaoCan.cateInfoSpec)!)

                dispatch_async(dispatch_get_main_queue(), {
                    //这里返回主线程，写需要主线程执行的代码
                    switch num {
                    case 0:
                        MSAfx.loadingView.Hide(NSLocalizedString("No face detected", comment: ""))
                        self?.camera.start()
                        self?.notSnaping = true
                        break
                    case 1:
                        if let Area = MSAfx.contextImage.param["area"] as? NSValue {
                            let area = Area.CGRectValue()
                            if area.size.width > 1800 || area.size.height > 1800 {
                                MSAfx.loadingView.Hide(NSLocalizedString(
                                    "Your face is too close.Please try again.", comment: ""))
                                self?.camera.start()
                                self?.notSnaping = true
                            } else {
                                MSAfx.loadingView.Hide(nil)
                                switch src {
                                case 0:
                                    MSCameraViewController.albumSaveImage(self!, img: img, final: {
                                        (error: NSError?) -> Void in
                                        self?.setFinalImg()
                                        }, fail: {
                                            () -> Void in
                                            self?.setFinalImg()
                                        })
                                    break
                                case 1:
                                    self?.setFinalImg()
                                    break
                                default:
                                    break
                                }
                            }
                            break
                        }
                    default:
                        MSAfx.loadingView.Hide(NSLocalizedString(
                            "Multiple faces detected, only one please.", comment: ""))
                        self?.camera.start()
                        self?.notSnaping = true
                        break
                    }
                })
            }
            })
    }

    //保存图片
    static func albumSaveImage(controller: UIViewController, img: UIImage,
        final: (error: NSError?) -> Void, fail: () -> Void) {
        var name: String?
        #if IS_PRO
            name = "Instant ID Photo Pro"
        #else
            name = "Instant ID Photo"
        #endif
        MSCameraViewController.library.saveImage(img, toAlbum: name,
            withCompletionBlock: {
                [weak controller] (error: NSError?) -> Void in
                if nil != controller {
                    if nil != error {
                        DAAlertController.showAlertViewInViewController(
                            controller,
                            withTitle: NSLocalizedString("Permission required", comment: ""),
                            message: NSLocalizedString(
                                "Saving to album not permitted by system settings.", comment: ""),
                            actions: [DAAlertAction(title: NSLocalizedString("OK", comment: ""),
                                style: .Default,
                                handler: fail)])
                    }
                    final(error: error)
                }
            })
    }

    func setFinalImg() {
        self.performSegueWithIdentifier("Camera2Score", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
        //let dest:UIViewController = segue.destinationViewController
        if segue.identifier == "Camera2Score" {

        }
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let img = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        checkPicture(img, src: 1)
        picker.dismissViewControllerAnimated(false, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(false, completion: nil)
        notSnaping = true
    }
}
