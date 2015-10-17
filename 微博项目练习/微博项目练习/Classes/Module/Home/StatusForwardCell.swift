//
//  StatusForwardCell.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/16.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit

class StatusForwardCell: StatusCell {
    override var status: Status? {
        didSet {
            let userName = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            
            forwardLabel.text = userName + ":" + text
        }
    }
    // MARK: - 设置 UI
    override func setupUI() {
        super.setupUI()
        
        // 1. 添加控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: backButton)
        forwardLabel.text = "dasdfsdf"
        // 2. 自动布局
        // 1>背景按钮
        backButton.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -statusCellControlMargin, y: statusCellControlMargin))
        backButton.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
        // 2> 转发文字
        forwardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: backButton, size: nil, offset: CGPoint(x: statusCellControlMargin, y: statusCellControlMargin))
        contentView.addConstraint(NSLayoutConstraint(item: forwardLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -2 * statusCellControlMargin))
        //  3> 配图视图
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 90), offset: CGPoint(x: 0, y: statusCellControlMargin))
        pictureTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    // MARK: - 懒加载控件
/// 背景按钮
private lazy var backButton: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    
    return btn
    }()
/// 转发文字
/// 转发文字
private lazy var forwardLabel: UILabel = {
    let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
    label.numberOfLines = 0
    
    return label
    }()
}