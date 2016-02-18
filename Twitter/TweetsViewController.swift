//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Christine Hong on 2/17/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    var tweets: [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
        }
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
