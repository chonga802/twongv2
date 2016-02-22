//
//  TweetCell.swift
//  Twitter
//
//  Created by Christine Hong on 2/19/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = user.name
            usernameLabel.text = "@\(user.screenname!)"
            profPic.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
            //timeLabel?.text = tweet.timeStringSinceCreation
            //tweetLabel?.text = tweet.text
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profPic.layer.cornerRadius = 3
        profPic.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
