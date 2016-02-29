//
//  HomeTimelineCell.swift
//  Twitter
//
//  Created by Christine Hong on 2/19/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

protocol HomeTimelineCellDelegate : class {
    func reply(homeTimelineCell: HomeTimelineCell, tweet: Tweet?)
}

class HomeTimelineCell: UITableViewCell {
    var tweet: Tweet?
    weak var delegate: HomeTimelineCellDelegate?

    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func onReply(sender: AnyObject) {
        self.delegate?.reply(self, tweet: self.tweet)
    }
    @IBAction func onRetweet(sender: AnyObject) {
        self.tweet?.retweetAction()
        retweetButton.selected = (tweet?.isRetweeted)!
    }
    @IBAction func onFavorite(sender: AnyObject) {
        self.tweet?.favoriteAction()
        favoriteButton.selected = (tweet?.isFavorited)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profPic.layer.cornerRadius = 3
        profPic.clipsToBounds = true
        
        replyButton.setBackgroundImage(UIImage(named: "reply") as UIImage?, forState: .Normal)
        retweetButton.setBackgroundImage(UIImage(named: "retweet") as UIImage?, forState: .Normal)
        retweetButton.setBackgroundImage(UIImage(named: "retweet_selected") as UIImage?, forState: .Selected)
        favoriteButton.setBackgroundImage(UIImage(named: "favorite") as UIImage?, forState: .Normal)
        favoriteButton.setBackgroundImage(UIImage(named: "favorite_selected") as UIImage?, forState: .Selected)
        
        makeTweet()
    }
    
    func makeTweet() {
        if let tweet = self.tweet {
            let user = tweet.user
            nameLabel.text = user!.name
            usernameLabel.text = "@\(user!.screenname!)"
            profPic.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
//            let profPicTap = UITapGestureRecognizer(target: self, action:Selector("profPicTap:"))
//            profPic.addGestureRecognizer(profPicTap)
            profPic.userInteractionEnabled = true
            timeLabel.text = tweet.createdAtDisplay
            tweetLabel.text = tweet.text
            
            retweetButton.selected = tweet.isRetweeted!
            favoriteButton.selected = tweet.isFavorited!
        }
    }
    
    func makeTweetCell(tweet: Tweet) {
        self.tweet = tweet
        makeTweet()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
