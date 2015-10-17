//
//  HomeTableViewController.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/7.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit


class HomeTableViewController: BaseTableViewController {

    // 微博数据数组
    private var statuses: [Status]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccount.userLogon {
            visitorView?.setupViewInfo(true, imageName: "visitordiscover_feed_image_smallicon", message: "你以为点击发现，就会知道陈凯是谁？")
            return
        }
        print(view)
        prepareTableView()
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadData()

        
    }
    /// 准备表格视图
    private func prepareTableView() {
        // 注册原型 cell
        tableView.registerClass(StatusForwardCell.self, forCellReuseIdentifier: "Cell")
//        // 设置表格的预估行高(方便表格提前计算预估行高，提高性能)
//        tableView.estimatedRowHeight = 600
//        // 设置表格自动计算行高
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 300
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    private func loadData() {
        Status.loadStatus() { [weak self] (datalist, error) -> () in
            if error != nil {
                //                SVProgressHUD.showInfoWithStatus("您的网络不给力")
                print(error)
                return
            }
            self?.statuses = datalist
        }
    }
    
    // MARK: 表格数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? StatusForwardCell
        
        cell!.status = statuses![indexPath.row]
        
        return cell!
    }
    /// 返回行高 － 如果是固定值，可以直接通过属性设置，效率更高
    /**
    行高缓存
    1. NSCache - 内存缓存，iOS 8.0 有 bug，千万不要 removeAll，一旦 removeAll 之后，再也没法使用了
    SDWebImage 存在什么问题
    1> 接收到内存警告后，内存缓存实效
    2> 加载 GIF 的时候，内存会狂飙！
    2. 自定义行高`缓存字典`
    3. 直接利用微博的`模型`
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 判断模型中，是否已经缓存了行高
        // 1. 获取模型
        let status = statuses![indexPath.row]
        if let h = status.rowHight {
            return h
        }
        
        // 1. 获取 cell - dequeueReusableCellWithIdentifier 带 indexPath 的函数会调用计算行高的方法
        // 会造成死循环，在不同版本的 Xcode 中 行高的计算次数不一样！尽量要优化！
        // 如果不做处理，会非常消耗性能！
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? StatusCell
        
        
        // 3. 返回计算的行高
        status.rowHight = cell!.rowHeight(status)
        
        return status.rowHight!
    }

}