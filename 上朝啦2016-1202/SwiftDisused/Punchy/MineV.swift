
import UIKit
import DAAlertController

class MineV: PCViewController {

    let buttonChaKan = UIButton()
    let buttonJiaRu = UIButton()
    let buttonQuXiaoJiaRu = UIButton()
    let buttonJieYue = UIButton()
    let buttonQuXiaoJieYue = UIButton()
    let buttonXinXi = UIButton()
    let buttonLogout = UIButton()
    let buttonExit = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        addControl()
    }

    func addControl() {
        self.view.addSubview(buttonChaKan)
        self.view.addSubview(buttonJiaRu)
        self.view.addSubview(buttonQuXiaoJiaRu)
        self.view.addSubview(buttonJieYue)
        self.view.addSubview(buttonQuXiaoJieYue)
        self.view.addSubview(buttonXinXi)
        self.view.addSubview(buttonLogout)
        self.view.addSubview(buttonExit)

        buttonChaKan.layer.borderColor = UIColor.grayColor().CGColor
        buttonChaKan.layer.borderWidth = 1
        buttonChaKan.layer.cornerRadius = 7
        buttonChaKan.setTitle("查看当前合约", forState: UIControlState.Normal)
        buttonChaKan.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonChaKan.addTarget(self, action: #selector(self.gotoChaKan),
                               forControlEvents: UIControlEvents.TouchUpInside)
        buttonChaKan.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(
                getHeightStatusBar() + getHeightNavigationBar(self) + 10
            )
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(38)
        }

        buttonJiaRu.layer.borderColor = UIColor.grayColor().CGColor
        buttonJiaRu.layer.borderWidth = 1
        buttonJiaRu.layer.cornerRadius = 7
        buttonJiaRu.setTitle("申请加入新公司", forState: UIControlState.Normal)
        buttonJiaRu.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonJiaRu.addTarget(self, action: #selector(self.gotoJiaRu),
                              forControlEvents: UIControlEvents.TouchUpInside)
        buttonJiaRu.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonChaKan.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonChaKan)
        }

        buttonQuXiaoJiaRu.layer.borderColor = UIColor.grayColor().CGColor
        buttonQuXiaoJiaRu.layer.borderWidth = 1
        buttonQuXiaoJiaRu.layer.cornerRadius = 7
        buttonQuXiaoJiaRu.setTitle("取消加入新公司申请", forState: UIControlState.Normal)
        buttonQuXiaoJiaRu.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonQuXiaoJiaRu.addTarget(self, action: #selector(self.gotoQuXiaoJiRu),
                                    forControlEvents: UIControlEvents.TouchUpInside)
        buttonQuXiaoJiaRu.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonJiaRu.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonJiaRu)
        }

        buttonJieYue.layer.borderColor = UIColor.grayColor().CGColor
        buttonJieYue.layer.borderWidth = 1
        buttonJieYue.layer.cornerRadius = 7
        buttonJieYue.setTitle("申请与现公司解约", forState: UIControlState.Normal)
        buttonJieYue.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonJieYue.addTarget(self, action: #selector(self.gotoJieYue),
                               forControlEvents: UIControlEvents.TouchUpInside)
        buttonJieYue.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonQuXiaoJiaRu.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonQuXiaoJiaRu)
        }

        buttonQuXiaoJieYue.layer.borderColor = UIColor.grayColor().CGColor
        buttonQuXiaoJieYue.layer.borderWidth = 1
        buttonQuXiaoJieYue.layer.cornerRadius = 7
        buttonQuXiaoJieYue.setTitle("取消与现公司解约申请", forState: UIControlState.Normal)
        buttonQuXiaoJieYue.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonQuXiaoJieYue.addTarget(self, action: #selector(self.gotoQuXiaoJieYue),
                                     forControlEvents: UIControlEvents.TouchUpInside)
        buttonQuXiaoJieYue.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonJieYue.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonJieYue)
        }

        buttonXinXi.layer.borderColor = UIColor.grayColor().CGColor
        buttonXinXi.layer.borderWidth = 1
        buttonXinXi.layer.cornerRadius = 7
        buttonXinXi.setTitle("修改个人信息", forState: UIControlState.Normal)
        buttonXinXi.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonXinXi.addTarget(self, action: #selector(self.gotoXinXi),
                              forControlEvents: UIControlEvents.TouchUpInside)
        buttonXinXi.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonQuXiaoJieYue.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonQuXiaoJieYue)
        }

        buttonLogout.layer.borderColor = UIColor.grayColor().CGColor
        buttonLogout.layer.borderWidth = 1
        buttonLogout.layer.cornerRadius = 7
        buttonLogout.setTitle("注销", forState: UIControlState.Normal)
        buttonLogout.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        buttonLogout.addTarget(self, action: #selector(self.gotoLogout),
                               forControlEvents: UIControlEvents.TouchUpInside)
        buttonLogout.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonXinXi.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonXinXi)
        }

        buttonExit.layer.borderColor = UIColor.grayColor().CGColor
        buttonExit.layer.borderWidth = 1
        buttonExit.layer.cornerRadius = 7
        buttonExit.setTitle("返回", forState: UIControlState.Normal)
        buttonExit.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonExit.backgroundColor = UIColor(
            red: 234 / 255, green: 234 / 255, blue: 234 / 255, alpha: 1
        )
        buttonExit.addTarget(self, action: #selector(self.gotoExit),
                             forControlEvents: UIControlEvents.TouchUpInside)
        buttonExit.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(self.view).offset(-10)
            make.height.equalTo(buttonXinXi)
        }
    }

    func gotoChaKan() {
        if let xxxID = userID {
            loadingView.ShowAt(self, withString: "加载中")
            checkTokens {
                [weak self] (val) in
                if let strongSlef = self {
                    if !val {
                        loadingView.Hide(nil)
                        messageBox(strongSlef, content: "Token 刷新失败")
                        return
                    } else {
                        PunchyAPIProvider.request(.EmployeesContract(employeeID: xxxID)) {
                            result in
                            if 404 == result.value?.statusCode {
                                loadingView.Hide(nil)
                                messageBox(strongSlef, content: "当前未签订合约")
                                return
                            }
                            if case let .Success(response) = result {
                                if let json = (try? response.mapJSON()) as? NSDictionary {
                                    if let msg = json["message"] as? String {
                                        loadingView.Hide(nil)
                                        messageBox(strongSlef, content: msg)
                                        return
                                    } else {
                                        if let contract = json["contract"] as? NSDictionary {
                                            if let employer = contract["employer"] as? NSDictionary {
                                                if let name = employer["name"] as? String {
                                                    loadingView.Hide(nil)
                                                    messageBox(strongSlef, content: "当前公司: \(name)")
                                                    return
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            loadingView.Hide(nil)
                            messageBox(strongSlef, content: "当前合约获取失败")
                        }
                    }
                }
            }
        } else {
            messageBox(self, content: "本地用户ID缓存失效请重新登录")
        }
    }

    func gotoJiaRu() {
        let view = RegisterCompanyV()
        view.modalPresentationStyle = .FullScreen
        view.modalTransitionStyle = .CoverVertical
        self.presentViewController(view, animated: true, completion: nil)
    }

    func gotoQuXiaoJiRu() {
        if let xxxID = userID {
            loadingView.ShowAt(self, withString: "加载中")
            checkTokens {
                [weak self] (val) in
                if let strongSlef = self {
                    if !val {
                        loadingView.Hide(nil)
                        messageBox(strongSlef, content: "Token 刷新失败")
                        return
                    } else {
                        PunchyAPIProvider.request(.EmployeesContract(employeeID: xxxID)) {
                            result in
                            if 404 == result.value?.statusCode {
                                loadingView.Hide(nil)
                                messageBox(strongSlef, content: "当前不存在满足条件的合约")
                                return
                            }
                            if case let .Success(response) = result {
                                if let json = (try? response.mapJSON()) as? NSDictionary {
                                    if let msg = json["message"] as? String {
                                        loadingView.Hide(nil)
                                        messageBox(strongSlef, content: msg)
                                        return
                                    } else {
                                        if let contract = json["contract"] as? NSDictionary {
                                            if let contractID = contract["id"] as? String {
                                                PunchyAPIProvider.request(.ContractsID(
                                                    contractID: contractID, isDelete: true
                                                )) {
                                                    result in
                                                    if case let .Success(response) = result {
                                                        if let json = (try? response.mapJSON()) as? NSDictionary {
                                                            if let msg = json["message"] as? String {
                                                                loadingView.Hide(nil)
                                                                messageBox(strongSlef, content: msg)
                                                                return
                                                            } else {
                                                                loadingView.Hide(nil)
                                                                messageBox(strongSlef, content: "建立合约请求删除成功")
                                                                return
                                                            }
                                                        }
                                                    }
                                                    loadingView.Hide(nil)
                                                    messageBox(strongSlef, content: "建立合约请求删除失败")
                                                }
                                                return
                                            }
                                        }
                                    }
                                }
                            }
                            loadingView.Hide(nil)
                            messageBox(strongSlef, content: "当前合约获取失败")
                        }
                    }
                }
            }
        } else {
            messageBox(self, content: "本地用户ID缓存失效请重新登录")
        }
    }

    func gotoJieYue() {
        if let xxxID = userID {
            loadingView.ShowAt(self, withString: "加载中")
            checkTokens {
                [weak self] (val) in
                if let strongSlef = self {
                    if !val {
                        loadingView.Hide(nil)
                        messageBox(strongSlef, content: "Token 刷新失败")
                        return
                    } else {
                        PunchyAPIProvider.request(.EmployeesContract(employeeID: xxxID)) {
                            result in
                            if 404 == result.value?.statusCode {
                                loadingView.Hide(nil)
                                messageBox(strongSlef, content: "当前不存在满足条件的合约")
                                return
                            }
                            if case let .Success(response) = result {
                                if let json = (try? response.mapJSON()) as? NSDictionary {
                                    if let msg = json["message"] as? String {
                                        loadingView.Hide(nil)
                                        messageBox(strongSlef, content: msg)
                                        return
                                    } else {
                                        if let contract = json["contract"] as? NSDictionary {
                                            if let contractID = contract["id"] as? String {
                                                PunchyAPIProvider.request(.ContractsIDTermination(
                                                    contractID: contractID, isDelete: false
                                                )) {
                                                    result in
                                                    if case let .Success(response) = result {
                                                        if let json = (try? response.mapJSON()) as? NSDictionary {
                                                            if let msg = json["message"] as? String {
                                                                loadingView.Hide(nil)
                                                                messageBox(strongSlef, content: msg)
                                                                return
                                                            } else {
                                                                loadingView.Hide(nil)
                                                                messageBox(strongSlef, content: "终止合约请求创建成功")
                                                                return
                                                            }
                                                        }
                                                    }
                                                    loadingView.Hide(nil)
                                                    messageBox(strongSlef, content: "终止合约请求创建失败")
                                                }
                                                return
                                            }
                                        }
                                    }
                                }
                            }
                            loadingView.Hide(nil)
                            messageBox(strongSlef, content: "当前合约获取失败")
                        }
                    }
                }
            }
        } else {
            messageBox(self, content: "本地用户ID缓存失效请重新登录")
        }
    }

    func gotoQuXiaoJieYue() {
        if let xxxID = userID {
            loadingView.ShowAt(self, withString: "加载中")
            checkTokens {
                [weak self] (val) in
                if let strongSlef = self {
                    if !val {
                        loadingView.Hide(nil)
                        messageBox(strongSlef, content: "Token 刷新失败")
                        return
                    } else {
                        PunchyAPIProvider.request(.EmployeesContract(employeeID: xxxID)) {
                            result in
                            if 404 == result.value?.statusCode {
                                loadingView.Hide(nil)
                                messageBox(strongSlef, content: "当前不存在满足条件的合约")
                                return
                            }
                            if case let .Success(response) = result {
                                if let json = (try? response.mapJSON()) as? NSDictionary {
                                    if let msg = json["message"] as? String {
                                        loadingView.Hide(nil)
                                        messageBox(strongSlef, content: msg)
                                        return
                                    } else {
                                        if let contract = json["contract"] as? NSDictionary {
                                            if let contractID = contract["id"] as? String {
                                                PunchyAPIProvider.request(.ContractsIDTermination(
                                                    contractID: contractID, isDelete: true
                                                )) {
                                                    result in
                                                    if case let .Success(response) = result {
                                                        if let json = (try? response.mapJSON()) as? NSDictionary {
                                                            if let msg = json["message"] as? String {
                                                                loadingView.Hide(nil)
                                                                messageBox(strongSlef, content: msg)
                                                                return
                                                            } else {
                                                                loadingView.Hide(nil)
                                                                messageBox(strongSlef, content: "终止合约请求删除成功")
                                                                return
                                                            }
                                                        }
                                                    }
                                                    loadingView.Hide(nil)
                                                    messageBox(strongSlef, content: "终止合约请求删除失败")
                                                }
                                                return
                                            }
                                        }
                                    }
                                }
                            }
                            loadingView.Hide(nil)
                            messageBox(strongSlef, content: "当前合约获取失败")
                        }
                    }
                }
            }
        } else {
            messageBox(self, content: "本地用户ID缓存失效请重新登录")
        }
    }

    func gotoXinXi() {
        if let xxxID = userID {
            loadingView.ShowAt(self, withString: "加载中")
            checkTokens {
                [weak self] (val) in
                if let strongSelf = self {
                    if !val {
                        loadingView.Hide(nil)
                        messageBox(strongSelf, content: "Token 刷新失败")
                        return
                    } else {
                        PunchyAPIProvider.request(.EmployeesInfo(
                            employeeID: xxxID, isSet: false, name: nil, phoneNumber: nil, captcha: nil
                        )) {
                            result in
                            if case let .Success(response) = result {
                                if let json = (try? response.mapJSON()) as? NSDictionary {
                                    if let message = json["message"] as? String {
                                        loadingView.Hide(nil)
                                        messageBox(strongSelf, content: message)
                                        return
                                    } else {
                                        userInfo = employeeModel(json["employee"])
                                        if let _ = userInfo {
                                            let view = RegisterInfoV()
                                            view.modalPresentationStyle = .FullScreen
                                            view.modalTransitionStyle = .CoverVertical
                                            view.registerInfoVMode = .Edit
                                            loadingView.Hide(nil)
                                            strongSelf.presentViewController(view, animated: true, completion: nil)
                                            return
                                        }
                                    }
                                }
                            }
                            loadingView.Hide(nil)
                            messageBox(strongSelf, content: "个人信息获取失败")
                        }
                    }
                }
            }
        } else {
            messageBox(self, content: "本地用户ID缓存失效请重新登录")
        }
    }

    func gotoLogout() {
        messageBox(self, content: "注销",
                   actions: [
                    DAAlertAction(title: "确定", style: .Default, handler: {
                        logout()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }), DAAlertAction(title: "取消", style: .Default, handler: nil)
            ])
    }
    
    func gotoExit() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
