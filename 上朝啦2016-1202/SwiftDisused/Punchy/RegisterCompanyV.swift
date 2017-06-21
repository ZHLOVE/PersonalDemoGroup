
import UIKit
import SnapKit
import DAAlertController

class RegisterCompanyV: PCViewController, UITableViewDelegate, UITableViewDataSource {

    let companyName = UITextField()
    let companySearch = UIButton()
    let companyTable = UITableView()
    let buttonExit = UIButton()

    var companyModels = Array<employersModel>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "选择公司"
        self.view.backgroundColor = UIColor.whiteColor()

        addControl()
    }

    func addControl() {
        self.view.addSubview(companyName)
        self.view.addSubview(companySearch)
        self.view.addSubview(companyTable)
        self.view.addSubview(buttonExit)

        companyName.layer.borderColor = UIColor.grayColor().CGColor
        companyName.layer.borderWidth = 1
        companyName.layer.cornerRadius = 3
        companyName.placeholder = "搜索"
        companyName.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(self.view).offset(-20-76-5)
            make.height.equalTo(38)
            make.top.equalTo(self.view).offset(
                10 + getHeightStatusBar() + getHeightNavigationBar(self)
            )
            make.left.equalTo(self.view).offset(10)
        }

        companySearch.layer.borderColor = UIColor.grayColor().CGColor
        companySearch.layer.borderWidth = 1
        companySearch.layer.cornerRadius = 3
        companySearch.setTitle("搜索", forState: UIControlState.Normal)
        companySearch.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        companySearch.addTarget(self, action: #selector(self.search),
                                forControlEvents: UIControlEvents.TouchUpInside)
        companySearch.snp_makeConstraints {
            (make) -> Void in
            make.width.equalTo(76)
            make.height.equalTo(38)
            make.top.equalTo(companyName)
            make.left.equalTo(companyName.snp_right).offset(5)
        }

        companyTable.layer.borderColor = UIColor.grayColor().CGColor
        companyTable.layer.borderWidth = 1
        companyTable.layer.cornerRadius = 3
        companyTable.delegate = self
        companyTable.dataSource = self
        companyTable.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(companyName.snp_bottom).offset(5)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(buttonExit.snp_top).offset(-5)
        }

        buttonExit.layer.borderColor = UIColor.grayColor().CGColor
        buttonExit.layer.borderWidth = 1
        buttonExit.layer.cornerRadius = 7
        buttonExit.setTitle("返回", forState: UIControlState.Normal)
        buttonExit.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonExit.backgroundColor = UIColor(
            red: 234 / 255, green: 234 / 255, blue: 234 / 255, alpha: 1
        )
        buttonExit.addTarget(self, action: #selector(self.gotoCancel),
                             forControlEvents: UIControlEvents.TouchUpInside)
        buttonExit.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(self.view).offset(-10)
            make.height.equalTo(companySearch)
        }
    }

    // MARK: - UITableView

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyModels.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 38
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        messageBox(self, content: "与该公司创建合约？",
                   actions: [
                    DAAlertAction(title: "确定", style: .Default, handler: {
                        loadingView.ShowAt(self, withString: "加载中")
                        checkTokens {
                            [weak self] (val) in
                            if let strongSelf = self {
                                if !val {
                                    loadingView.Hide(nil)
                                    messageBox(strongSelf, content: "Token 刷新失败")
                                    return
                                } else {
                                    PunchyAPIProvider.request(.EmployersIDContracts(
                                        employerID: strongSelf.companyModels[indexPath.row].id
                                    )) {
                                        result in
                                        if case let .Success(response) = result {
                                            if let json = (try? response.mapJSON()) as? NSDictionary {
                                                if let message = json["message"] as? String {
                                                    loadingView.Hide(nil)
                                                    messageBox(strongSelf, content: message)
                                                    return
                                                } else {
                                                    loadingView.Hide(nil)
                                                    messageBox(strongSelf, content: "合约请求创建成功",
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
                                        messageBox(strongSelf, content: "合约请求创建失败")
                                        return
                                    }
                                }
                            }
                        }
                    }), DAAlertAction(title: "取消", style: .Default, handler: nil)])
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let reuseID = "RegisterCompanyVCell\(indexPath.row)"
        cell = UITableViewCell(style: .Subtitle, reuseIdentifier: reuseID)
        cell.textLabel?.text = companyModels[indexPath.row].name
        return cell
    }

    //通用处理 separator 边距问题
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        var tarInset: UIEdgeInsets!
        tarInset = UIEdgeInsetsMake(0, 10, 0, 0)

        if tableView.respondsToSelector(Selector("setSeparatorInset:")) {
            tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0)
        }
        if tableView.respondsToSelector(Selector("setLayoutMargins:")) {
            tableView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 0)
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = tarInset
        }
        cell.separatorInset = tarInset
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    //MARK: - function
    func getKeyWord() -> String? {
        if let text = companyName.text {
            let trimText = text.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            return trimText
        }
        return nil
    }

    func search() {
        if let keyword = getKeyWord() {
            loadingView.ShowAt(self, withString: "加载中")
            companyModels = Array<employersModel>()
            checkTokens {
                [weak self] (val) in
                if let strongSelf = self {
                    if !val {
                        loadingView.Hide(nil)
                        messageBox(strongSelf, content: "Token 刷新失败")
                        return
                    } else {
                        PunchyAPIProvider.request(.Employers(page: 1, perPage: 25, name: keyword)) {
                            result in
                            if case let .Success(response) = result {
                                if let json = (try? response.mapJSON()) as? NSDictionary {
                                    if let message = json["message"] as? String {
                                        loadingView.Hide(nil)
                                        messageBox(strongSelf, content: message)
                                        return
                                    } else {
                                        let arr: NSArray? = json["employers"] as? NSArray
                                        if nil != arr {
                                            for ele in arr! {
                                                let new = employersModel(ele)
                                                if nil != new {
                                                    strongSelf.companyModels.append(new!)
                                                }
                                            }
                                            strongSelf.companyTable.reloadData()
                                            loadingView.Hide(nil)
                                            return
                                        }
                                    }
                                }
                            }
                            loadingView.Hide(nil)
                            messageBox(strongSelf, content: "查找失败")
                        }
                    }
                }
            }
        } else {
            messageBox(self, content: "关键字格式有误")
        }
    }

    func gotoCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}