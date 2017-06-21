
import UIKit

class SetV: PCViewController {

    let buttonYanZheng = UIButton()
    let buttonTianJia = UIButton()
    let buttonTuiJian = UIButton()
    let buttonBangZhu = UIButton()
    let buttonXieYi = UIButton()
    let buttonExit = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        addControl()
    }

    func addControl() {
        self.view.addSubview(buttonYanZheng)
        self.view.addSubview(buttonTianJia)
        self.view.addSubview(buttonTuiJian)
        self.view.addSubview(buttonBangZhu)
        self.view.addSubview(buttonXieYi)
        self.view.addSubview(buttonExit)

        buttonYanZheng.layer.borderColor = UIColor.grayColor().CGColor
        buttonYanZheng.layer.borderWidth = 1
        buttonYanZheng.layer.cornerRadius = 7
        buttonYanZheng.setTitle("验证手机", forState: UIControlState.Normal)
        buttonYanZheng.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonYanZheng.addTarget(self, action: #selector(self.gotoYanZheng),
                              forControlEvents: UIControlEvents.TouchUpInside)
        buttonYanZheng.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(
                getHeightStatusBar() + getHeightNavigationBar(self) + 10
            )
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(38)
        }

        buttonTianJia.layer.borderColor = UIColor.grayColor().CGColor
        buttonTianJia.layer.borderWidth = 1
        buttonTianJia.layer.cornerRadius = 7
        buttonTianJia.setTitle("添加收钱账户", forState: UIControlState.Normal)
        buttonTianJia.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonTianJia.addTarget(self, action: #selector(self.gotoTianJia),
                              forControlEvents: UIControlEvents.TouchUpInside)
        buttonTianJia.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonYanZheng.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonYanZheng)
        }

        buttonTuiJian.layer.borderColor = UIColor.grayColor().CGColor
        buttonTuiJian.layer.borderWidth = 1
        buttonTuiJian.layer.cornerRadius = 7
        buttonTuiJian.setTitle("推荐App赚钱", forState: UIControlState.Normal)
        buttonTuiJian.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonTuiJian.addTarget(self, action: #selector(self.gotoTuiJian),
                              forControlEvents: UIControlEvents.TouchUpInside)
        buttonTuiJian.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonTianJia.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonTianJia)
        }

        buttonBangZhu.layer.borderColor = UIColor.grayColor().CGColor
        buttonBangZhu.layer.borderWidth = 1
        buttonBangZhu.layer.cornerRadius = 7
        buttonBangZhu.setTitle("查看帮助", forState: UIControlState.Normal)
        buttonBangZhu.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonBangZhu.addTarget(self, action: #selector(self.gotoBangZhu),
                               forControlEvents: UIControlEvents.TouchUpInside)
        buttonBangZhu.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonTuiJian.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonTuiJian)
        }

        buttonXieYi.layer.borderColor = UIColor.grayColor().CGColor
        buttonXieYi.layer.borderWidth = 1
        buttonXieYi.layer.cornerRadius = 7
        buttonXieYi.setTitle("再看一遍用户协议", forState: UIControlState.Normal)
        buttonXieYi.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonXieYi.addTarget(self, action: #selector(self.gotoXieYi),
                                 forControlEvents: UIControlEvents.TouchUpInside)
        buttonXieYi.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(buttonBangZhu.snp_bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(buttonBangZhu)
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
            make.height.equalTo(buttonXieYi)
        }
    }

    func gotoYanZheng() {
        messageBox(self, content: "该功能未实装")
    }

    func gotoTianJia() {
        messageBox(self, content: "该功能未实装")
    }

    func gotoTuiJian() {
        messageBox(self, content: "该功能未实装")
    }

    func gotoBangZhu() {
        messageBox(self, content: "该功能未实装")
    }

    func gotoXieYi() {
        messageBox(self, content: "该功能未实装")
    }

    func gotoExit() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
