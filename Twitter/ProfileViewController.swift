//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Christine Hong on 2/26/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeTimelineCellDelegate {
    private var user: User? = User.currentUser
    private var tweets: [Tweet]?
    var selectedTweet: Tweet?
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profPhoto: UIImageView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetNum: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followerNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("USER id:")
        print(self.user!.id!)
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        
        getUserTweets()
    }
    
    func setProfile() {
        if let user = self.user {
            print("SETTING PROFILE")
            print(self.user?.name)
            self.nameLabel.text = user.name
            self.usernameLabel.text = user.screenname
            self.tweetNum.text = String(user.tweetNum ?? 0)
            self.followingNum.text = String(user.followingNum ?? 0)
            self.followerNum.text = String(user.followerNum ?? 0)
            if let profImage = user.profileImageUrl {
                print("USER profile image url :")
                print(profImage)
                self.profPhoto.setImageWithURL(NSURL(string: profImage)!)
            }
            if let coverImage = user.coverImageUrl {
                print("USER cover image url :")
                print(coverImage)
                self.coverPhoto.setImageWithURL(NSURL(string: coverImage)!)
            }
        }
    }
    
    func setUser(u: User){
        print("SETTING USER")
        self.user = u
        getUserTweets()
    }
    
    func getUserTweets() {
        if let userID = self.user?.id {
            print("GETTING USER TWEETS")
            self.refreshControl?.beginRefreshing()
            let completion = {(tweets: [Tweet]?, error: NSError?) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                self.setProfile()
                self.refreshControl?.endRefreshing()
            }
            
            TwitterClient.sharedInstance.userTimeline(userID, completion: completion)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! HomeTimelineCell
        cell.delegate = self
        cell.tweet = self.tweets![indexPath.row]
        print("TWEET:")
        print(cell.tweet)
        if let tweet = self.tweets?[indexPath.row] {
            cell.makeTweetCell(tweet)
        }
        return cell
    }
    
    // MARK: HomeTimelineCellDelegate
    
    func reply(homeTimelineCell: HomeTimelineCell, tweet: Tweet?) {
        self.selectedTweet = tweet
        performSegueWithIdentifier("homeToComposeSegue", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
            case "profileToHomeSegue":
                let vc = segue.destinationViewController as! MenuViewController
                vc.setVcType(VCType.Home)
            
            case "homeToComposeSegue":
                let vc = segue.destinationViewController as! ComposeViewController
                vc.setTweet(self.selectedTweet)

            default:
                return
        }
    }
    

}
