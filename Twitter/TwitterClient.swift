//
//  TwitterClient.swift
//  Twitter
//
//  Created by Christine Hong on 2/16/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

// TODO: put into plist for prod
let twitterConsumerKey = "2ZGz1upjF2NMVDOu4qibSkLW7"
let twitterConsumerSecret = "RrPb5OsZxOVYc79Eymy5RfDVDVQW9WoG1t2zn3Wh3NfpV3reDk"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

// Singleton
class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient{
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params,
        success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        },
        failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func postStatus(tweetMsg: String) {
        let params = ["status": tweetMsg]
        
        POST("1.1/statuses/update.json", parameters: params,
        success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Posted status: \(tweetMsg)")
        },
        failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error)
        })
    }
    
    func favorite(tweetId: Int) {
        print("tweetId:")
        print(tweetId)
        let params = ["id": tweetId]
        
        POST("1.1/favorites/create.json", parameters: params,
        success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Favorited tweet: \(tweetId)")
        },
        failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Favorite tweet error")
            print(error)
        })
    }
    
    func unfavorite(tweetId: Int) {
        print("tweetId:")
        print(tweetId)
        let params = ["id": tweetId]
        
        POST("1.1/favorites/destroy.json", parameters: params,
        success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Unfavorited tweet: \(tweetId)")
        },
        failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Unfavorite tweet error")
            print(error)
        })
    }
    
    func retweet(tweetId: Int) {
        let params = ["id": tweetId]
        
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: params,
        success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Retweeted")
        },
        failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error)
        })
    }

    func unretweet(tweetId: Int) {
        let params = ["id": tweetId]
        
        POST("1.1/statuses/unretweet/\(tweetId).json", parameters: params,
        success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Unretweeted")
        },
        failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "Christinetwitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
        success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("got the access token!")
            
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.GET("1.1/account/verify_credentials.json", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary) // enters init function
                User.currentUser = user
                print("user: \(user.name))")
                self.loginCompletion?(user: user, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting current user")
                self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error: NSError!) -> Void in
            print("Failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
}
