//
//  YZRefreshControl.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/20.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit
private let kRefreshoffset:CGFloat = -60.0
class YZRefreshControl: UIRefreshControl {
    // MARK: - 重写结束刷新方法
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stoploading()
    }
    override init (){
    super.init()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
   
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if frame.origin.y > 0 {
        return
        }
        if refreshing {
            refreshView.startloading()
        }

        if frame.origin.y > kRefreshoffset && !refreshView.rotateFlag {
        print("向下翻转")
          refreshView.rotateFlag = true
        
        }
        else if frame.origin.y < kRefreshoffset && refreshView.rotateFlag {
            print("向上翻转")
          refreshView.rotateFlag = false
        }
    }
     func setupUI(){
        
    // KVO 监听属性变化
    addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        
    tintColor = UIColor.clearColor()
        
    addSubview(refreshView)
        
    refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
        
    }
    
    deinit {
    removeObserver(self, forKeyPath: "frame")
    }
    private lazy var refreshView = YZRrefreshView.refreshView()
}


class YZRrefreshView:UIView  {
    //    翻转标记
    private var rotateFlag = false {
        didSet{
        rotateAnim()
        }
    }
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var pullView: UIView!
    @IBOutlet weak var pull: UIImageView!
    class func refreshView() -> YZRrefreshView {
       return  NSBundle.mainBundle().loadNibNamed("YZRefresh", owner: nil, options: nil).last as! YZRrefreshView
    }
    private func rotateAnim(){
    let angle = rotateFlag ? CGFloat(M_PI - 0.01):CGFloat(M_PI + 0.01)
    UIView.animateWithDuration(0.3) { () -> Void in

        self.pull.transform = CGAffineTransformRotate(self.pull.transform, angle)
        }
    }
    private func startloading(){
    if loadingIcon.layer.animationForKey("load") != nil {
        return
    }
    pullView.hidden = true
    let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 1.0
    loadingIcon.layer.addAnimation(anim, forKey:"load")
        
    }
    
    private func stoploading() {
    pullView.hidden = false
    loadingIcon.layer.removeAllAnimations()
    }
}
