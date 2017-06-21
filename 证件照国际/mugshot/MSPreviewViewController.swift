//
//  MSPreviewViewController.swift
//  mugshot
//
//  Created by Venpoo on 15/8/28.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit
import DAAlertController
import StoreKit

class MSPreviewViewController: EFViewController,UMSocialUIDelegate, SKProductsRequestDelegate,
SKPaymentTransactionObserver {

    //分享按钮是否置灰
    var isChangeStatus = true
    //获取内购产品列表(其实就那么一个)
    var productDict: NSMutableDictionary!
    private static let library: ALAssetsLibrary = ALAssetsLibrary()

    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var frontView: UIImageView!
    @IBOutlet weak var mixView: UIImageView!

    var boderView: UIImageView!

    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var saveLab: UILabel!

    @IBOutlet weak var redoBtn: UIBarButtonItem!

    // 保存到本地价格
    //private var storageOrderPrice: NSDecimalNumber = NSDecimalNumber(string: "0.99")
    //保存到本地价格
    private var storageOrderPriceDanjia: Double = 1.0
    private var storageOrderPriceDanjiaStr: String = "1"

    //拼合的大图
    var bigMixImg: UIImage!

    private var redoBtnShow: Bool = true

    //是否可分享
    var shareEnable: Bool = true

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        #if IS_PRO
            if let shareBtn = self.view.viewWithTag(10001) as? UIButton {
                self.isChangeStatus = false
                shareBtn.setImage(UIImage(named: "button_printer"),
                    forState: UIControlState.Normal)
            }
        #else
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
            requestProducts()
        #endif

        MSAfx.preViewController = self
        if MSAfx.modelImage != nil {
            redoBtn.title = NSLocalizedString("Retake", comment: "")

            if let values = MSAfx.contextImage.param["final_box_eyrefree"] as? [NSValue] {
                MSAfx.imageMix = MSAfx.getBoxImage(
                    MSAfx.modelImage.lastMixImgWithColor(
                        MSAfx.modelImage.backColors,
                        areaIn: CGRect(origin: CGPoint(x: 0, y: 0),
                            size: MSAfx.modelImage.lastImgFix.size)
                    ),
                    area: (values)[0].CGRectValue()
                )

                MSAfx.imageBack = MSAfx.getBoxImage(
                    MSAfx.imageExt,
                    area: (values)[0].CGRectValue()
                )
                if MSAfx.infoTaoCan.backdropNull == false {
                    MSAfx.imageMask = MSAfx.getBoxImage(
                        MSAfx.modelImage.maskImage,
                        area: (values)[0].CGRectValue()
                    )
                } else {
                    MSAfx.imageMask = UIColor.blackColor().createImageWithRect(MSAfx.imageBack.size)
                }
            }
        } else {
            redoBtnShow = false
            redoBtn.title = ""
        }
        self.bigMixImg = MSAfx.createBigImg(MSAfx.infoTaoCan.cateInfoSpec, smallImg: MSAfx.imageMix)

        //初始化图片
        frontView.image = MSAfx.imageMix

        //添加图片边框
        boderView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        boderView.image = UIImage(named: "border")!
        self.backView.addSubview(boderView)

        mixView.image = bigMixImg

        boderView.hidden = true
        infoLabel.hidden = true
        //单张图
        frontView.hidden = true
        //备切的图，一版8张
        mixView.hidden = true


}


    func createImage() -> UIImage {
        let height = CGFloat(MSAfx.infoTaoCan.cateInfoSpec.textAreaPx!)
        let saveImg = MSAfx.imageMix!.fixOrientationWithSize(
            CGSize(
                width: (MSAfx.infoTaoCan.cateInfoSpec)!.widthPx!,
                height: (MSAfx.infoTaoCan.cateInfoSpec)!.heightPx!
                    + (MSAfx.infoTaoCan.cateInfoSpec)!.textAreaPx!
            )
            )!
        let rect = CGRect(x: 0, y: 0,
                          width: saveImg.size.width, height: saveImg.size.height+height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(
            context, CGRect(origin: CGPoint(x: 0, y: 0), size: rect.size)
        )
        saveImg.drawInRect(CGRect(x: 0, y: 0,
            width: rect.size.width, height: rect.size.height-height))
        let lab = UILabel(frame: CGRect(x: 0, y: rect.size.height-height,
            width: rect.size.width, height: height))
        lab.text = MSAfx.cardNum
        lab.font = UIFont.systemFontOfSize(CGFloat(
            MSAfx.infoTaoCan.cateInfoSpec.fontSizePt!))
        lab.textAlignment = .Center
        lab.textColor = UIColor.grayColor()
        lab.drawTextInRect(CGRect(x: 0, y: rect.size.height-height,
            width: rect.size.width, height: height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    private var firstAppear = true
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if firstAppear {
            firstAppear = false

            let imgSize = CGSize.autoSize(backView.frame.size, targetSize: frontView.image!.size)
            boderView.frame = CGRect(
                origin: CGPoint(x: (backView.frame.width - imgSize.width) / 2 + 1, y: 0),
                size: imgSize
            )
            boderView.hidden = false
            infoLabel.hidden = false
            frontView.hidden = false
            mixView.hidden = false
            mixView.userInteractionEnabled = true
            mixView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "quanPing"))
        }
    }

    //询问苹果能内购的东西
    func requestProducts() {
        let set = Set(["us.leqi.instantidphoto_1"]) as Set<String>
        let request = SKProductsRequest(productIdentifiers: set)
        request.delegate = self
        request.start()
    }

    // 以上查询的回调函数
    func productsRequest(request: SKProductsRequest,
        didReceiveResponse response: SKProductsResponse) {
            if productDict == nil {
                productDict = NSMutableDictionary(capacity: response.products.count)
            }
            for product in response.products {
                print("Product id\(product.productIdentifier)")
                print("产品标题\(product.localizedTitle)")
                print("产品描述信息\(product.localizedDescription)")
                print("价格:\(product.price)")
                productDict.setObject(product, forKey: "saving for once")
            }
            MSAfx.loadingView.Hide(nil)
    }

    //MARK:-内购
    func paymentQueue(queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]) {
            MSAfx.loadingView.Hide(nil)
            for transaction in transactions {
                if SKPaymentTransactionState.Purchased == transaction.transactionState {
                    print("支付成了")
                    self.success()
                    // 将交易从交易队列中删除
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                } else if SKPaymentTransactionState.Failed == transaction.transactionState {
                    print("支付失败")
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                } else if SKPaymentTransactionState.Restored == transaction.transactionState {//恢复购买
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                }
            }
    }

    func quanPing() {
        //查看我的证件照
        let kantuCtrl = EFFullScreenView()
        kantuCtrl.setParm(mixView.image!)
        self.presentViewController(kantuCtrl, animated: false, completion: nil)
    }

    //析构函数
    deinit {
        MSAfx.loadingView.Hide(nil)
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
    }

    @IBAction func reShoot(sender: AnyObject) {
        if redoBtnShow {
            //返回拍摄界面
            self.navigationController?.popToViewController(
                self.navigationController!.viewControllers[2],
                animated: true)
        }
    }

    //MARK:-点保存到相册
    @IBAction func btnSave(sender: UIButton) {
        showBottomPopView()
 }

    //MARK:-选择付一美元
    func PayOneDollar() {
        #if IS_PRO
            self?.success()
        #else
            if self.productDict != nil {
                if SKPaymentQueue.canMakePayments() {
                    if let prod = self.productDict["saving for once"]
                        as? SKProduct {
                        let payment = SKPayment(product: prod)
                        SKPaymentQueue.defaultQueue().addPayment(payment)
                        MSAfx.loadingView.Show(self, withString: NSLocalizedString(
                            "Loading...", comment: ""))
                    }
                }
            } else {

            }
        #endif
    }

    //MARK:-支付成功后调用
    func success() {
        var name: String?
        #if IS_PRO
            name = "Instant ID Photo Pro"
        #else
            name = "Instant ID Photo"
        #endif

        #if IS_PRO

        #else
            if let shareBtn = self.view.viewWithTag(10001) as? UIButton {
                self.isChangeStatus = false
                shareBtn.setImage(UIImage(named: "button_printer"),
                    forState: UIControlState.Normal)
            }
        #endif

        self.showMidPopView()
        MSPreviewViewController.library.saveImage(self.bigMixImg,
            toAlbum: name, withCompletionBlock: {
                (error: NSError?) -> Void in
            })
        MSPreviewViewController.library.saveImage(self.frontView.image, toAlbum: name, withCompletionBlock: {
                (error: NSError?) -> Void in
            })
    }

    //MARK:-这个按钮主要是为了可以点里头的打印。。。那为何要叫share。。。
    @IBAction func btnPrint(sender: AnyObject) {
        if isChangeStatus {
            DAAlertController.showAlertViewInViewController(
                self,
                withTitle: "",
                message: NSLocalizedString(
                    "Please share the photo after saving to the album.", comment: ""),
                actions: [DAAlertAction(title: NSLocalizedString("OK", comment: ""),
                    style: .Default, handler: nil)])
        } else {
            let imageData = UIImagePNGRepresentation(self.bigMixImg!)
            let objShare = NSMutableArray()
            objShare.addObject(imageData!)
            let controller = UIActivityViewController(activityItems: objShare as [AnyObject],
                                                      applicationActivities: nil)
            let excludedAct = [UIActivityTypePostToTwitter]
            controller.excludedActivityTypes = excludedAct
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }


    //弹出框
    func showMidPopView() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MSPreviewViewController.showFullScreen),
            name: "showMyIDphoto", object: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let midVC = storyboard.instantiateViewControllerWithIdentifier("MSMidViewController")
            as? MSMidViewController {
            midVC.modalPresentationStyle = .OverCurrentContext
            midVC.view.backgroundColor = UIColor.clearColor()
            self.presentViewController(midVC, animated: false, completion: nil)
        }
    }

    func showFullScreen() {
        let kantuCtrl = EFFullScreenView()
        kantuCtrl.setParm(MSAfx.imageMix)
        self.presentViewController(kantuCtrl, animated: false, completion: nil)
    }

    //MARK:-友盟分享
    func UMengShare()   {
        let shareText = "Recommend a useful & powerful app Instant ID Photo which can automatically replace the background, beautify face & crop size as your wish.  http://www.camcap.us/en/"

        //针对twitter缩减到140字以内
        UMSocialData.defaultData().extConfig.twitterData.shareText = "Instant ID Photo: smart background replacement,natural face beautification,support types camcap.us/en/"
        UMSocialSnsService.presentSnsIconSheetView(self,
                                                 appKey: "563318a9e0f55a306a0000de",
                                                 shareText: shareText,
                                                 shareImage: frontView.image,
                                                 shareToSnsNames:[UMShareToFacebook,
                                                    UMShareToTwitter,
                                                    UMShareToInstagram,
                                                    UMShareToLine,
                                                    UMShareToWhatsapp,
                                                    UMShareToTumblr],
                                                 delegate:self)
    }
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        /* 根据`responseCode`得到发送结果,如果分享成功 */
        if(response.responseCode == UMSResponseCodeSuccess) {

            /* 分享成功得到分享到的平台名 */
            print(response.data)
//            DAAlertController.showAlertViewInViewController(
//                self,
//                withTitle: "",
//                message: "Share success",
//                actions: [DAAlertAction(title: NSLocalizedString("OK", comment: ""),
//                    style: .Default, handler: nil)])
            self.success()
            //把Share的按钮变成蓝色并启用
            self.isChangeStatus = false
            let shareBtn = self.view.viewWithTag(10001) as? UIButton
            shareBtn!.setImage(UIImage(named: "button_printer"),
                              forState: UIControlState.Normal)
        }else{
//            DAAlertController.showAlertViewInViewController(
//                self,
//                withTitle: "",
//                message: "Share failure",
//                actions: [DAAlertAction(title: NSLocalizedString("OK", comment: ""),
//                    style: .Default, handler: nil)])

        }
    }


    //MARK:-分享提示弹出
    //弹出框
    var imageV: UIView!
    func showBottomPopView() {
        let styleMark = MSAfx.isWXUmengHidden() || !shareEnable

        self.addGreyBack(1)
        if nil != imageV {
            imageV.removeFromSuperview()
            imageV = nil
        }
        imageV = UIView()
        imageV.frame = CGRect(
            x: 0, y: backBtn.frame.height,
            width: backBtn.frame.width, height: 239
        )
        imageV.backgroundColor = UIColor.whiteColor()
        backBtn.addSubview(imageV)

        //标题
        let titleL = UILabel()
        titleL.frame = CGRect(
            x: 0, y: 19, width: backBtn.frame.width, height: 15
        )
        titleL.text = "How to save this ID photo?"
        titleL.textAlignment = NSTextAlignment.Center
        titleL.textColor = MSColor.wordBlack1
        titleL.font = UIFont.systemFontOfSize(15)
        imageV.addSubview(titleL)

        //线段
        let line = EFThinLine()
        line.frame = CGRect(
            x: 10, y: titleL.frame.origin.y + titleL.frame.height + 20,
            width: backBtn.frame.width - 20, height: 1
        )
        imageV.addSubview(line)

        //方法一:标题
        let titleFst = UILabel()
        titleFst.frame = CGRect(
            x: 10, y: line.frame.origin.y + line.frame.height + 14,
            width: backBtn.frame.width - 20, height: 13
        )
        titleFst.text = "1.Recommend Instant ID Photo to friends and save this ID photo for free."
        titleFst.textColor = UIColor(rgbValue: 0x999999)
        titleFst.font = UIFont.systemFontOfSize(13)
        titleFst.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleFst.numberOfLines = 0
        imageV.addSubview(titleFst)

        //方法一:按钮
        let returnBtn = UIButton()
        returnBtn.frame = CGRect(
            x: 10, y: titleFst.frame.origin.y + titleFst.frame.height + 11,
            width: backBtn.frame.width - 20, height: 42
        )
        returnBtn.backgroundColor = MSColor.mainOrange
        returnBtn.tag = 2
        returnBtn.layer.cornerRadius = 5
        returnBtn.setTitle("Share to social platform", forState: UIControlState.Normal)
        returnBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        returnBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        returnBtn.setImage(UIImage(named: "icon_share"), forState: UIControlState.Normal)
        returnBtn.setImage(UIImage(named: "icon_share"), forState: UIControlState.Highlighted)
        returnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        returnBtn.addTarget(
            self,
            action: #selector(MSPreviewViewController.hideBottomPopView(_:)),
            forControlEvents: UIControlEvents.TouchUpInside
        )
        imageV.addSubview(returnBtn)

        //方法二:标题
        let titleSec = UILabel()
        titleSec.frame = CGRect(
            x: 10,
            y: returnBtn.frame.origin.y + returnBtn.frame.height + 19,
            width: backBtn.frame.width - 20,
            height: 13
        )
        titleSec.text = "2.Pay $\(storageOrderPriceDanjiaStr)"
        titleSec.textColor = UIColor(rgbValue: 0x999999)
        titleSec.font = UIFont.systemFontOfSize(13)
        imageV.addSubview(titleSec)

        //方法二:按钮
        let secreturnBtn = UIButton()
        secreturnBtn.frame = CGRect(
            x: 10,
            y: titleSec.frame.origin.y + titleSec.frame.height + 11,
            width: backBtn.frame.width - 20,
            height: 42
        )
        secreturnBtn.backgroundColor = MSColor.mainLightBlue
        secreturnBtn.tag = 1
        secreturnBtn.layer.cornerRadius = 5
        secreturnBtn.setTitle("Pay $\(storageOrderPriceDanjiaStr)",
                              forState: UIControlState.Normal)
        secreturnBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        secreturnBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        secreturnBtn.setImage(UIImage(named: "icon_pay"), forState: UIControlState.Normal)
        secreturnBtn.setImage(UIImage(named: "icon_pay"), forState: UIControlState.Highlighted)
        secreturnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        secreturnBtn.addTarget(
            self,
            action: #selector(MSPreviewViewController.hideBottomPopView(_:)),
            forControlEvents: UIControlEvents.TouchUpInside
        )
        imageV.addSubview(secreturnBtn)

        //过审核和一次以后隐藏微信分享
        if styleMark {
            imageV.frame = CGRect(
                origin: imageV.frame.origin,
                size: CGSize(
                    width: imageV.frame.width,
                    height: imageV.frame.height - 85
                )
            )
            returnBtn.hidden = true
            titleFst.hidden = true

            secreturnBtn.backgroundColor = MSColor.mainOrange
            secreturnBtn.frame = returnBtn.frame
            titleSec.frame = titleFst.frame
            titleSec.text = "Pay $\(storageOrderPriceDanjiaStr)"
        }

        UIView.animateWithDuration(0.5,
                                   animations: {
                                    self.imageV.frame.origin.y = self.backBtn.frame.height - 239
                                        + (styleMark ? 85 : 0)
            },
                                   completion: nil
        )
    }

    //MARK:-保存到相册
    var backBtn: UIButton!
    var backBtn2: UIButton!
    func addGreyBack(index: Int) -> Void {
        let tarView = self.topViewEF()
        switch index {
        case 1:
            //底层暗色背景
            if nil == backBtn {
                backBtn = UIButton()
                backBtn.tag = 0
                backBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
                backBtn.frame = CGRect(
                    x: 0, y: 0,
                    width: tarView.frame.width, height: tarView.frame.height
                )
                backBtn.addTarget(
                    self,
                    action: #selector(MSPreviewViewController.hideBottomPopView(_:)),
                    forControlEvents: UIControlEvents.TouchUpInside
                )
            }
            tarView.addSubview(self.backBtn)
            break
        case 2:
            //底层暗色背景
            if nil == backBtn2 {
                backBtn2 = UIButton()
                backBtn2.tag = 0
                backBtn2.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
                backBtn2.frame = CGRect(
                    x: 0, y: 0,
                    width: tarView.frame.width, height: tarView.frame.height
                )
                backBtn2.addTarget(
                    self,
                    action: #selector(MSPreviewViewController.hideMidPopView(_:)),
                    forControlEvents: UIControlEvents.TouchUpInside
                )
            }
            tarView.addSubview(self.backBtn2)
            break
        default:
            break
        }
    }

    //MARK:-隐藏底部弹出框
    func hideBottomPopView(sender: AnyObject) {
        if nil != imageV {
            if let tarBtn = sender as? UIButton {
                let index = tarBtn.tag
                if 0 == index {
                    UIView.animateWithDuration(0.5,
                                               animations: {
                                                self.imageV.frame.origin.y = self.backBtn.frame.height
                        },
                                               completion: {
                                                (Bool) -> Void in
                                                self.removeGreyBack(1)
                    })
                } else {
                    self.imageV.frame.origin.y = self.backBtn.frame.height
                    self.removeGreyBack(1)

                    switch index {
                    case 1:
                        //支付一元
                        print("支付一美元")
                        PayOneDollar()
                        break
                    case 2:
                        //分享到盆友圈
                        print("分享到其他平台")
                        UMengShare()
                        break
                    default:
                        break
                    }
                }
            }
        }
    }

    //MARK:-隐藏弹出框
    var centerV: UIView!
    func hideMidPopView(sender: AnyObject) {
        NSLog("hideMidPopView")
        if nil != centerV {
            let tarView = self.topViewEF()
            if let tarBtn = sender as? UIButton {
                let index = tarBtn.tag
                if 0 == index {
                    NSLog("hideMidPopView:0")
                    UIView.animateWithDuration(0.5,
                                               animations: {
                                                self.centerV.frame.origin.y = tarView.frame.height + 125
                        },
                                               completion: {
                                                (Bool) -> Void in
                                                self.removeGreyBack(2)
                    })
                } else {
                    NSLog("hideMidPopView:1")
                    self.centerV.frame.origin.y = tarView.frame.height + 125
                    self.removeGreyBack(2)

                    switch index {
                    case 1:
                        //查看我的证件照
                        let kantuCtrl = EFFullScreenView()
                        var saveImg = UIImage()
                        if (MSAfx.cardNum != nil) && (MSAfx.infoTaoCan.cateInfoSpec.textRequired != false) {
                            saveImg = self.createImage()
                        } else {
                            saveImg = MSAfx.imageMix!.fixOrientationWithSize(
                                CGSize(
                                    width: (MSAfx.infoTaoCan.cateInfoSpec)!.widthPx!,
                                    height: (MSAfx.infoTaoCan.cateInfoSpec)!.heightPx!
                                )
                                )!
                        }
                        kantuCtrl.setParm(saveImg)
                        self.presentViewController(kantuCtrl, animated: false, completion: nil)
                        break
                    default:
                        break
                    }
                }
            }
        }
    }

    //MARK:-移除底部灰色遮罩
    func removeGreyBack(index: Int) -> Void {
        switch index {
        case 1:
            if nil != backBtn {
                backBtn.removeFromSuperview()
            }
            break
        case 2:
            if nil != backBtn2 {
                backBtn2.removeFromSuperview()
            }
            break
        default:
            break
        }
    }


}
