
import UIKit
import SnapKit
import DAAlertController
import Qiniu

enum RegisterInfoVMode {
    case Normal
    case Edit
}

class RegisterInfoV: PCViewController, UITextFieldDelegate {

    var registerInfoVMode = RegisterInfoVMode.Normal

    let registerInfoAreaUp = UIView()
    let registerInfoImage = UIImageView()

    let registerInfoAreaDown = UIView()
    let registerInfoContentAreaDown = UIView()
    let registerInfoUserNmae = UITextField()
    let registerInfoPhoneNumber = UITextField()
    let registerInfoCaptcha = UITextField()
    let registerInfoCaptchaRefresh = UIButton()
    let registerCaptchaTip = UILabel()
    let registerInfoTip = UILabel()
    let registerInfoOK = UIButton()
    let registerInfoCancel = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "注册"
        self.view.backgroundColor = UIColor.whiteColor()

        addControl()

        if registerInfoVMode == .Edit {
            if let controlData = userInfo {
                registerInfoUserNmae.text = controlData.name
                registerInfoPhoneNumber.text = controlData.phone_number

                if let url = controlData.avatar_url {
                    getImages([url], finish: {
                        [weak self] (images) in
                        userAvatar = images[0]
                        if let strongSelf = self {
                            strongSelf.registerInfoImage.image = userAvatar
                        }
                        })
                }
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        registerInfoImage.image = userAvatar ?? UIImage(named: "placeholder.jpg")
    }

    func addControl() {
        self.view.addSubview(registerInfoAreaUp)
        self.view.addSubview(registerInfoImage)
        self.view.addSubview(registerInfoAreaDown)
        self.view.addSubview(registerInfoContentAreaDown)
        self.view.addSubview(registerInfoUserNmae)
        self.view.addSubview(registerInfoPhoneNumber)
        self.view.addSubview(registerInfoCaptcha)
        self.view.addSubview(registerInfoCaptchaRefresh)
        self.view.addSubview(registerCaptchaTip)
        self.view.addSubview(registerInfoTip)
        self.view.addSubview(registerInfoOK)
        self.view.addSubview(registerInfoCancel)

        registerInfoAreaUp.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(view).offset(
                getHeightStatusBar() + getHeightNavigationBar(self)
            )
            make.left.right.equalTo(view)
            make.bottom.equalTo(registerInfoAreaDown.snp_top)
        }

        registerInfoImage.layer.borderColor = UIColor.grayColor().CGColor
        registerInfoImage.layer.borderWidth = 1
        registerInfoImage.layer.cornerRadius = 3
        registerInfoImage.contentMode = .ScaleAspectFit
        registerInfoImage.image = UIImage(named: "placeholder.jpg")
        registerInfoImage.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(RegisterInfoV.gotoCamera))
        )
        registerInfoImage.userInteractionEnabled = true
        registerInfoImage.snp_makeConstraints {
            (make) -> Void in
            make.left.top.equalTo(registerInfoAreaUp).offset(10)
            make.right.equalTo(registerInfoAreaUp).offset(-10)
            make.bottom.equalTo(registerInfoAreaUp)
        }

        registerInfoAreaDown.snp_makeConstraints {
            (make) -> Void in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(233 + 76 + 10)
        }

        registerInfoContentAreaDown.snp_makeConstraints {
            (make) -> Void in
            make.left.top.equalTo(registerInfoAreaDown).offset(10)
            make.right.bottom.equalTo(registerInfoAreaDown).offset(-10)
        }

        registerInfoUserNmae.layer.borderColor = UIColor.grayColor().CGColor
        registerInfoUserNmae.layer.borderWidth = 1
        registerInfoUserNmae.layer.cornerRadius = 3
        registerInfoUserNmae.placeholder = "用户名"
        registerInfoUserNmae.returnKeyType = .Done
        registerInfoUserNmae.delegate = self
        registerInfoUserNmae.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(registerInfoContentAreaDown)
            make.height.equalTo(38)
            make.top.equalTo(registerInfoContentAreaDown)
            make.left.equalTo(registerInfoContentAreaDown)
        }

        registerInfoPhoneNumber.layer.borderColor = UIColor.grayColor().CGColor
        registerInfoPhoneNumber.layer.borderWidth = 1
        registerInfoPhoneNumber.layer.cornerRadius = 3
        registerInfoPhoneNumber.placeholder = "手机号"
        registerInfoPhoneNumber.returnKeyType = .Done
        registerInfoPhoneNumber.delegate = self
        registerInfoPhoneNumber.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(registerInfoContentAreaDown)
            make.height.equalTo(38)
            make.top.equalTo(registerInfoUserNmae.snp_bottom).offset(5)
            make.left.equalTo(registerInfoContentAreaDown)
        }

        registerInfoCaptcha.layer.borderColor = UIColor.grayColor().CGColor
        registerInfoCaptcha.layer.borderWidth = 1
        registerInfoCaptcha.layer.cornerRadius = 3
        registerInfoCaptcha.placeholder = "验证码"
        registerInfoCaptcha.returnKeyType = .Done
        registerInfoCaptcha.delegate = self
        registerInfoCaptcha.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(registerInfoContentAreaDown).offset(-152-5)
            make.height.equalTo(38)
            make.top.equalTo(registerInfoPhoneNumber.snp_bottom).offset(5)
            make.left.equalTo(registerInfoContentAreaDown)
        }

        registerInfoCaptchaRefresh.layer.borderColor = UIColor.grayColor().CGColor
        registerInfoCaptchaRefresh.layer.borderWidth = 1
        registerInfoCaptchaRefresh.layer.cornerRadius = 3
        registerInfoCaptchaRefresh.setTitle("获得验证码", forState: UIControlState.Normal)
        registerInfoCaptchaRefresh.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        registerInfoCaptchaRefresh.addTarget(self, action: #selector(self.captchas),
                                             forControlEvents: UIControlEvents.TouchUpInside)
        registerInfoCaptchaRefresh.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(152)
            make.height.equalTo(38)
            make.top.equalTo(registerInfoPhoneNumber.snp_bottom).offset(5)
            make.left.equalTo(registerInfoCaptcha.snp_right).offset(5)
        }

        registerCaptchaTip.font = UIFont.systemFontOfSize(16)
        registerCaptchaTip.text = "每个手机号每天只可以获取三次验证码，谨慎使用"
        registerCaptchaTip.textColor = UIColor.grayColor()
        registerCaptchaTip.textAlignment = .Center
        registerCaptchaTip.lineBreakMode = .ByWordWrapping
        registerCaptchaTip.numberOfLines = 0
        registerCaptchaTip.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(registerInfoContentAreaDown)
            make.height.equalTo(43)
            make.left.equalTo(registerInfoContentAreaDown)
            make.top.equalTo(registerInfoCaptcha.snp_bottom)
        }

        registerInfoTip.font = UIFont.systemFontOfSize(16)
        registerInfoTip.text = "注册即代表同意[上朝啦] 服务条款 和 隐私条款"
        registerInfoTip.textColor = UIColor.grayColor()
        registerInfoTip.textAlignment = .Center
        registerInfoTip.lineBreakMode = .ByWordWrapping
        registerInfoTip.numberOfLines = 0
        registerInfoTip.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(registerInfoContentAreaDown)
            make.height.equalTo(43)
            make.left.equalTo(registerInfoContentAreaDown)
            make.top.equalTo(registerCaptchaTip.snp_bottom)
        }

        registerInfoOK.layer.borderColor = UIColor.grayColor().CGColor
        registerInfoOK.layer.borderWidth = 1
        registerInfoOK.layer.cornerRadius = 3
        registerInfoOK.setTitle("确定", forState: UIControlState.Normal)
        registerInfoOK.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        registerInfoOK.addTarget(self, action: #selector(self.register),
                                 forControlEvents: UIControlEvents.TouchUpInside)
        registerInfoOK.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(registerInfoContentAreaDown)
            make.height.equalTo(38)
            make.bottom.equalTo(registerInfoCancel.snp_top).offset(-5)
            make.left.equalTo(registerInfoContentAreaDown)
        }

        registerInfoCancel.layer.borderColor = UIColor.grayColor().CGColor
        registerInfoCancel.layer.borderWidth = 1
        registerInfoCancel.layer.cornerRadius = 3
        registerInfoCancel.setTitle("取消", forState: UIControlState.Normal)
        registerInfoCancel.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        registerInfoCancel.addTarget(self, action: #selector(self.gotoCancel),
                                     forControlEvents: UIControlEvents.TouchUpInside)
        registerInfoCancel.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(registerInfoContentAreaDown)
            make.height.equalTo(38)
            make.bottom.equalTo(registerInfoContentAreaDown.snp_bottom)
            make.left.equalTo(registerInfoContentAreaDown)
        }
    }

    func getUserName() -> String? {
        if let text = registerInfoUserNmae.text {
            let trimText = text.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            if !trimText.isEmpty {
                return trimText
            }
        }

        return nil
    }

    func getPhoneNumber() -> String? {
        if let text = registerInfoPhoneNumber.text {
            let trimText = text.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            if isPhoneNumber(trimText) {
                return trimText
            }
        }
        return nil
    }

    func getCaptcha() -> String? {
        if let text = registerInfoCaptcha.text {
            let trimText = text.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            if isCaptcha(trimText) {
                return trimText
            }
        }
        return nil
    }

    func gotoCamera() {
        let view = PunchyCameraV()
        view.modalPresentationStyle = .FullScreen
        view.modalTransitionStyle = .CoverVertical
        view.punchyCameraVMode = .Edit
        self.presentViewController(view, animated: true, completion: nil)
    }

    func captchas() {
        if let phoneNumber = getPhoneNumber() {
            captchaCountDown()
            loadingView.ShowAt(self, withString: "加载中")
            PunchyAPIProvider.request(.Captchas(phoneNumber: phoneNumber)) {
                [weak self] result in
                if let strongSelf = self {
                    if case let .Success(response) = result {
                        if let json = (try? response.mapJSON()) as? NSDictionary {
                            if let message = json["message"] as? String {
                                loadingView.Hide(nil)
                                messageBox(strongSelf, content: message)
                                return
                            } else {
                                loadingView.Hide(nil)
                                return
                            }
                        }
                    }
                    loadingView.Hide(nil)
                    messageBox(strongSelf, content: "获取验证码失败")
                }
            }
        } else {
            messageBox(self, content: "手机号格式有误")
        }
    }

    func register() {
        if let name = getUserName(), let phoneNumber = getPhoneNumber(), let captcha = getCaptcha(), let avaImg = userAvatar {
            if registerInfoVMode == .Edit {
                loadingView.ShowAt(self, withString: "加载中")
                checkTokens {
                    [weak self] (val) in
                    if let strongSelf = self {
                        if !val {
                            loadingView.Hide(nil)
                            messageBox(strongSelf, content: "Token 刷新失败")
                            return
                        }
                        if let xxxID = userID {
                            PunchyAPIProvider.request(.EmployeesInfo(
                                employeeID: xxxID, isSet: true, name: name, phoneNumber: phoneNumber, captcha: captcha
                            )) {
                                result in
                                if case let .Success(response) = result {
                                    if let json = (try? response.mapJSON()) as? NSDictionary {
                                        if let message = json["message"] as? String {
                                            loadingView.Hide(nil)
                                            messageBox(strongSelf, content: message)
                                            return
                                        } else {
                                            if let tokenJson = json["avatar_upload_token"] as? NSDictionary {
                                                if let token = tokenJson["token"] as? String, let key = tokenJson["key"] as? String {
                                                    let testImageData = UIImageJPEGRepresentation(avaImg, 1)
                                                    let opt = QNUploadOption(
                                                        mime: "jpeg",
                                                        progressHandler: nil,
                                                        params: nil,
                                                        checkCrc: false,
                                                        cancellationSignal: nil
                                                    )
                                                    let upManager = QNUploadManager()
                                                    upManager.putData(
                                                        testImageData,
                                                        key: key,
                                                        token: token,
                                                        complete: {
                                                            (info, key, resp) in
                                                            loadingView.Hide(nil)
                                                            messageBox(strongSelf, content: "个人信息修改成功",
                                                                actions: [
                                                                    DAAlertAction(title: "确定", style: .Default, handler: {
                                                                        strongSelf.dismissViewControllerAnimated(true, completion: nil)
                                                                    })]
                                                            )
                                                        },
                                                        option: opt
                                                    )
                                                    //todo: 失败重传没做
                                                    return
                                                }
                                            }
                                        }
                                    }
                                }
                                loadingView.Hide(nil)
                                messageBox(strongSelf, content: "个人信息修改失败")
                            }
                        } else {
                            loadingView.Hide(nil)
                            messageBox(strongSelf, content: "本地用户ID缓存失效请重新登录")
                        }
                    }
                }
            } else {
                loadingView.ShowAt(self, withString: "加载中")
                PunchyAPIProvider.request(.Employees(name: name, phoneNumber: phoneNumber, captcha: captcha)) {
                    [weak self] result in
                    if let strongSelf = self {
                        if case let .Success(response) = result {
                            if let json = (try? response.mapJSON()) as? NSDictionary {
                                if let message = json["message"] as? String {
                                    loadingView.Hide(nil)
                                    messageBox(strongSelf, content: message)
                                    return
                                } else {
                                    userInfo = employeeModel(json["employee"])
                                    userID = userInfo.id

                                    if let dict = json["tokens"] as? NSDictionary {
                                        refreshToken = dict["refresh_token"] as? String
                                        accessToken = dict["access_token"] as? String
                                    }

                                    if let tokenJson = json["avatar_upload_token"] as? NSDictionary {
                                        if let token = tokenJson["token"] as? String, let key = tokenJson["key"] as? String {
                                            let testImageData = UIImageJPEGRepresentation(avaImg, 1)
                                            let opt = QNUploadOption(
                                                mime: "jpeg",
                                                progressHandler: nil,
                                                params: nil,
                                                checkCrc: false,
                                                cancellationSignal: nil
                                            )
                                            let upManager = QNUploadManager()
                                            upManager.putData(
                                                testImageData,
                                                key: key,
                                                token: token,
                                                complete: {
                                                    (info, key, resp) in
                                                    messageBox(strongSelf, content: "注册成功",
                                                        actions: [
                                                            DAAlertAction(title: "确定", style: .Default, handler: {
                                                                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                                                            })]
                                                    )
                                                },
                                                option: opt
                                            )
                                            //todo: 失败重传没做
                                            return
                                        }
                                    }
                                }
                            }
                        }
                        loadingView.Hide(nil)
                        messageBox(strongSelf, content: "注册失败")
                    }
                }
            }
        } else {
            messageBox(self, content: "用户名/手机号/验证码/头像格式有误")
        }
    }

    func gotoCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Timer
    var countDownTarTime = time(nil)
    var countDownTimer: NSTimer!
    func captchaCountDown() {
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(
            1.0, target: self,
            selector: #selector(LoginV.countDownMethod),
            userInfo: nil, repeats:true
        )

        countDownTarTime = time(nil) + 60
        registerInfoCaptchaRefresh.enabled = false
        countDownTimer.fire()
    }

    func countDownMethod() {
        if let tryTimer = countDownTimer {
            let sec = countDownTarTime - time(nil)
            registerInfoCaptchaRefresh.setTitle(
                "重获验证码（\(sec)）",
                forState: UIControlState.Normal
            )
            if sec <= 0 {
                tryTimer.invalidate()
                countDownTimer = nil
                registerInfoCaptchaRefresh.setTitle(
                    "获取验证码",
                    forState: UIControlState.Normal
                )
                registerInfoCaptchaRefresh.enabled = true
            }
        }
    }
    
    //收起键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}