
import UIKit
import SnapKit
import DAAlertController

class LoginV: PCViewController {

    let loginControlArea = UIView()
    let loginPhoneNumber = UITextField()
    let loginCaptcha = UITextField()
    let loginCaptchaRefresh = UIButton()
    let loginTip = UILabel()
    let loginOK = UIButton()
    let loginCancel = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "登录"
        self.view.backgroundColor = UIColor.whiteColor()

        addControl()
    }

    func addControl() {
        self.view.addSubview(loginControlArea)
        loginControlArea.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(view).offset(
                10 + getHeightStatusBar() + getHeightNavigationBar(self)
            )
            make.left.equalTo(view).offset(10)
            make.width.equalTo(view).offset(-20)
            make.height.equalTo(190)
        }

        self.view.addSubview(loginPhoneNumber)
        loginPhoneNumber.layer.borderColor = UIColor.grayColor().CGColor
        loginPhoneNumber.layer.borderWidth = 1
        loginPhoneNumber.layer.cornerRadius = 3
        loginPhoneNumber.placeholder = "手机号"
        loginPhoneNumber.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(loginControlArea)
            make.height.equalTo(38)
            make.top.equalTo(loginControlArea)
            make.left.equalTo(loginControlArea)
        }

        self.view.addSubview(loginCaptcha)
        loginCaptcha.layer.borderColor = UIColor.grayColor().CGColor
        loginCaptcha.layer.borderWidth = 1
        loginCaptcha.layer.cornerRadius = 3
        loginCaptcha.placeholder = "验证码"
        loginCaptcha.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(loginControlArea).offset(-152-5)
            make.height.equalTo(38)
            make.top.equalTo(loginPhoneNumber.snp_bottom).offset(5)
            make.left.equalTo(loginControlArea)
        }

        self.view.addSubview(loginCaptchaRefresh)
        loginCaptchaRefresh.layer.borderColor = UIColor.grayColor().CGColor
        loginCaptchaRefresh.layer.borderWidth = 1
        loginCaptchaRefresh.layer.cornerRadius = 3
        loginCaptchaRefresh.setTitle("获取验证码", forState: UIControlState.Normal)
        loginCaptchaRefresh.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        loginCaptchaRefresh.addTarget(self, action: #selector(self.captchas),
                                      forControlEvents: UIControlEvents.TouchUpInside)
        loginCaptchaRefresh.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(152)
            make.height.equalTo(38)
            make.top.equalTo(loginPhoneNumber.snp_bottom).offset(5)
            make.left.equalTo(loginCaptcha.snp_right).offset(5)
        }

        self.view.addSubview(loginTip)
        loginTip.font = UIFont.systemFontOfSize(16)
        loginTip.text = "每个手机号每天只可以获取三次验证码，谨慎使用"
        loginTip.textColor = UIColor.grayColor()
        loginTip.textAlignment = .Center
        loginTip.lineBreakMode = .ByWordWrapping
        loginTip.numberOfLines = 0
        loginTip.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(loginControlArea)
            make.height.equalTo(43)
            make.left.equalTo(loginControlArea)
            make.top.equalTo(loginCaptcha.snp_bottom)
        }

        self.view.addSubview(loginOK)
        loginOK.layer.borderColor = UIColor.grayColor().CGColor
        loginOK.layer.borderWidth = 1
        loginOK.layer.cornerRadius = 3
        loginOK.setTitle("确定", forState: UIControlState.Normal)
        loginOK.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        loginOK.addTarget(self, action: #selector(self.tokens),
                          forControlEvents: UIControlEvents.TouchUpInside)
        loginOK.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(loginControlArea)
            make.height.equalTo(38)
            make.bottom.equalTo(loginControlArea.snp_bottom)
            make.left.equalTo(loginControlArea)
        }

        self.view.addSubview(loginCancel)
        loginCancel.layer.borderColor = UIColor.grayColor().CGColor
        loginCancel.layer.borderWidth = 1
        loginCancel.layer.cornerRadius = 3
        loginCancel.setTitle("返回", forState: UIControlState.Normal)
        loginCancel.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        loginCancel.addTarget(self, action: #selector(self.gotoCancel),
                              forControlEvents: UIControlEvents.TouchUpInside)
        loginCancel.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(loginControlArea)
            make.height.equalTo(38)
            make.top.equalTo(loginOK.snp_bottom).offset(5)
            make.left.equalTo(loginControlArea)
        }
    }

    func getPhoneNumber() -> String? {
        if let text = loginPhoneNumber.text {
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
        if let text = loginCaptcha.text {
            let trimText = text.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            if isCaptcha(trimText) {
                return trimText
            }
        }
        return nil
    }

    func gotoCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
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

    func tokens() {
        if let phoneNumber = getPhoneNumber(), let captcha = getCaptcha() {
            loadingView.ShowAt(self, withString: "加载中")
            PunchyAPIProvider.request(.Tokens(phoneNumber: phoneNumber, captcha: captcha)) {
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

                                loadingView.Hide(nil)
                                messageBox(strongSelf, content: "登录成功",
                                           actions: [
                                            DAAlertAction(title: "确定", style: .Default, handler: {
                                                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                                            })]
                                )
                                return
                            }
                        }
                    }
                    loadingView.Hide(nil)
                    messageBox(strongSelf, content: "登录失败")
                }
            }
        } else {
            messageBox(self, content: "手机号或验证码格式有误")
        }
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
        loginCaptchaRefresh.enabled = false
        countDownTimer.fire()
    }

    func countDownMethod() {
        if let tryTimer = countDownTimer {
            let sec = countDownTarTime - time(nil)
            loginCaptchaRefresh.setTitle(
                "重获验证码（\(sec)）",
                forState: UIControlState.Normal
            )
            if sec <= 0 {
                tryTimer.invalidate()
                countDownTimer = nil
                loginCaptchaRefresh.setTitle(
                    "获取验证码",
                    forState: UIControlState.Normal
                )
                loginCaptchaRefresh.enabled = true
            }
        }
    }
}