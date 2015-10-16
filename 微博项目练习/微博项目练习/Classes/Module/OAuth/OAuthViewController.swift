//
//  OAuthViewController.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/10.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController ,UIWebViewDelegate{
    //        搭建界面
    private lazy var webView = UIWebView()
    override func loadView() {
        view = webView
        webView.delegate = self
        
        title = "小公主"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style:  UIBarButtonItemStyle.Plain, target: self, action: "close")
    }
    
//    mark: UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL!.absoluteString
        if !urlString.hasPrefix(NetworkTools.sharedTools.redirectUri){
        return true
        }
        print(request.URL?.query)
        if let query = request.URL?.query where query.hasPrefix("code="){
            print("获取授权码")
//        从 query 中截取授权码
        let code = query.substringFromIndex("code=".endIndex)
        print(code)
//            TODO: 获取 token
            loadAccessToken(code)
        }else{
        close()
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(NSURLRequest(URL: NetworkTools.sharedTools.oauthUrl()))
//        view.backgroundColor = UIColor.orangeColor()

        
    }
    
    func close(){
        SVProgressHUD.dismiss()
    dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    private func loadAccessToken(code:String){
    NetworkTools.sharedTools.loadAccessToken(code) { (result, error) -> () in
        if error != nil || result == nil {
       self.netError()
            return
        }
        //    字典转模型
         UserAccount(dict: result!).loadUserInfo({ (error) -> () in
            if error != nil {
            self.netError()
            return
            }
            // 发送通知切换视图控制器
            NSNotificationCenter.defaultCenter().postNotificationName(SBRootViewControllerSwitchNotification, object: false)
            
            // 关闭控制器（单独讲）Modal 出来的控制器，一定注意需要 dismiss!
            self.close()

         })
        
        }
    }
    private func netError(){
        SVProgressHUD.showInfoWithStatus("哇！网路连接不上了....")
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
        dispatch_after(when, dispatch_get_main_queue(), { () -> Void in
            self.close()
        })
    }
}
