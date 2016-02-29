//
//  MenuViewController.swift
//  Twitter
//
//  Created by Christine Hong on 2/27/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

enum VCType {
    case Home, Profile, Mentions, Compose, Details
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UITableView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    
    private var homeTimelineViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    private var composeViewController: UIViewController!
    private var detailsViewController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var vcType : VCType = VCType.Home
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            UIView.animateWithDuration(0.3) { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.dataSource = self
        menuView.delegate = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        homeTimelineViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTimelineViewController")
        let homeVC = homeTimelineViewController as! HomeTimelineViewController
        homeVC.setTimelineType(TimelineType.Home)
        homeVC.getTimeline()
        
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        
        mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTimelineViewController")
        let mentionsVC = mentionsViewController as! HomeTimelineViewController
        mentionsVC.setTimelineType(TimelineType.Mentions)
        
        composeViewController = storyboard.instantiateViewControllerWithIdentifier("ComposeViewController")
        
        detailsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetDetailViewController")
        
        viewControllers.append(homeTimelineViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        viewControllers.append(composeViewController)
        viewControllers.append(detailsViewController)
        
        switch vcType {
            case .Home:
                 self.contentViewController = homeTimelineViewController
                
            case .Profile:
                self.contentViewController = profileViewController
                
            case .Mentions:
                self.contentViewController = mentionsViewController
                
            case .Compose:
                self.contentViewController = composeViewController
                
            case .Details:
                self.contentViewController = detailsViewController
        }
        
    }
    
    func setVcType(vcType: VCType) {
        self.vcType = vcType
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        let titles = ["Home", "Profile", "Mentions"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.contentViewController = viewControllers[indexPath.row]
    }
    

    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0{
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 100
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
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
