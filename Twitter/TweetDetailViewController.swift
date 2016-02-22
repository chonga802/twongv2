//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Christine Hong on 2/21/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetNum: UILabel!
    @IBOutlet weak var favoriteNum: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var tweet: Tweet?
    
    @IBAction func returnHome(sender: AnyObject) {
        performSegueWithIdentifier("detailToHomeSegue", sender: self)
    }

    @IBAction func navOnReply(sender: AnyObject) {
        performSegueWithIdentifier("detailToComposeSegue", sender: self)
    }

    @IBAction func onReply(sender: AnyObject) {
        performSegueWithIdentifier("detailToComposeSegue", sender: self)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        self.tweet?.retweetAction()
        retweetButton.selected = (self.tweet?.isRetweeted)!
        retweetNum?.text = "\(tweet!.retweetCount)"
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        self.tweet?.favoriteAction()
        favoriteButton.selected = (self.tweet?.isFavorited)!
        favoriteNum?.text = "\(tweet!.favoriteCount)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.replyButton.setBackgroundImage(UIImage(named: "reply") as UIImage?, forState: .Normal)
        self.retweetButton.setBackgroundImage(UIImage(named: "retweet") as UIImage?, forState: .Normal)
        self.retweetButton.setBackgroundImage(UIImage(named: "retweet_selected") as UIImage?, forState: .Selected)
        self.favoriteButton.setBackgroundImage(UIImage(named: "favorite") as UIImage?, forState: .Normal)
        self.favoriteButton.setBackgroundImage(UIImage(named: "favorite_selected") as UIImage?, forState: .Selected)
        
        makeTweet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeTweet() {
        if tweet != nil {
            let user = tweet!.user!
            nameLabel?.text = user.name
            profPic?.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
            usernameLabel?.text = "@\(user.screenname!)"
            tweetLabel?.text = tweet!.text
            timeLabel?.text = tweet!.createdAtDetailDisplay
            retweetNum?.text = "\(tweet!.retweetCount)"
            favoriteNum?.text = "\(tweet!.favoriteCount)"
            
            retweetButton?.selected = tweet!.isRetweeted!
            favoriteButton?.selected = tweet!.isFavorited!
        }
    }
    
    func makeTweetCell(tweet: Tweet) {
        self.tweet = tweet
        makeTweet()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "detailToComposeSegue":
                let vc = segue.destinationViewController as! ComposeViewController
                vc.setTweet(self.tweet)
                
            default:
                return
        }
    }


}
