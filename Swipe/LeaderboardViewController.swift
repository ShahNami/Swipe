//
//  GameViewController.swift
//  Arrow
//
//  Created by Nami Shah on 09/04/16.
//  Copyright (c) 2016 Nami Shah. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKLoginButtonDelegate {
    
    var friends = [[String:AnyObject]]()
    
    @IBOutlet weak var loginBtn: FBSDKLoginButton!

    @IBOutlet weak var scoreTable: UITableView!
    
    @IBAction func BackButtonPressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func populateTableWithFriends(){
        
    }
    
    
    func getUserScore(){

    }
    
    func configureFacebook()
    {
        loginBtn.readPermissions = ["public_profile", "email", "user_friends"]
        loginBtn.publishPermissions = ["publish_actions"]
        loginBtn.delegate = self
    }
    
    func readScoreFromFacebook(name: String) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            /* make the API call */
            let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "1132594690152165", parameters: ["fields": "scores"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    let friendObjects = result.valueForKey("scores")?.valueForKey("data") as! [NSDictionary]
                    for friendObject in friendObjects {
                        if((friendObject.valueForKey("user")!.valueForKey("name") as? String)! == name){
                            self.friends.append(["name":name,"score":"\((friendObject.valueForKey("score") as? Int)!)"])
                        }
                    }
                    self.scoreTable.reloadData()
                    print("Successfully fetched score!")
                } else {
                    print("Error Fetching Score: \(error)");
                }
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        fetchFriendsFromFacebook()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func fetchMeFromFacebook(){
        let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "name"]);
        
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                let name = result.valueForKey("name") as! String
                self.friends.append(["name":"\(name)","score": "\(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))" ])
                self.scoreTable.reloadData()
            } else {
                print("Error Getting Friends \(error)");
            }
        }
    }
    
    
    func fetchFriendsFromFacebook(){
        let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "friends"]);

        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                if let val = result.valueForKey("friends") {
                    let friendObjects = result.valueForKey("friends")?.valueForKey("data") as! [NSDictionary]
                    for friendObject in friendObjects {
                        self.readScoreFromFacebook(friendObject["name"] as! String)
                    }
                }
                self.scoreTable.reloadData()
            } else {
                print("Error Getting Friends \(error)");
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFacebook()
        friends.append(["name":"Me","score": "\(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))" ])
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            friends = []
            fetchMeFromFacebook()
            fetchFriendsFromFacebook()
        }
        scoreTable.reloadData()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        cell.nameLbl.text = (friends[indexPath.row]["name"] as? String)!
        cell.scoreLbl.text = (friends[indexPath.row]["score"] as? String)!
        cell.profileImage.image = UIImage(named: "highscore")
        return cell
    }
    
    
}
