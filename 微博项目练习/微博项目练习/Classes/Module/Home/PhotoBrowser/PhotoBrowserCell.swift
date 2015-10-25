//
//  PhotoBrowserCell.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/22.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {
    
    //    设置图像
    var imageURL:NSURL? {
        didSet{
                self.indicator.startAnimating()
            
            // 清空图像，解决图像缓存的问题
            imageView.image = nil
            
            resetScrollView()
            
            // 模拟延时
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0)), dispatch_get_main_queue(), {
            self.imageView.sd_setImageWithURL(self.imageURL) { (image, Error , _ , _ ) -> Void in
              
                self.indicator.stopAnimating()

                if image  == nil {
                print("图像加载失败")
                return
                }
                self.setupImagePosition()
            }
        })
    }
}
    private func displaySize(image:UIImage) -> CGSize{
        let scale = image.size.height / image.size.width
        let  h = scale * scrolleView.bounds.width
        return CGSize(width: scrolleView.bounds.width, height: h )
    }
    
    private func setupImagePosition() {
        let size = displaySize(imageView.image!)
        if size.height > bounds.height {
            imageView.frame = CGRect(origin: CGPointZero, size: size )
              scrolleView.contentSize = size
        }else {
            let y = (bounds.height - size .height)*0.5
            imageView.frame = CGRect(origin: CGPointZero, size: size )
            scrolleView.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func resetScrollView() {
        scrolleView.contentInset = UIEdgeInsetsZero
        scrolleView.contentOffset = CGPointZero
        scrolleView.contentSize = CGSizeZero
    }
 
    
        private func setupUI() {
        contentView.addSubview(scrolleView)
        scrolleView.addSubview(imageView)
        contentView.addSubview(indicator)
        
        scrolleView.translatesAutoresizingMaskIntoConstraints = false
        let  dict = ["sv":scrolleView]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
            
        indicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
            
        perpareScrollView()
    }
   private  func perpareScrollView() {
        scrolleView.delegate = self
        scrolleView.minimumZoomScale = 0.5
        scrolleView.maximumZoomScale = 2.0
    }

    private lazy var scrolleView = UIScrollView()
    lazy var imageView = UIImageView()
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
}
extension PhotoBrowserCell:UIScrollViewDelegate {

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    //    缩放结束后图片位置调整
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        var offSetX = (scrollView.bounds.width - (view?.frame.width)!) - 0.5
        offSetX = offSetX < 0 ?  0 : offSetX
        var offSetY = (scrollView.bounds.height - (view?.frame.height)!) - 0.5
        offSetY = offSetY < 0 ? 0 : offSetY
        scrollView.contentInset = UIEdgeInsets(top: offSetY, left: offSetX, bottom: offSetY, right: offSetX)
    }
    // 只要缩放就会调用
    /**
    transform
    a,d     缩放比例
    tx, ty  位移
    a,b,c,d 共同决定旋转
    */
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
  }

}




