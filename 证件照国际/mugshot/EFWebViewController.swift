//
//  EFWebViewController.swift
//  mugshot
//
//  Created by Venpoo on 15/9/12.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class EFWebViewController: UIViewController, UIWebViewDelegate {

    private var webView: UIWebView!
    var urlString: String!
    //网页自动缩放
    var autoScale: Bool = false

    static func createWithURL(url: String, title: String, autoScale: Bool = false)
        -> EFWebViewController {
        let rtn = EFWebViewController()
        rtn.urlString = url
        rtn.navigationItem.title = title
        rtn.autoScale = autoScale
        return rtn
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView(
            frame:CGRect(
                x: 0,
                y: 0,
                width: self.view.frame.width,
                height: self.view.frame.height - MSAfx.getHeightStatusBar()
                    - MSAfx.getHeightNavigationBar(self)
            )
        )
        webView.delegate = self
        webView.scalesPageToFit = autoScale
        webView.scrollView.bounces = false
        webView.scrollView.scrollEnabled = true
        self.view.addSubview(webView)
        loadPage()
    }

    //析构函数
    deinit {
        webView.delegate = nil
        MSAfx.loadingView.Hide(nil)
    }

    private func loadPage() {
        if let URL = NSURL(string: urlString) {
            webView.loadRequest(NSURLRequest(URL: URL))
        }
    }

    func webViewDidStartLoad(webView: UIWebView) {
        MSAfx.loadingView.ShowAt(self, withString: NSLocalizedString("Loading...", comment: ""))
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        MSAfx.loadingView.Hide(nil)
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MSAfx.loadingView.Hide(NSLocalizedString("Loading failed, please try again", comment: ""))
    }
}
