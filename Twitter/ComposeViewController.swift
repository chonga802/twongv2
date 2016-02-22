//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Christine Hong on 2/21/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate : class {
    func addTweetToTimeline(composeViewController: ComposeViewController)
}

class ComposeViewController: UIViewController {
    
    weak var delegate: ComposeViewControllerDelegate?
    private var tweet: Tweet?
    private var destUser: User?

    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var newTweet: UITextField!
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        var statusId: Int? = nil
        if let destUser = self.destUser {
            statusId = destUser.id!
        }
        TwitterClient.sharedInstance.postStatus(newTweet.text!, statusId:  statusId)
        self.delegate?.addTweetToTimeline(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        profPic.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!)!)
        nameLabel.text = User.currentUser!.name
        usernameLabel.text = "@\(User.currentUser!.screenname!)"
        newTweet.contentVerticalAlignment = .Top;
        if let tweet = self.tweet {
            if let user = tweet.user {
                self.destUser = user
                if let screenname = self.destUser!.screenname {
                    newTweet.text = "@\(screenname)"
                }
            }
        }
    }
    
    func setTweet(tweet: Tweet?){
        self.tweet = tweet
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
