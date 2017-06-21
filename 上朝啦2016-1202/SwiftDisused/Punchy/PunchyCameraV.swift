
import UIKit
import AssetsLibrary
import DAAlertController
import JPSVolumeButtonHandler

enum PunchyCameraVMode {
    case Normal
    case Edit
}

class PunchyCameraV: PCViewController, UINavigationControllerDelegate {

    var punchyCameraVMode = PunchyCameraVMode.Normal

    private var camera: LLSimpleCamera!
    private var errorLabel: UILabel!
    private var topBar: UIView!
    private var switchButton: UIButton!
    private var flashButton: UIButton!
    private var guideLine: UIImageView!
    private var tipsBar: UIView!
    private var tipsLabel: UILabel!
    private var bottomBar: UIView!
    private var snapButton: UIButton!
    private var backButton: UIButton!
    private var tipsTimer: NSTimer!

    private static let library: ALAssetsLibrary = ALAssetsLibrary()
    private static var volumeButtonHandler: JPSVolumeButtonHandler!

    //是否在快门按下处理中
    private var notSnaping: Bool!
    private var notSnapingAlbumIgnore: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let screenSize = getScreenSize()

        // Initialize Camera
        self.camera = LLSimpleCamera(
            quality: AVCaptureSessionPresetHigh,
            position: CameraPositionFront,
            videoEnabled: false
        )
        self.camera.fixOrientationAfterCapture = false
        self.camera.useDeviceOrientation = true
        self.camera.onDeviceChange = {
            [weak self] (camera: LLSimpleCamera!, device: AVCaptureDevice!) -> Void in
            if let srtongSelf = self {
                srtongSelf.flashButton.hidden = !camera.isFlashAvailable()
            }
        }
        self.camera.onError = {
            [weak self] (camera: LLSimpleCamera!, error: NSError!) -> Void in
            if LLSimpleCameraErrorDomain == error.domain {
                if let srtongSelf = self {
                    if nil != srtongSelf.errorLabel {
                        srtongSelf.errorLabel.removeFromSuperview()
                    }
                    let label: UILabel = UILabel(frame: CGRect.zero)
                    label.text = "提示:请在系统设置中打开相机权限"
                    label.numberOfLines = 2
                    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    label.backgroundColor = UIColor.clearColor()
                    label.font = UIFont.systemFontOfSize(16)
                    label.textColor = UIColor.whiteColor()
                    label.textAlignment = NSTextAlignment.Center
                    label.sizeToFit()
                    label.center = CGPoint(
                        x: screenSize.width / 2.0, y: screenSize.height / 2.0
                    )
                    srtongSelf.errorLabel = label
                    srtongSelf.view.addSubview(srtongSelf.errorLabel)
                }
            }
        }

        //添加控件
        addControls()

        //调整控件位置
        rePlace()

        //打开计时器
        self.tipsTimer = NSTimer.scheduledTimerWithTimeInterval(
            2.0,
            target: self,
            selector: #selector(PunchyCameraV.refreshTips),
            userInfo: nil,
            repeats: true
        )

        //替换对焦框
        addZiDingYiFocusBox()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //自拍杆
        if true == notSnapingAlbumIgnore {
            notSnapingAlbumIgnore = false
        } else {
            notSnaping = true
        }
        PunchyCameraV.volumeButtonHandler = JPSVolumeButtonHandler(upBlock: {
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

        // start the camera
        self.camera.start()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //隐藏状态栏
        UIApplication.sharedApplication().setStatusBarHidden(
            true, withAnimation: UIStatusBarAnimation.None
        )
        if self.camera.view.frame.width != self.view.frame.width
            || self.camera.view.frame.height != self.view.frame.height {
            rePlace()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        // stop the camera
        self.camera.stop()

        //自拍杆
        notSnaping = false
        PunchyCameraV.volumeButtonHandler = nil
    }

    //MARK: 切换摄像头
    func switchButtonPressed(button: UIButton) {
        self.camera.togglePosition()
    }

    //MARK: 切换闪光灯
    func flashButtonPressed(button: UIButton) {
        if self.camera.flash == CameraFlashOff {
            if self.camera.updateFlashMode(CameraFlashOn) {
                self.flashButton.setImage(
                    UIImage(named: "闪光灯按钮（开）"),
                    forState: UIControlState.Normal
                )
            }
        } else {
            if self.camera.updateFlashMode(CameraFlashOff) {
                self.flashButton.setImage(
                    UIImage(named: "闪光灯按钮（关）"),
                    forState: UIControlState.Normal
                )
            }
        }
    }

    //MARK: 拍摄
    func snapButtonPressed(button: UIButton!) {
        if true == notSnaping {
            notSnaping = false
            self.camera.capture({
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
                            withTitle: "错误",
                            message: "出现异常，拍摄失败",
                            actions: [DAAlertAction(title: "确定", style: .Default, handler: {
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

    //MARK: 返回
    func backButtonPressed(button: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func checkPicture(img: UIImage, src: Int) {
        self.actionCheck(src, img: img)
    }

    func actionCheck(src: Int, img: UIImage) {
        if punchyCameraVMode == .Edit {
            userAvatar = img
        } else {
            imageToUpLoad = img
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: 隐藏导航栏
    func hideNavCtrl() {
        //存在该函数则隐藏导航栏
    }

    // MARK: 隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: 方向
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }

    // MARK: 添加控件
    func addControls() {
        let screenSize = getScreenSize()

        //相机画面
        self.camera.attachToViewController(self,
                                           withFrame: CGRect(origin: CGPoint.zero, size: screenSize)
        )
        //顶部条状物
        self.topBar = UIView()
        self.topBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.view.addSubview(self.topBar)
        //闪光灯
        self.flashButton = UIButton(type: UIButtonType.System)
        self.flashButton.tintColor = UIColor.whiteColor()
        self.flashButton.setImage(UIImage(named: "闪光灯按钮（关）"),
                                  forState: UIControlState.Normal)
        self.flashButton.addTarget(self, action: #selector(PunchyCameraV.flashButtonPressed(_:)),
                                   forControlEvents: UIControlEvents.TouchUpInside)
        self.topBar.addSubview(self.flashButton)
        //切换摄像头
        self.switchButton = UIButton(type: UIButtonType.System)
        self.switchButton.tintColor = UIColor.whiteColor()
        self.switchButton.setImage(UIImage(named: "切换相机按钮"),
                                   forState: UIControlState.Normal)
        self.switchButton.addTarget(self, action: #selector(PunchyCameraV.switchButtonPressed(_:)),
                                    forControlEvents: UIControlEvents.TouchUpInside)
        self.topBar.addSubview(self.switchButton)
        //辅助线:normal-3/4,marry-4/3
        self.guideLine = UIImageView()
        self.guideLine.image = UIImage(named: "辅助线")
        self.view.addSubview(self.guideLine)
        //tips条状物(容器+文字)
        self.tipsBar = UIView()
        self.tipsBar.backgroundColor = UIColor(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 0.6)
        self.view.addSubview(self.tipsBar)
        self.tipsLabel = UILabel()
        self.tipsLabel.text = ""
        self.tipsLabel.textColor = UIColor.whiteColor()
        self.tipsLabel.numberOfLines = 0
        self.tipsLabel.font = UIFont.systemFontOfSize(12)
        self.tipsLabel.backgroundColor = UIColor.clearColor()
        self.tipsBar.addSubview(self.tipsLabel)
        //底部条状物
        self.bottomBar = UIView()
        self.bottomBar.backgroundColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
        self.view.addSubview(self.bottomBar)
        //拍摄按钮
        self.snapButton = UIButton()
        self.snapButton.setImage(UIImage(named: "快门按钮"), forState: UIControlState.Normal)
        self.snapButton.contentMode = UIViewContentMode.ScaleToFill
        self.snapButton.addTarget(self, action: #selector(PunchyCameraV.snapButtonPressed(_:)),
                                  forControlEvents: UIControlEvents.TouchUpInside)
        self.bottomBar.addSubview(self.snapButton)
        //返回按钮
        self.backButton = UIButton()
        self.backButton.setImage(UIImage(named: "返回"), forState: UIControlState.Normal)
        self.backButton.contentMode = UIViewContentMode.ScaleToFill
        self.backButton.addTarget(self, action: #selector(PunchyCameraV.backButtonPressed(_:)),
                                  forControlEvents: UIControlEvents.TouchUpInside)
        self.bottomBar.addSubview(self.backButton)
    }

    // MARK: 调整控件位置
    func rePlace() {
        let screenSize = getScreenSize()

        self.camera.view.frame = CGRect(
            x: 0.0, y: 0.0, width: screenSize.width, height: screenSize.height
        )

        //
        self.topBar.frame = CGRect(
            x: 0, y: 0, width: screenSize.width, height: 50.0
        )
        //
        let flashButtonSize = CGSize(width: 50.0, height: 50.0)
        self.flashButton.frame = CGRect(
            origin: CGPoint(x: screenSize.width - flashButtonSize.width, y: 0),
            size: flashButtonSize
        )
        //
        self.switchButton.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        //
        let guideLineSize = CGSize(
            width: screenSize.width,
            height: screenSize.width / 3.0 * 4.0
        )
        self.guideLine.frame = CGRect(origin: CGPoint.zero, size: guideLineSize)
        //
        refreshTips()
        //
        self.bottomBar.frame = CGRect(
            x: 0, y: screenSize.height - 69,
            width: screenSize.width, height: 69
        )
        //必须在 bottomBar 位置确定后
        self.guideLine.center = CGPoint(
            x: self.view.center.x,
            y: (self.bottomBar.frame.minY + self.topBar.frame.maxY) / 2.0
        )
        //
        let snapButtonSize = CGSize(width: 56, height: 56)
        self.snapButton.frame = CGRect(
            origin: CGPoint(
                x: (screenSize.width - snapButtonSize.width) / 2.0,
                y: (self.bottomBar.frame.height - snapButtonSize.height) / 2.0
            ),
            size: snapButtonSize
        )
        //
        let albumButtonSize = CGSize(width: 60.0, height: 60.0)
        //
        let backButtonSize = CGSize(width: 60.0, height: 60.0)
        self.backButton.frame = CGRect(
            origin: CGPoint(
                x: self.bottomBar.frame.maxX - 10.0 - backButtonSize.width,
                y: (self.bottomBar.frame.height - albumButtonSize.height) / 2.0
            ),
            size: backButtonSize
        )
    }

    // MARK: 顶部提示刷新
    private var tipIndex: Int = 0
    func refreshTips() {
        let tar = (
            (self.camera.position != CameraPositionBack) ? [
                "后置摄像头拍摄的证件照更规范哦！",
                "建议使用后置摄像头拍摄！",
                ] : [
                    "请他人协助拍摄！",
                    "请选择光照充足的地方拍摄哦！",
                    "避免服装颜色与背景相同！",
                    "注意摆正头部哦！",
            ]
        )
        let screenSize = getScreenSize()
        self.tipsLabel.text = tar[(++tipIndex) % tar.count]
        self.tipsLabel.font = UIFont.systemFontOfSize(12)
        self.tipsLabel.frame = CGRect(origin: CGPoint.zero, size: screenSize)
        self.tipsLabel.sizeToFit()
        let textSize = self.tipsLabel.frame.size
        self.tipsLabel.frame = CGRect(origin: CGPoint(x: 10, y: 6), size: textSize)

        let tipsBarSize = CGSize(width: textSize.width + 20, height: textSize.height + 12)
        self.tipsBar.frame = CGRect(
            origin: CGPoint(
                x: self.topBar.center.x - tipsBarSize.width / 2,
                y: self.topBar.frame.maxY
            ),
            size: tipsBarSize
        )
        self.tipsBar.layer.cornerRadius = self.tipsBar.frame.height / 2
    }

    // MARK: 替换对焦框
    func addZiDingYiFocusBox() {
        let focusBox = CALayer()
        focusBox.bounds = CGRect(
            x: 0.0, y: 0.0, width: 58.0, height: 58.0
        )
        focusBox.opacity = 0.0
        focusBox.contents = UIImage(named: "对焦框")?.CGImage
        self.view.layer.addSublayer(focusBox)

        let focusBoxAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        focusBoxAnimation.duration = 2
        focusBoxAnimation.autoreverses = false
        focusBoxAnimation.repeatCount = 0.0
        focusBoxAnimation.fromValue = NSNumber(float: 1.0)
        focusBoxAnimation.toValue = NSNumber(float: 0.0)

        self.camera.alterFocusBox(focusBox, animation: focusBoxAnimation)
    }
}
