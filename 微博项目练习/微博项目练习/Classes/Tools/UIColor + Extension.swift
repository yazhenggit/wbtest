//
//  UIColor + Extension.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/22.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit

extension UIColor
{
    
    /// 随机颜色
    class func randomColor() -> UIColor {
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1.0)
    }
    
    private class func randomValue() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / 256
    }
}