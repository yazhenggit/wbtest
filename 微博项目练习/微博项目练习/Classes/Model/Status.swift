//
//  Status.swift
//  我的微博
//
//  Created by teacher on 15/8/1.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// 微博模型
class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?{
        didSet {
            // 判断数组中是否有数据 nil
            if pic_urls!.count == 0 {
                return
            }
            
            // 实例化数组
            storedPictureURLs = [NSURL]()
            storedLargePictureURLs = [NSURL]()
            // 遍历字典生成 url 的数组
            for dict in pic_urls! {
                if let urlString = dict["thumbnail_pic"] as? String {
                    storedPictureURLs?.append(NSURL(string: urlString)!)
                    let largeURLstring = urlString.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    storedLargePictureURLs?.append(NSURL(string: largeURLstring)!)
                }
            }
        }

    }
    
    //    保存大图
    private var storedLargePictureURLs:[NSURL]?
    var picturelargeURLs:[NSURL] {
        return retweeted_status == nil ? storedLargePictureURLs! : (retweeted_status?.storedLargePictureURLs)!
    }
    // `保存`配图的 URL 的数组
    private var storedPictureURLs: [NSURL]?
    /// 配图的URL的数组
    var pictureURLs: [NSURL]?  {
        return retweeted_status == nil ? storedPictureURLs : retweeted_status?.storedPictureURLs
    }

    
    //    返回的行高
    var rowHight:CGFloat?

    /// 用户
    var user: User?
    
    //  转发微博
    var retweeted_status:Status?
    
    /// 加载微博数据 - 返回`微博`数据的数组
    class func loadStatus(since_id: Int, max_id: Int,finished: (dataList: [Status]?, error: NSError?) -> ()) {
        
        NetworkTools.sharedTools.loadStatuses(since_id, max_id: max_id) { (result, error) -> () in
            
            if error != nil {
                finished(dataList: nil, error: error)
                return
            }
            
            /// 判断能否获得字典数组
            if let array = result?["statuses"] as? [[String: AnyObject]] {
                // 遍历数组，字典转模型
                var list = [Status]()
                
                for dict in array {
                    list.append(Status(dict: dict))
                }
                
                // 获得完整的微博数组，可以回调
                finished(dataList: list, error: nil)
            } else {
                finished(dataList: nil, error: nil)
            }
        }
    }
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        
        // 会调用 setValue forKey 给每一个属性赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        // 判断 key 是否是 user，如果是 user 单独处理
        if key == "user" {
            // 判断 value 是否是一个有效的字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                user = User(dict: dict)
            }
            return
        }
        if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                // 创建转发微博数据
                retweeted_status = Status(dict: dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["created_at", "id", "text", "source", "pic_urls"]
        
        return "\(dictionaryWithValuesForKeys(keys))"
    }
    
}
