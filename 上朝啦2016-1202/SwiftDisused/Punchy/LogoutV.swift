
import UIKit

class LogoutV: PCViewController {

    let mainTitle = UILabel()
    let mainLogin = UIButton()
    let mainRegister = UIButton()
    let mainLeft = UIView()
    let mainRight = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        addControl()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if nil != refreshToken {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func addControl() {
        self.view.addSubview(mainTitle)
        mainTitle.font = UIFont.systemFontOfSize(38)
        mainTitle.text = "上朝啦"
        mainTitle.textColor = UIColor.grayColor()
        mainTitle.textAlignment = .Center
        mainTitle.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(38)
            make.top.equalTo(250)
            make.left.equalTo(view)
        }

        self.view.addSubview(mainLeft)
        mainLeft.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(view).dividedBy(2)
            make.height.equalTo(mainLeft.snp_width)
            make.left.bottom.equalTo(view)
        }

        self.view.addSubview(mainRight)
        mainRight.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(view).dividedBy(2)
            make.height.equalTo(mainRight.snp_width)
            make.right.bottom.equalTo(view)
        }

        mainLeft.addSubview(mainRegister)
        mainRegister.layer.borderColor = UIColor.grayColor().CGColor
        mainRegister.layer.borderWidth = 1
        mainRegister.layer.cornerRadius = 7
        mainRegister.setTitle("注册", forState: UIControlState.Normal)
        mainRegister.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        mainRegister.addTarget(self, action: #selector(self.gotoRegister),
                               forControlEvents: UIControlEvents.TouchUpInside)
        mainRegister.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(38)
            make.center.equalTo(mainLeft)
        }

        mainRight.addSubview(mainLogin)
        mainLogin.layer.borderColor = UIColor.grayColor().CGColor
        mainLogin.layer.borderWidth = 1
        mainLogin.layer.cornerRadius = 7
        mainLogin.setTitle("登录", forState: UIControlState.Normal)
        mainLogin.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        mainLogin.addTarget(self, action: #selector(self.gotoLogin),
                            forControlEvents: UIControlEvents.TouchUpInside)
        mainLogin.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(38)
            make.center.equalTo(mainRight)
        }
    }

    func gotoRegister() {
        let view = RegisterInfoV()
        view.modalPresentationStyle = .FullScreen
        view.modalTransitionStyle = .CoverVertical
        self.presentViewController(view, animated: true, completion: nil)
    }

    func gotoLogin() {
        let view = LoginV()
        view.modalPresentationStyle = .FullScreen
        view.modalTransitionStyle = .CoverVertical
        self.presentViewController(view, animated: true, completion: nil)
    }
}
