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
    
    var friends = [User]()
    var fbToken: String!
    
    @IBOutlet weak var loginBtn: FBSDKLoginButton!

    @IBOutlet weak var scoreTable: UITableView!
    
    @IBAction func BackButtonPressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var lblLog: UILabel!
    
    
    func configureFacebook(){
        loginBtn.readPermissions = ["public_profile", "email", "user_friends"]
        //loginBtn.publishPermissions = ["publish_actions"]
        loginBtn.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        fillTable()
        lblLog.text = "Requesting permissions..."
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            FBSDKLoginManager().logInWithPublishPermissions(["publish_actions"], fromViewController: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if error != nil {
                    FBSDKLoginManager().logOut()
                } else if result.isCancelled {
                    FBSDKLoginManager().logOut()
                } else {
                    self.fbToken = result.token.tokenString
                }
            })
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.Indicator.hidden = true
            self.Indicator.stopAnimating()
            self.lblLog.text = ""
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        self.friends.removeAll()
        let me = User()
        me.newUser("0", firstName: "Me", lastName: "", score: NSUserDefaults.standardUserDefaults().integerForKey("highscore"), profile: UIImage(named: "highscore.png")!)
        self.friends.append(me)
        scoreTable.reloadData()
    }
    

    
    func refresh(sender:AnyObject) {
        fillTable()
        refreshControl.endRefreshing()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        Indicator.hidden = true
        Indicator.stopAnimating()
        lblLog.text = ""
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(red: 45, green: 63, blue: 81, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(LeaderboardViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        scoreTable.addSubview(refreshControl) // not required when using UITableViewController
        
        self.configureFacebook()
        
        let me = User()
        me.newUser("0", firstName: "Me", lastName: "", score: NSUserDefaults.standardUserDefaults().integerForKey("highscore"), profile: UIImage(named: "highscore.png")!)
        self.friends.append(me)
        
        fillTable()
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
    
    func fillTable() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            Indicator.hidden = false
            Indicator.startAnimating()
            lblLog.text = "fetching friends..."
            friends.removeAll()
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "name, picture"]);
            request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result1 : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    let user = User()
                    let name = result1.valueForKey("name") as! String
                    user.setId((result1.valueForKey("id") as? String)!)
                    user.setFirstName(name.componentsSeparatedByString(" ")[0])
                    user.setLastName(name.componentsSeparatedByString(" ")[name.componentsSeparatedByString(" ").count - 1])
                    let userID = user.getId() as NSString
                    let facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=square")
                    if let data = NSData(contentsOfURL: facebookProfileUrl!) {
                        user.setProfileImage(UIImage(data: data)!)
                    }
                    let request2 = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "scores"]);
                    request2.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result2 : AnyObject!, error : NSError!) -> Void in
                        if error == nil {
                            let object = result2.valueForKey("scores")?.valueForKey("data") as! [NSDictionary]
                            for ob in object {
                                user.setScore(ob.valueForKey("score") as! Int)
                            }
                            self.friends.append(user)
                        } else {
                            print("Error1 \(error)");
                        }
                    }
                } else {
                    print("Error2 \(error)");
                }
            }
            
            
            let friendsRequest = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "friends"]);
            friendsRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result1 : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    if (result1.valueForKey("friends") != nil) {
                        let friendObjects = result1.valueForKey("friends")?.valueForKey("data") as! [NSDictionary]
                        for friendObject in friendObjects {
                            let name = friendObject["name"] as! String
                            let scoresRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "1132594690152165", parameters: ["fields": "scores"], HTTPMethod: "GET")
                            scoresRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result2 : AnyObject!, error : NSError!) -> Void in
                                if error == nil {
                                    let scoreObjects = result2.valueForKey("scores")?.valueForKey("data") as! [NSDictionary]
                                    for scoreObject in scoreObjects {
                                        if((scoreObject.valueForKey("user")!.valueForKey("name") as? String)! == name){
                                            let user = User()
                                            user.setFirstName(name.componentsSeparatedByString(" ")[0])
                                            user.setLastName(name.componentsSeparatedByString(" ")[name.componentsSeparatedByString(" ").count - 1])
                                            user.setScore((scoreObject.valueForKey("score") as? Int)!)
                                            user.setId((scoreObject.valueForKey("user")!.valueForKey("id") as? String)!)
                                            let userID = user.getId() as NSString
                                            let facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=square")
                                            if let data = NSData(contentsOfURL: facebookProfileUrl!) {
                                                user.setProfileImage(UIImage(data: data)!)
                                            }
                                            self.friends.append(user)
                                        }
                                        self.friends.sortInPlace { $0.getScore() > $1.getScore() }
                                        self.scoreTable.reloadData()
                                    }
                                    self.scoreTable.reloadData()
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    self.Indicator.hidden = true
                                    self.Indicator.stopAnimating()
                                    self.lblLog.text = ""
                                } else {
                                    print("Error Fetching Score: \(error)");
                                }
                            }
                        }
                    }
                } else {
                    print("Error Getting Friends \(error)");
                }
            }
        } else {
            print("Facebook session expired")
        }
    }

    
    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ( friends.count > 20 ) ? 20 : friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        cell.nameLbl.text = (friends[indexPath.row].getCleanName())
        cell.scoreLbl.text = String(friends[indexPath.row].getScore())
        cell.profileImage.image = (friends[indexPath.row].getProfileImage())
        return cell
    }
}
