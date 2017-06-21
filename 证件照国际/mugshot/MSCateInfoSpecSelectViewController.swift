//
//  MSCateInfoSpecSelectViewController.swift
//  mugshot
//
//  Created by Venpoo on 15/8/22.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class MSCateInfoSpecSelectViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableViewCateInfo: UITableView!
    weak var parent: MSCateInfoViewController!
    var specs: Array<CateInfoSpecModel>!
    var index: NSNumber?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewCateInfo.scrollEnabled = true
        tableViewCateInfo.bounces = false
        //去除多余 cell 的 separator
        tableViewCateInfo.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        //将选择的数据传递到上一层
        if index != nil {
            parent.selectIndex = index
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
            return 43.0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        index = indexPath.section
        tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return specs.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(
                "section", forIndexPath: indexPath)
            cell?.textLabel?.text = specs[indexPath.section].name
            if index == indexPath.section {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell!
    }
}
