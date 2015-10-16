//
//  BaseTableViewController.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/8.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,visitorLogViewDelegate {

    var userLogin = UserAccount.userLogon
//    var userLogon =
    var visitorView: visitorLogView?
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }
    private func setupVisitorView(){
        
        visitorView = visitorLogView()
        visitorView?.delegate = self
        view = visitorView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorLoginViewWillLogin")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorLoginViewWillRegister")
        
    }
    
    func visitorLoginViewWillLogin() {
     
        let nav = UINavigationController(rootViewController: OAuthViewController())
        presentViewController(nav, animated: true, completion: nil)
    }
    func visitorLoginViewWillRegister() {
        print("注册")
    }
    

}