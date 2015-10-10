//
//  visitorLogView.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/8.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit
protocol visitorLogViewDelegate:NSObjectProtocol{
    func visitorLoginViewWillLogin()
    func visitorLoginViewWillRegister()
}


class visitorLogView: UIView {
    
   weak var delegate:visitorLogViewDelegate?
    
    func clickLogin(){
    print("登录")
    delegate?.visitorLoginViewWillLogin()
    }

    func clickRegister(){
     print("注册")
        delegate?.visitorLoginViewWillRegister()
    }
    
//    设置视图信息
    func setupViewInfo(isHome:Bool,imageName:String,
        message:String){
    messageLabel.text = message
            iconView.image = UIImage(named: imageName)
            homeiconView.hidden = !isHome
            isHome ? startAnimation():sendSubviewToBack(maskiconView)
    }
    private func startAnimation(){
    let anim = CABasicAnimation(keyPath:"transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 20.0
        anim.removedOnCompletion = false
        iconView.layer.addAnimation(anim, forKey: nil)
    }
//    界面初始化
   override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

   required init?(coder aDecoder: NSCoder) {
//       fatalError("init(coder:) has not been implemented")
    super.init(coder:aDecoder)
        setupUI()
   }
    
    
//   设置界面
    private func setupUI(){
//    1.添加控件
        addSubview(iconView)
        addSubview(maskiconView)
        addSubview(homeiconView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
//        2.自动布局
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -60))
        
        homeiconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: homeiconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
         addConstraint(NSLayoutConstraint(item: homeiconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        messageLabel.translatesAutoresizingMaskIntoConstraints
        = false
         addConstraint(NSLayoutConstraint(item:messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
         addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 88))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        
       registerButton.translatesAutoresizingMaskIntoConstraints
            = false
        addConstraint(NSLayoutConstraint(item:registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        loginButton.translatesAutoresizingMaskIntoConstraints
            = false
        addConstraint(NSLayoutConstraint(item:loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        maskiconView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview" :maskiconView]))
        addConstraints (NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-(-35)-[regButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview" :maskiconView,"regButton":registerButton]))
        backgroundColor = UIColor(white: 237.0/255.0, alpha: 1.0)
        
    }
//    懒加载控件
    lazy private var iconView:UIImageView = {
    let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    }()
    
    lazy private var maskiconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
        }()
    lazy private var homeiconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
        }()
    lazy private var messageLabel:UILabel = {
        let label = UILabel()
      label.text = "关注一些人，回这里看看有什么惊喜"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
        }()
    
    lazy private var registerButton:UIButton = {
    let btn = UIButton()
        btn.setTitle("注册", forState:UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "clickRegister", forControlEvents: UIControlEvents.TouchUpInside)
        
    return btn
    }()
    
    lazy private var loginButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", forState:UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "clickLogin", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
        }()
    
  }
