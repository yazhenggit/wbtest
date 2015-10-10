//
//  BaseTableViewController.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/8.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,visitorLogViewDelegate {

    var userLogon = false
    var visitorView: visitorLogView?
    
    override func loadView() {
        userLogon ? super.loadView() : setupVisitorView()
    }
    private func setupVisitorView(){
        
        visitorView = visitorLogView()
        visitorView?.delegate = self
        view = visitorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorLoginViewWillLogin")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorLoginViewWillRegister")
        
    }
    
    func visitorLoginViewWillLogin() {
        print("登录")
    }
    func visitorLoginViewWillRegister() {
        print("注册")
    }
    

}