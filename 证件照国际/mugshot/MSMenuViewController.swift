//
//  ViewController.swift
//  mugshot
//
//  Created by Venpoo on 15/8/13.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit
import DAAlertController

class MSMenuViewController: EFViewController, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnMy: UIButton!
    @IBOutlet weak var btnGuide: UIButton!
    @IBOutlet weak var btnSet: UIButton!
    let menuBtn = UIButton()
    let leftMenu = UIImageView()
    let leftTab = UITableView()
    let backView = UIView()
    var tap = UITapGestureRecognizer()
    var pan = UIPanGestureRecognizer()
    var boolSelect = Bool()
    @IBOutlet weak var collectionViewMenu: UICollectionView!

    //按钮列表
    var arrMenuButtons: [MSMenuButtonGroup] = []
    //下拉
    let refreshControl: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        MSAfx.menuController = self

        //设置导航栏标题
        self.navigationItem.title = ""

        //初始化collectionview
        arrMenuButtons.append(MSMenuButtonGroup(type: .Feedback)!)
        arrMenuButtons.append(MSMenuButtonGroup(type: .Blank)!)

        leftMenu.image = UIImage(named: "sidebar_bg")
        leftMenu.userInteractionEnabled = true
        leftMenu.frame = CGRect(x: -self.view.frame.width/4*3, y: 0,
            width: self.view.frame.width/4*3, height: self.view.frame.height)
        self.navigationController?.view.addSubview(leftMenu)

        leftTab.frame = CGRect(x: 25, y: leftMenu.frame.height/2-120,
            width: leftMenu.frame.width-25, height: 300)
        leftTab.delegate = self
        leftTab.dataSource = self
        leftTab.scrollEnabled = false
        leftTab.backgroundColor = UIColor.clearColor()
        leftMenu.addSubview(leftTab)

        let topline = UIView()
        topline.backgroundColor = UIColor(rgbValue: 0xbccedc)
        topline.frame = CGRect(x: 16, y: 0, width: leftTab.frame.width, height: 0.3)
        leftTab.addSubview(topline)

        menuBtn.frame = CGRect(x: 12, y: 12, width: 50, height: 50)
        menuBtn.setImage(UIImage(named: "button_0"), forState: UIControlState.Normal)
        menuBtn.addTarget(self, action: Selector("showLeftMenu:"),
            forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuBtn)

        let singleLine = UIView(frame: CGRect(x: collectionViewMenu.frame.origin.x,
            y: collectionViewMenu.frame.origin.y-1,
            width: collectionViewMenu.frame.width,
            height: 1))
        singleLine.backgroundColor = UIColor(redColor: 221, greenColor: 221,
            blueColor: 221, alpha: 1)
        self.view.addSubview(singleLine)

        //下拉刷新
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: Selector("refreshCategories"),
            forControlEvents: UIControlEvents.ValueChanged)
        collectionViewMenu.addSubview(refreshControl)

        self.tap.requireGestureRecognizerToFail(self.pan)
        boolSelect = true

        backView.frame = self.view.bounds
        backView.backgroundColor = UIColor.clearColor()
    }

    func actionFeedTap() {
        UIView.animateWithDuration(0.5,
            animations: {
                self.leftMenu.frame.origin.x = -self.view.frame.width/4*3
                self.view.frame.origin.x = 0
                self.backView.removeGestureRecognizer(self.tap)
                self.backView.removeGestureRecognizer(self.pan)
                self.backView.removeFromSuperview()
                self.boolSelect = true
            },
            completion: nil
        )
    }

    func showLeftMenu(sender: UIButton) {
        UIView.animateWithDuration(0.5,
            animations: {
                if self.boolSelect {
                    self.leftMenu.frame.origin.x = 0
                    self.view.frame.origin.x = self.view.frame.width/4*3
                    self.view.addSubview(self.backView)
                    self.tap = UITapGestureRecognizer(target: self, action: "actionFeedTap")
                    self.backView.addGestureRecognizer(self.tap)
                    self.pan = UIPanGestureRecognizer(target: self, action: "actionFeedTap")
                    self.backView.addGestureRecognizer(self.pan)
                    self.boolSelect = false
                }
            },
            completion: nil
        )
    }

    private var firstAppear = true
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if firstAppear {
            firstAppear = false

            //下载类别并刷新
            getToken()
        }
    }

    //析构函数
    deinit {
        collectionViewMenu.delegate = nil
        MSAfx.loadingView.Hide(nil)
    }

    func getToken() {
        MSAfx.loadingView.Show(self, withString: NSLocalizedString("Loading...", comment: ""))
        if MSNetState.isConnectionAvailable() {
            MSNetwork.sharedInstance.getTokens {
                [weak self] (token: String?, err: NSError?, info: String?) in
                if nil != self {
                    if nil != info {
                        MSAfx.loadingView.Hide(info)
                    } else {
                        if err != nil || token == nil {
                            let message = NSLocalizedString(
                                "Loading failed, please try again", comment: "")
                            MSAfx.loadingView.Hide(message)
                        } else {
                            self!.refreshCategories()
                        }
                    }
                }
            }
        } else {
            MSNetwork.modelOnline = false
            MSAfx.loadingView.Hide(nil)
            DAAlertController.showAlertViewInViewController(
                self,
                withTitle: NSLocalizedString("Network unavailable!", comment: ""),
                message: NSLocalizedString("Network unavailable, please try again!", comment: ""),
                actions: [DAAlertAction(title: NSLocalizedString("OK", comment: ""),
                    style: .Default, handler: {
                    [weak self] void in
                    if nil != self {
                        self!.refreshCategories()
                    }
                    })
                ]
            )
        }
    }

    //下载主页样式
    func refreshCategories() {
        MSNetwork.modelOnline = MSNetState.isConnectionAvailable()
        MSNetwork.sharedInstance.getCategories() {
            [weak self] (categories: [CategoryModel]?, error: NSError?) -> Void in
            if let strongSelf = self {
                if nil != error || categories == nil {
                    MSAfx.loadingView.Hide(NSLocalizedString(
                        "Loading failed, please try again", comment: ""))
                    strongSelf.refreshControl.endRefreshing()
                } else {
                    //刷新Backdrops
                    MSNetwork.sharedInstance.getBackdrops({
                        [weak self] (bgData: Array<BackdropModel>?, error: NSError?) -> Void in
                        if let strongSelf = self {
                            if nil != error {
                                MSAfx.loadingView.Hide(NSLocalizedString(
                                    "Loading failed, please try again", comment: ""))
                            } else {
                                MSAfx.infoTaoCan.backdrops = bgData
                                strongSelf.setMenuCategories(categories)
                                MSAfx.loadingView.Hide(nil)
                            }
                            strongSelf.refreshControl.endRefreshing()
                        }
                        })
                }
            }
        }
    }

    //设置按钮列表
    func setMenuCategories(categories: Array<CategoryModel>?) {
        if let categories = categories {
            arrMenuButtons = Array()

            for category in categories {
                arrMenuButtons.append(MSMenuButtonGroup(category: category))
            }
            arrMenuButtons.append(MSMenuButtonGroup(type: .Feedback)!)

            // 界面上的分隔线其实是露出的背景色
            // 最后一行右侧存在 MSMenuButtonGroup 才能不露出背景色
            if arrMenuButtons.count % 2 == 1 {
                arrMenuButtons.append(MSMenuButtonGroup(type: .Blank)!)
            }
            collectionViewMenu.reloadData()
        }
    }

    //导航栏相关
    func hideNavigationController() {
        //存在该函数则隐藏导航栏
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Menu2CateInfo" {
            let controller = segue.destinationViewController as? MSCateInfoViewController
            let category = sender as? CategoryModel
            controller!.catePre = category
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)

        let buttonGroup = arrMenuButtons[indexPath.row]

        switch buttonGroup.type {
        case .Category:
            let category = arrMenuButtons[indexPath.row].category!
            self.performSegueWithIdentifier("Menu2CateInfo", sender: category)

        case .Feedback:
            let feed = UMFeedback.feedbackModalViewController()
            feed.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            presentViewController(feed, animated: true, completion: nil)

        default:
            break
        }
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //控制cell宽度，每行2个正方形
        let cellWidth = CGFloat(UIScreen.mainScreen().bounds.size.width - 1.0) / CGFloat(2.0)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return arrMenuButtons.count
    }

    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.arrMenuButtons[indexPath.row].cell(self, indexPath: indexPath)
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
        return 60
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == 0 {
            //意见反馈
            let feed = UMFeedback.feedbackModalViewController()
            feed.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            presentViewController(feed, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let string = NSLocalizedString("http://www.camcap.us/en/", comment: "")
            let objShare = NSMutableArray()
            objShare.addObject(string)
            let controller = UIActivityViewController(activityItems: objShare as [AnyObject],
                applicationActivities: nil)
            let excludedAct = [UIActivityTypePostToTwitter]
            controller.excludedActivityTypes = excludedAct
            self.presentViewController(controller, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            //为智能证件照评分
            UIApplication.sharedApplication().openURL(
                NSURL(string:
                    "https://itunes.apple.com/us/app/instant-id-photo/id1048894869?l=zh&ls=1&mt=8")!
            )
        } else if indexPath.row == 4 {
            //关于:从 storyboard 创建 MSAboutController
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            if let aboutController = storyboard.instantiateViewControllerWithIdentifier(
                "MSAboutController")
                as? MSAboutController {
                    self.navigationController?.pushViewController(aboutController, animated: true)
            }

        } else {
            //攻略
            let web = EFWebViewController.createWithURL(NSLocalizedString(
                "http://www.camcap.us/m/guide_global/", comment: ""),
                title: NSLocalizedString("Raiders", comment: ""))
            self.navigationController?.pushViewController(web, animated: true)
        }
        self.actionFeedTap()
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let reuseID = "open\(indexPath.row)\(indexPath.section)"
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier(reuseID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: reuseID)
        }
        let imageV = UIImageView(frame: CGRect(x: 15, y: 10, width: 40, height: 40))
        let title = UILabel(frame: CGRect(x: 70, y: 10, width: 200, height: 40))
        title.textColor = MSColor.wordBlack0
        if indexPath.row == 0 {
            imageV.image = UIImage(named: "button_feedback")
            title.text = NSLocalizedString("Feedback", comment: "")
        } else if indexPath.row == 1 {
            imageV.image = UIImage(named: "guide")
            title.text = NSLocalizedString("Raiders", comment: "")
        } else if indexPath.row == 2 {
            imageV.image = UIImage(named: "recommend")
            title.text = NSLocalizedString("Recommend to Friends", comment: "")
        } else if indexPath.row == 3 {
            imageV.image = UIImage(named: "rate")
            title.text = NSLocalizedString("Rate Instant ID Photo", comment: "")
        } else {
            imageV.image = UIImage(named: "about")
            title.text = NSLocalizedString("About", comment: "")
        }
        cell.addSubview(imageV)
        cell.addSubview(title)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}
