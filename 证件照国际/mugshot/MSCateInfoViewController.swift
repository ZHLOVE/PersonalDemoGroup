//
//  MSCateInfoViewController.swift
//  mugshot
//
//  Created by Venpoo on 15/8/19.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit
import DAAlertController

class MSCateInfoViewController: EFViewController,
UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewCateInfo: UITableView!
    //上层输入
    var catePre: CategoryModel?
    //本层生成
    var cateInfo: CateInfoModel?
    var selectIndex: NSNumber?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tableViewCateInfo.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置 tableview 顶部 offset
        var testUIEdgeInsets: UIEdgeInsets = tableViewCateInfo.contentInset
        testUIEdgeInsets.top = 10
        tableViewCateInfo.contentInset = testUIEdgeInsets
        tableViewCateInfo.contentOffset = CGPoint(x: 0, y: -10.0)
        selectIndex = 0

        if let catePre = catePre {
            self.navigationItem.title = catePre.name
            refreshCateInfo()
        }
    }

    //析构函数
    deinit {
        tableViewCateInfo.delegate = nil
        MSAfx.loadingView.Hide(nil)
    }

    func refreshCateInfo() {
        MSAfx.loadingView.ShowAt(self, withString: NSLocalizedString("Loading...", comment: ""))
        MSNetwork.sharedInstance.getCategorieDetailByID((catePre?.categoryID)!, finish: {
            [weak self] (data: CateInfoModel?, error: NSError?, info: String?) -> Void in
            if let strongSelf = self {
                if info != nil {
                    MSAfx.loadingView.Hide(info)
                } else {
                    if nil != error {
                        MSAfx.loadingView.Hide(NSLocalizedString(
                            "Loading failed, please try again", comment: ""))
                    } else {
                        strongSelf.cateInfo = data
                        strongSelf.tableViewCateInfo.reloadData()
                        MSAfx.loadingView.Hide(nil)
                        if strongSelf.cateInfo?.specs?.count == 0 {
                            DAAlertController.showAlertViewInViewController(strongSelf,
                                withTitle: "Info",
                                message: "This category is empty!",
                                actions: [DAAlertAction(title: "OK", style: .Default, handler: {
                                    if let strongSelf_in = self {
                                        strongSelf_in.navigationController?
                                            .popViewControllerAnimated(true)
                                    }
                                    })
                                ]
                            )
                        }
                    }
                }
            }
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func countSize(content: String) -> CGFloat {
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(13)]
        let option = NSStringDrawingOptions.UsesFontLeading
        let rect = content.boundingRectWithSize(CGSize(width: 1000, height: 15),
            options: option, attributes: attributes, context: nil)
        let width = rect.size.width
        return width
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CateInfo2CateInfoSpecSelect" {
            if let controller = segue.destinationViewController as?
                MSCateInfoSpecSelectViewController {
                controller.parent = self
                controller.index = selectIndex
                controller.specs = cateInfo?.specs
            }
        } else if segue.identifier == "CateInfo2Camera" {
            MSAfx.infoTaoCan.catePre = self.catePre
            if let specs = self.cateInfo?.specs {
                if let index = selectIndex as? Int {
                    MSAfx.infoTaoCan.cateInfoSpec = specs[index]
                }
            }
        }
    }

    func actionFeedTap() {
        //意见反馈
        let feed = UMFeedback.feedbackModalViewController()
        feed.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        presentViewController(feed, animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if (cateInfo?.specs?.count <= 1 ? 0 : 1) == indexPath.section {
                if cateInfo != nil {
                    if cateInfo?.specs?.count <= 1 && nil != cateInfo {
                        selectIndex = 0
                    }
                    var selectSpec: CateInfoSpecModel? = nil
                    if let index = selectIndex as? Int {
                        selectSpec = (cateInfo?.specs!)![index]
                    }
                    let arr: [String] = selectSpec!.getOtherInfo().componentsSeparatedByString("\n")
                    var num = CGFloat(arr.count)
                    for ele in arr {
                        let width = countSize(ele)
                        if (width+30) > (tableViewCateInfo.frame.width - countSize("背景色")) {
                            num = num + 1
                        }
                    }
                    return 210 + 15.5 * num
                } else {
                    return 205
                }
            } else {
                return 43.0
            }
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView()
        foot.backgroundColor = UIColor.clearColor()
        return foot
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        //这里为了处理没有多个选项的情况
        var index: Int = indexPath.section
        if cateInfo?.specs?.count <= 1 && nil != cateInfo {
            index = indexPath.section + 1
        }
        if UITableViewCellSelectionStyle.None != tableView.cellForRowAtIndexPath(indexPath)!
            .selectionStyle {
                switch index {
                case 0:
                    break
                case 1:
                    break
                case 2:
                    self.performSegueWithIdentifier("CateInfo2Camera", sender: nil)
                    break
                default:
                    break
                }
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 + (cateInfo?.specs?.count <= 1 ? 0 : 1)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            //这里为了处理没有多个选项的情况
            var index = indexPath.section
            if cateInfo?.specs?.count <= 1 && nil != cateInfo {
                index = indexPath.section + 1
                selectIndex = 0
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("section\(index)",
                forIndexPath: indexPath)
            if let cateInfo = cateInfo {
                //这里为了处理没有选择和数据没有加载完成或者加载失败的情况
                var selectSpec: CateInfoSpecModel? = nil
                if let index = selectIndex as? Int {
                    if index < cateInfo.specs?.count {
                        selectSpec = cateInfo.specs![index]
                    }
                }
                //边线
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = UIColor(rgbValue: 0xdddddd).CGColor
                //判定类型
                switch index {
                case 0:
                    if let selectSpec = selectSpec {
                        cell.detailTextLabel?.text = selectSpec.name
                    }
                case 1:
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    if nil != selectSpec && MSAfx.infoTaoCan.backdrops != nil {
                        if MSAfx.infoTaoCan.backdrops!.count > 0 {
                            if let sizeLab = cell.viewWithTag(1) as? UILabel {
                                sizeLab.text = selectSpec?.getSizeInfo()
                            }
                            if let pxLab = cell.viewWithTag(222) as? UILabel {
                                pxLab.text = selectSpec?.getPxInfo()
                            }
                            if let byteLab = cell.viewWithTag(2) as? UILabel {
                                byteLab.text = selectSpec?.getByteInfo()
                            }
                            if let colorLab = cell.viewWithTag(3) as? UILabel {
                                colorLab.text = selectSpec?.getColorInfo(
                                    MSAfx.infoTaoCan.backdrops!)
                            }
                            if let otherLab = cell.viewWithTag(4) as? UILabel {
                                otherLab.text = selectSpec?.getOtherInfo()
                            }
                        }
                        //去除 tapView 的所有手势
                        let tapView: UIView = cell.viewWithTag(777)!
                        if let gestures = tapView.gestureRecognizers {
                            for gesture in gestures {
                                tapView.removeGestureRecognizer(gesture)
                            }
                        }
                        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                            action: "actionFeedTap")
                        tapView.addGestureRecognizer(tap)
                    }
                case 2:
                    if selectSpec != nil {
                        cell.selectionStyle = UITableViewCellSelectionStyle.Default
                        cell.contentView.backgroundColor = UIColor(redColor: 77,
                            greenColor: 164, blueColor: 225, alpha: 1)
                    } else {
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        cell.contentView.backgroundColor = UIColor.grayColor()
                    }
                default:
                    break
                }
            }
            return cell
    }
}
