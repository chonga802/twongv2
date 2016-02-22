//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Christine Hong on 2/17/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeTimelineCellDelegate, ComposeViewControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        self.performSegueWithIdentifier("signoutSegue", sender: self)
    }
    
    @IBAction func onNew(sender: AnyObject) {
        self.performSegueWithIdentifier("homeToComposeSegue", sender: self)
    }

    var tweets: [Tweet]?
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.getHomeTimeline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHomeTimeline() {
        self.refreshControl?.beginRefreshing()
        
        // grab tweets from home timeline
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func onRefresh() {
        self.getHomeTimeline()
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
                vc.delegate = self
                
            default:
                return
        }
    }
    
    // MARK: HomeTimelineCellDelegate
    
    func reply(homeTimelineCell: HomeTimelineCell) {
        performSegueWithIdentifier("homeToComposeSegue", sender: self)
    }
    
    // MARK: ComposeViewControllerDelegate
    
    func addTweetToTimeline(composeViewController: ComposeViewController) {
        // refresh timeline after tweet created
        self.getHomeTimeline()
    }
    

}
