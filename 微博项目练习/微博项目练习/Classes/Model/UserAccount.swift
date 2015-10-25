//
//  UserAccount.swift
//  微博项目练习
//
//  Created by 王亚征 on 15/10/11.
//  Copyright © 2015年 yazheng. All rights reserved.
//

import UIKit

class UserAccount: NSObject ,NSCoding {
    /// 用户是否登录标记
    class var userLogon: Bool {
        return loadAccount != nil
    }
    
    var access_token:String?
    var expires_in:NSTimeInterval = 0 {
        didSet{
            expiresDate = NSDate(timeIntervalSinceNow:expires_in)
        
        }
    }
    var expiresDate : NSDate?
    var uid:String?
    var name:String?
    var avatar_large:String?
    
    init(dict: [String:AnyObject]){
        super.init()
    setValuesForKeysWithDictionary(dict)
        UserAccount.userAccount = self
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    override var description: String {
        let properties = ["access_token", "expires_in", "uid","expiresDate","name","avatar_large"]
        return "\(dictionaryWithValuesForKeys(properties))"
    }
    //    mark: 加载用户信息
    func loadUserInfo(finished:(error:NSError?) ->()){
    NetworkTools.sharedTools.loadUserInfo(uid!) { (result, error) -> () in
        if error != nil || result == nil{
            finished(error: error)
        return
        }
        self.name = result!["name"] as? String
        self.avatar_large = result!["avatar_larage"] as? String
        
        self.saveAccount()
        finished(error: nil)
//        print(self)
        
        }
    }
//    定义归档路径
   static private let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("account.plist")
//    保存账号信息
    func saveAccount(){
    NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
//    静态用户账户属性
   private static var userAccount: UserAccount?
    class  var loadAccount: UserAccount? {
        if userAccount == nil {
        userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as?
            UserAccount
        }
//        判断日期
        if let date = userAccount?.expiresDate where date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            userAccount = nil
        }
        return userAccount
    }
//    mark: 归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    //    mark: 解  档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        
    }
    
    
}
