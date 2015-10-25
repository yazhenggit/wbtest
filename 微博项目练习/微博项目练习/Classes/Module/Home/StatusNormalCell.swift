//
//  StatusNormalCell.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/17.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit

class StatusNormalCell: StatusCell {
    override func setupUI() {
        super.setupUI()
        //3》 配图视图
                let cons =  pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: statusCellControlMargin))
                pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
                pictureHightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
    }
}
