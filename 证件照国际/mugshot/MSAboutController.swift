//
//  MSAboutController.swift
//  mugshot
//
//  Created by dexter on 15/5/24.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

import UIKit

class MSAboutController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        //双行按钮
        urlBtn.titleLabel!.lineBreakMode = .ByWordWrapping
        urlBtn.titleLabel!.textAlignment = .Center

        let titleStr = NSBundle.mainBundle().infoDictionary!["CFBundleDisplayName"]
        let versionStr = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        titleLabel.text = "\(titleStr!) V\(versionStr!)"

        //tableview 设定
        tableView.scrollEnabled = true
        tableView.bounces = false
    }

    deinit {
        tableView?.delegate = nil
    }

    @IBAction func openUrl(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.camcap.us/mobile/")!)
    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let reuseID = "open\(indexPath.row)\(indexPath.section)"
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier(reuseID)
        if cell == nil {
            let black = UIColor(white: 34 / 255.0, alpha: 1)
            let font = UIFont.systemFontOfSize(16)
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: reuseID)
            cell.textLabel!.text = NSLocalizedString("Intro", comment: "")
            cell.textLabel!.textColor = black
            cell.detailTextLabel?.textColor = black
            cell.textLabel!.font = font
            cell.detailTextLabel?.font = font
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        if indexPath.row == 0 {
            //回到欢迎页
            let open = DEXOpenController()
            navigationController!.pushViewController(open, animated: true)
        }
    }
}
