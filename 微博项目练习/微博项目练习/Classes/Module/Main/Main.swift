//
//  Main.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/7.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit

class Main: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewControllers()
    }
    func clickComposedButton() {
//        print(__FUNCTION__)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupComposeButton()
        
    }
//    设置撰写按钮位置
    
    private func setupComposeButton(){
    let w = tabBar.bounds.width / CGFloat((viewControllers?.count)!)
        let rect = CGRect(x: 0, y: 0, width: w , height: tabBar.bounds.height)
        composeButton.frame = CGRectOffset(rect, 2 * w, 0)
    
    }
    private func addChildViewControllers() {
    addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(UIViewController())
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    
    private func addChildViewController(vc:UIViewController,title:String,imageName:String)
    {
//        tabBar.tintColor = UIColor.orangeColor()

        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        let nav = UINavigationController(rootViewController: vc)
        addChildViewController(nav)
        
    }
    
    private lazy var composeButton:UIButton = {
    let button = UIButton ()
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        self.tabBar.addSubview(button)
        button.addTarget(self, action: "clickComposedButton", forControlEvents: UIControlEvents.TouchUpInside)
      
        return button
    }()
    
}
