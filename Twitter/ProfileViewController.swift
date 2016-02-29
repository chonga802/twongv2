//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Christine Hong on 2/26/16.
//  Copyright © 2016 christinehong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    private var user: User?

    @IBOutlet weak var profPhoto: UIImageView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetNum: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followerNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("USER:")
        print(self.user)
        self.user = User.currentUser
        if let profImage = self.user!.profileImageUrl {
            profPhoto.setImageWithURL(NSURL(string: profImage)!)
        }
        if let coverImage = self.user!.coverImageUrl {
            coverPhoto.setImageWithURL(NSURL(string: coverImage)!)
        }
        nameLabel.text = self.user?.name
        usernameLabel.text = self.user?.screenname
    }
    
    func setUser(u: User?){
        self.user = u
        if let profImage = self.user!.profileImageUrl {
            profPhoto.setImageWithURL(NSURL(string: profImage)!)
        }
        if let coverImage = self.user!.coverImageUrl {
            coverPhoto.setImageWithURL(NSURL(string: coverImage)!)
        }
        nameLabel.text = self.user?.name
        usernameLabel.text = self.user?.screenname
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.user.tweets?.count ?? 0
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
//        cell.delegate = self
//        cell.tweet = tweets![indexPath.row]
//        if let tweet = self.tweets?[indexPath.row] {
//            cell.makeTweetCell(tweet)
//        }
        return cell
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
