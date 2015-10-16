//
//  NewFeatureCollectionViewController.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/13.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewFeatureCollectionViewController: UICollectionViewController {
//   图像总数
    let imageCount = 4
    private let layout = BJFlowLayout()
    init() {
        super.init(collectionViewLayout:layout)
    }
    required init(coder aDecoder:NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
//    mark: 数据源
//    获取数据源
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        cell.imageIndex = indexPath.item
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let path = collectionView.indexPathsForVisibleItems().last!
        if path.item == imageCount - 1{
        let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeatureCell
            cell.startButtonAnim()
        }
    }
}
//定义 cell
class NewFeatureCell:UICollectionViewCell{
    
    private var imageIndex: Int = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
                        startButton.hidden = true
//            startButtonAnim()
        }
    }
    
    func clickButton() {
    NSNotificationCenter.defaultCenter().postNotificationName(SBRootViewControllerSwitchNotification, object: true)
    }
//    按钮动画
    private func startButtonAnim(){
        startButton.hidden = false
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        startButton.userInteractionEnabled = false
        UIView.animateWithDuration(3.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            })  { (_) -> Void in
                self.startButton.userInteractionEnabled = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func prepareUI(){
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        //        自动布局
        iconView.ff_Fill(contentView)
        startButton.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    // mark: 懒加载控件
    private  lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        button.setTitle("开始体验", forState: UIControlState.Normal)
        // 根据背景图片自动调整大小
        button.sizeToFit()
        
        // 提示: 按钮的隐藏属性会因为复用工作不正常
        button.hidden = true
        
        button.addTarget(self, action: "clickButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
}
//自定义流水布局

private class BJFlowLayout:UICollectionViewFlowLayout{
    private override func prepareLayout() {
        itemSize = (collectionView?.bounds.size)!
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
    }
}