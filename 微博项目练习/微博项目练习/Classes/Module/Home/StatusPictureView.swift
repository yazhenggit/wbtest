//
//  StatusPictureView.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/15.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit
// 选中照片通知
let HMStatusPictureViewSelectedNotification = "HMStatusPictureViewSelectedNotification"
/// 选中照片索引
let HMStatusPictureViewSelectedIndexKey = "HMStatusPictureViewSelectedIndexKey"
/// 选中照片 URL 数组
let HMStatusPictureViewSelectedURLsKey = "HMStatusPictureViewSelectedURLsKey"
// 可重用 cell 标示符
private let statusPictureViewCellID = "statusPictureViewCellID"

class StatusPictureView: UICollectionView {
    var status:Status? {
    didSet {
        sizeToFit()
        // 刷新视图
        reloadData()
        }
    }
        override func sizeThatFits(size: CGSize) -> CGSize {
        return calculatePictureViewSize()
        }
    
//    计算视图大小
    private func calculatePictureViewSize() -> CGSize {
    let itemSize = CGSize(width: 90, height: 90)
    let margin:CGFloat = 10
    let rowCount = 3
    
    picturelaout.itemSize = itemSize
    
//    根据图片计算视图大小
        let count = status?.pictureURLs?.count ?? 0
        if count == 0{
        return CGSizeZero
        }
        if count == 1 {
        let size = CGSize(width: 150, height: 120)
            picturelaout.itemSize = size
            return size
        }
        if count == 4 {
        let wSize = itemSize.width * 2 + 10
            return CGSize(width: wSize, height: wSize)
        }
        let row = (count - 1)/rowCount + 1
        let w = itemSize.width * CGFloat(rowCount) + margin * CGFloat(rowCount - 1)
        let h = itemSize.height * CGFloat(row) + margin * CGFloat(row - 1)

        return CGSize(width: w , height: h)
    }
    private let picturelaout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: picturelaout)
        backgroundColor = UIColor.lightGrayColor()
        // 注册可重用 cell
        registerClass(StatusPictureViewCell.self, forCellWithReuseIdentifier: statusPictureViewCellID)
        //  设置代理，自己当自己的数据源
        self.dataSource = self
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// 在 swift 中，协议同样可以通过 extension 来写，可以将一组协议方法，放置在一起，便于代码维护和阅读！

extension StatusPictureView:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            print(indexPath)
        NSNotificationCenter.defaultCenter().postNotificationName(HMStatusPictureViewSelectedNotification, object: self, userInfo:[HMStatusPictureViewSelectedIndexKey:indexPath,HMStatusPictureViewSelectedURLsKey:status!.picturelargeURLs])
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(statusPictureViewCellID, forIndexPath: indexPath) as! StatusPictureViewCell
        
        cell.imageURL =  status!.pictureURLs![indexPath.item]
        
        return cell
    }

}

class StatusPictureViewCell: UICollectionViewCell {
    
    var imageURL: NSURL? {
        didSet {
            iconView.sd_setImageWithURL(imageURL!)
            gifImageView.hidden = ((imageURL!.absoluteString as NSString).pathExtension.lowercaseString != "gif")
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        iconView.addSubview(gifImageView)
        
        iconView.ff_Fill(contentView)
        gifImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: nil)
    }
    
    // MARK: 懒加载控件
    private lazy var iconView: UIImageView = UIImageView()
    private lazy var gifImageView: UIImageView = {
         let iv = UIImageView(image: UIImage(named: "timeline_image_gif"))
        return iv
    }()
}
