//
//  PhotoBrowserViewController.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/22.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit
import SVProgressHUD
private let HMPhotoBrowserViewCell = "HMPhotoBrowserViewCell"

class PhotoBrowserViewController: UIViewController {
    var urls:[NSURL]
    var selectIndex:Int
    
    init(urls:[NSURL],Index:Int) {
        self.urls = urls
        self.selectIndex = Index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urls)
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func save() {
        let indexPath = collectionView.indexPathsForVisibleItems().last!
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoBrowserCell
        guard let image = cell.imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    // 保存到相册完成回调函数
    // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        let msg = (error == nil) ? "保存成功" : "保存失败"
        
        SVProgressHUD.showInfoWithStatus(msg)
    }
    override func loadView() {
        view = UIView(frame: UIScreen.mainScreen().bounds)
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 滚动到用户选中图片
        let indexPath = NSIndexPath(forItem: selectIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let dict = ["cv": collectionView, "save": saveButton, "close": closeButton]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[close(100)]-(>=0)-[save(100)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[close(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[save(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
//        按钮监听方法
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)

        prepareCollectionView()
    }
    private func prepareCollectionView() {
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: HMPhotoBrowserViewCell)
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        
    }
  
// mark:懒加载
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var saveButton: UIButton = UIButton(title: "保存", fontSize: 18, color: UIColor.whiteColor(), backColor: UIColor.darkGrayColor())
     private lazy var closeButton: UIButton = UIButton(title: " 关闭", fontSize: 18, color: UIColor.whiteColor(), backColor: UIColor.darkGrayColor())
  }


extension PhotoBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HMPhotoBrowserViewCell, forIndexPath: indexPath) as! PhotoBrowserCell
        
        cell.backgroundColor = UIColor.randomColor()
        
        cell.imageURL = urls[indexPath.item]
        
        return cell
    }
}
