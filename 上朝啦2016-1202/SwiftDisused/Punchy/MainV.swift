
import UIKit
import Qiniu

class MainV: PCViewController {

    let mainText = UITextView()
    let mainMe = UIButton()
    let mainPunch = UIButton()
    let mainSet = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        addControl()

        //刷新打卡信息
        refreshPunchyList()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if nil == refreshToken {
            gotoLogout()
        } else if let xxxImage = imageToUpLoad {
            loadingView.ShowAt(self, withString: "加载中")
            let todoImage = xxxImage.copy() as! UIImage
            imageToUpLoad = nil
            let testImageData = UIImageJPEGRepresentation(todoImage, 1)
            CCLocationManager.shareLocation().getLocationCoordinate() {
                [weak self] (location: CLLocationCoordinate2D) -> Void in
                if let strongSelf = self {
                    let locationX = location.latitude
                    let locationY = location.longitude
                    NSLog("X:\(locationX), Y:\(locationY)")

                    checkTokens {
                        (val) in
                        if !val {
                            loadingView.Hide(nil)
                            messageBox(strongSelf, content: "Token 刷新失败")
                            return
                        } else {
                            PunchyAPIProvider.request(.EmployersPunches(
                                imageHash: getDataSHA1(testImageData!),
                                latitude: locationX,
                                longitude: locationY,
                                wirelessAp: getWifiInfo().1,
                                operatingSystem: getSystemVersion(),
                                phoneModel: getDeviceModel()
                            )) {
                                result in
                                if case let .Success(response) = result {
                                    if let json = (try? response.mapJSON()) as? NSDictionary {
                                        if let message = json["message"] as? String {
                                            loadingView.Hide(nil)
                                            messageBox(strongSelf, content: message)
                                            return
                                        } else {
                                            if let tokenJson = json["image_upload_token"] as? NSDictionary {
                                                if let token = tokenJson["token"] as? String, let key = tokenJson["key"] as? String {
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
                                                            messageBox(strongSelf, content: "打卡成功")
                                                            strongSelf.refreshPunchyList()
                                                        },
                                                        option: opt
                                                    )
                                                    return
                                                }
                                            }
                                        }
                                    }
                                }
                                loadingView.Hide(nil)
                                messageBox(strongSelf, content: "打卡失败")
                            }
                        }
                    }
                }
            }
        }
    }

    func refreshPunchyList() {
        //刷新打卡信息数据
        //loadingView.ShowAt(self, withString: "加载中")
        if let xxxID = userID {
            checkTokens {
                [weak self] (val) in
                if val {
                    if let strongSlef = self {
                        PunchyAPIProvider.request(.EmployeesPunches(employeeID: xxxID, page: 1, perPage: 25)) {
                            result in
                            if case let .Success(response) = result {
                                if let json = (try? response.mapJSON()) as? NSDictionary {
                                    if let message = json["message"] as? String {
                                        messageBox(strongSlef, content: message)
                                    } else {
                                        var tempData = Array<punchyModel>()
                                        let arr: NSArray? = json["punches"] as? NSArray
                                        if nil != arr {
                                            for ele in arr! {
                                                let new = punchyModel(ele)
                                                if nil != new {
                                                    tempData.append(new!)
                                                }
                                            }
                                            if let strongSelf = self {
                                                var xxxString = ""
                                                for ele in tempData {
                                                    xxxString += "id:\(ele.id)\ndate:\(ele.created_at)\n\n"
                                                }
                                                strongSelf.mainText.text = xxxString
                                            }
                                        }
                                    }
                                    return
                                }
                            }
                            messageBox(strongSlef, content: "获取打卡信息失败")
                        }
                    }
                }
            }
        } else {
            gotoLogout()
        }
    }

    func addControl() {
        self.view.addSubview(mainText)
        self.view.addSubview(mainMe)
        self.view.addSubview(mainPunch)
        self.view.addSubview(mainSet)

        mainText.layer.borderColor = UIColor.grayColor().CGColor
        mainText.layer.borderWidth = 1
        mainText.layer.cornerRadius = 7
        mainText.font = UIFont.systemFontOfSize(14)
        mainText.editable = false
        mainText.text = ""
        mainText.textColor = UIColor.grayColor()
        mainText.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(view).offset(
                10 + getHeightStatusBar() + getHeightNavigationBar(self)
            )
            make.left.equalTo(view).offset(10)
            make.width.equalTo(view).offset(-20)
            make.height.equalTo(self.view).offset(
                -58 - (10 + getHeightStatusBar() + getHeightNavigationBar(self))
            )
        }

        mainMe.layer.borderColor = UIColor.grayColor().CGColor
        mainMe.layer.borderWidth = 1
        mainMe.layer.cornerRadius = 7
        mainMe.setTitle("我的", forState: UIControlState.Normal)
        mainMe.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        mainMe.addTarget(self, action: #selector(self.gotoMine),
                         forControlEvents: UIControlEvents.TouchUpInside)
        mainMe.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(mainText.snp_bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(mainPunch.snp_left).offset(-5)
            make.height.equalTo(38)
            make.width.equalTo(mainPunch)
        }

        mainPunch.layer.borderColor = UIColor.grayColor().CGColor
        mainPunch.layer.borderWidth = 1
        mainPunch.layer.cornerRadius = 7
        mainPunch.setTitle("打卡", forState: UIControlState.Normal)
        mainPunch.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        mainPunch.addTarget(self, action: #selector(self.gotoPunch),
                            forControlEvents: UIControlEvents.TouchUpInside)
        mainPunch.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(mainText.snp_bottom).offset(10)
            make.right.equalTo(mainSet.snp_left).offset(-5)
            make.height.equalTo(38)
            make.width.equalTo(mainSet)
        }

        mainSet.layer.borderColor = UIColor.grayColor().CGColor
        mainSet.layer.borderWidth = 1
        mainSet.layer.cornerRadius = 7
        mainSet.setTitle("设置", forState: UIControlState.Normal)
        mainSet.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        mainSet.addTarget(self, action: #selector(self.gotoSet),
                          forControlEvents: UIControlEvents.TouchUpInside)
        mainSet.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(mainText.snp_bottom).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(38)
            make.width.equalTo(mainMe)
        }
    }

    func gotoMine() {
        let view = MineV()
        view.modalPresentationStyle = .FullScreen
        view.modalTransitionStyle = .CoverVertical
        self.presentViewController(view, animated: true, completion: nil)
    }

    func gotoPunch() {
        let view = PunchyCameraV()
        view.modalPresentationStyle = .FullScreen
        view.modalTransitionStyle = .CoverVertical
        view.punchyCameraVMode = .Normal
        self.presentViewController(view, animated: true, completion: nil)
    }

    func gotoSet() {
        let view = SetV()
        view.modalPresentationStyle = .FullScreen
        view.modalTransitionStyle = .CoverVertical
        self.presentViewController(view, animated: true, completion: nil)
    }

    func gotoLogout() {
        logout()

        let view = LogoutV()
        view.modalPresentationStyle = .FullScreen
        view.modalTransitionStyle = .CoverVertical
        self.presentViewController(view, animated: true, completion: nil)
    }
}
