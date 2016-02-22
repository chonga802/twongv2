//
//  Tweet.swift
//  Twitter
//
//  Created by Christine Hong on 2/16/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var id: Int?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var createdAtDisplay: String?
     var createdAtDetailDisplay: String?
    var favoritesCount: Int
    var retweetCount: Int
    var isRetweeted: Bool?
    var isFavorited: Bool?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: (dictionary["user"] as! NSDictionary))
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        createdAtDisplay = createdAt?.getElapsedInterval(createdAt!)
        
        formatter.dateFormat = "MM/dd/YY, HH:mm a"
        createdAtDetailDisplay = formatter.stringFromDate(createdAt!)
        
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        if let retweeted = dictionary["retweeted"] as? Int {
            isRetweeted = (retweeted == 1)
        }
        
        if let favorited = dictionary["favorited"] as? Int {
            isFavorited = (favorited == 1)
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    func favoriteAction() {
        let status = self.isFavorited!
        if status {
            self.unfavorite()
        } else {
            self.favorite()
        }
    }
    
    func retweetAction() {
        let status = self.isRetweeted!
        if status {
            self.unretweet()
        } else {
            self.retweet()
        }
    }
    
    private func favorite() {
        print("favoriting")
        TwitterClient.sharedInstance.favorite(id!)
        favoritesCount += 1
        isFavorited = true
    }
    
    private func unfavorite() {
        print("unfavoriting")
        TwitterClient.sharedInstance.unfavorite(id!)
        favoritesCount -= 1
        isFavorited = false
    }
    
    private func retweet() {
        print("retweeting")
        TwitterClient.sharedInstance.retweet(id!)
        retweetCount += 1
        isRetweeted = true
    }
    
    private func unretweet() {
        print("unretweeting")
        TwitterClient.sharedInstance.unretweet(id!)
        retweetCount -= 1
        isRetweeted = false
    }
}

extension NSDate {
    
    func getElapsedInterval(createdAt: NSDate) -> String {
        
        var interval = NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "y" :
                "\(interval)" + "y"
        }
        
        interval = NSCalendar.currentCalendar().components(.Month, fromDate: self, toDate: NSDate(), options: []).month
        if interval > 0 {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.stringFromDate(createdAt)
        }
        
        interval = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).day
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "d" :
                "\(interval)" + "d"
        }
        
        interval = NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: NSDate(), options: []).hour
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "h" :
                "\(interval)" + "h"
        }
        
        interval = NSCalendar.currentCalendar().components(.Minute, fromDate: self, toDate: NSDate(), options: []).minute
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "m" :
                "\(interval)" + "m"
        }
        
        interval = NSCalendar.currentCalendar().components(.Second, fromDate: self, toDate: NSDate(), options: []).second
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "s" :
                "\(interval)" + "s"
        }
        
        return "Just now"
    }
}
