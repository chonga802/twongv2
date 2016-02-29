//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Christine Hong on 2/17/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

enum TimelineType {
    case Home, Mentions
}

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeTimelineCellDelegate, ComposeViewControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        self.performSegueWithIdentifier("signoutSegue", sender: self)
    }
    
    @IBAction func onNew(sender: AnyObject) {
        self.performSegueWithIdentifier("homeToComposeSegue", sender: self)
    }
    
    @IBAction func tapProfPic(sender: UITapGestureRecognizer) {
         tableView.allowsSelection = false
         performSegueWithIdentifier("homeToProfileSegue", sender: self)
    }
    
    var tweets: [Tweet]?
    var selectedTweet: Tweet?
    private var refreshControl: UIRefreshControl!
    private var timelineType = TimelineType.Home
    
    override func viewDidLoad() {
        print("VIEW DID LOAD")
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        navBar.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 1.0)
//        navBar.tintColor = UIColor.whiteColor()
//        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.getTimeline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTimeline() {
        print("GETTING TIMELINE")
        self.refreshControl?.beginRefreshing()
        let completion = {(tweets: [Tweet]?, error: NSError?) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        
        switch timelineType {
            case .Home:
                print("IN HOME TIMELINE")
                TwitterClient.sharedInstance.homeTimeline(completion)
                self.navigationItem.title = "Home"
                
            case .Mentions:
                print("IN MENTIONS TIMELINE")
                TwitterClient.sharedInstance.mentionsTimeline(completion)
                self.navigationItem.title = "Mentions"
        }
    }
    
    func onRefresh() {
        self.getTimeline()
    }
    
    func setTimelineType(timelineType: TimelineType) {
        self.timelineType = timelineType
    }
    
    // MARK: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTimelineCell", forIndexPath: indexPath) as! HomeTimelineCell
        cell.delegate = self
        cell.tweet = tweets![indexPath.row]
        if let tweet = self.tweets?[indexPath.row] {
            cell.makeTweetCell(tweet)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("homeToDetailSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
            case "homeToDetailSegue":
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let vc = segue.destinationViewController as! TweetDetailViewController
                    vc.makeTweetCell(self.tweets![indexPath.row])
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
                }
                
            case "homeToComposeSegue":
                let vc = segue.destinationViewController as! ComposeViewController
                vc.setTweet(self.selectedTweet)
            
            case "homeToProfileSegue":
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let vc = segue.destinationViewController as! ProfileViewController
                    vc.setUser(self.tweets![indexPath.row].user)
                }
            
            default:
                return
        }
    }
    
    // MARK: HomeTimelineCellDelegate
    
    func reply(homeTimelineCell: HomeTimelineCell, tweet: Tweet?) {
        self.selectedTweet = tweet
        performSegueWithIdentifier("homeToComposeSegue", sender: self)
    }
    
    // MARK: ComposeViewControllerDelegate
    
    func addTweetToTimeline(composeViewController: ComposeViewController) {
        // refresh timeline after tweet created
        self.getTimeline()
    }
    

}
