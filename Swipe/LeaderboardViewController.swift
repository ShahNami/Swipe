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
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var lblLog: UILabel!
    
    
    func configureFacebook(){
        loginBtn.readPermissions = ["public_profile", "user_friends"]
        //loginBtn.publishPermissions = ["publish_actions"]
        loginBtn.delegate = self
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fillTable()
        lblLog.text = "Requesting permissions..."
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        self.friends.removeAll()
        let me = User()
        me.newUser(id: "0", firstName: "Me", lastName: "", score: UserDefaults.standard.value(forKey: "highscore") as! Int, profile: UIImage(named: "highscore.png")!)
        self.friends.append(me)
        scoreTable.reloadData()
    }
    

    
    func refresh(sender:AnyObject) {
        fillTable()
        refreshControl.endRefreshing()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        Indicator.isHidden = true
        Indicator.stopAnimating()
        lblLog.text = ""
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        scoreTable.addSubview(refreshControl) // not required when using UITableViewController
        
        self.configureFacebook()
        
        let me = User()
        me.newUser(id: "0", firstName: "Me", lastName: "", score: UserDefaults.standard.value(forKey: "highscore") as! Int, profile: UIImage(named: "highscore.png")!)
        self.friends.append(me)
        
        fillTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    func fillTable() {
        if (FBSDKAccessToken.current() != nil) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            Indicator.isHidden = false
            Indicator.startAnimating()
            lblLog.text = "fetching friends..."
            friends.removeAll()
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "name, picture"]);
            request?.start { (connection, result1, error) -> Void in
                if error == nil {
                    var results1 = result1 as? AnyObject
                    let user = User()
                    let name = results1?.value(forKey: "name") as! String
                    user.setId(fbid: (results1?.value(forKey: "id") as? String)!)
                    user.setFirstName(name: name.components(separatedBy: " ")[0])
                    user.setLastName(name: name.components(separatedBy: " ")[name.components(separatedBy: " ").count - 1])
                    let userID = user.getId() as NSString
                    let facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=square")
                    if let data = NSData(contentsOf: facebookProfileUrl! as URL) {
                        user.setProfileImage(image: UIImage(data: data as Data)!)
                    }
                    let request2 = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "scores"]);
                    request2?.start { (connection, result2, error) -> Void in
                        if error == nil {
                            var results2 = result2 as? AnyObject
                            if ((results2?.value(forKey: "scores") as AnyObject).value(forKey: "data")) != nil {
                                let object = (results2?.value(forKey: "scores") as AnyObject).value(forKey: "data") as! [NSDictionary]
                                for ob in object {
                                    user.setScore(sc: ob.value(forKey: "score") as! Int)
                                }
                            }
                            if(!FBSDKAccessToken.current().hasGranted("publish_actions")) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    FBSDKLoginManager().logIn(withPublishPermissions: ["publish_actions"], from: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                                        if error != nil {
                                            FBSDKLoginManager().logOut()
                                        } else if result.isCancelled {
                                            FBSDKLoginManager().logOut()
                                        } else {
                                            //self.fbToken = result.token.tokenString
                                            let params: [String : String] = ["score": "\(UserDefaults.standard.value(forKey: "highscore"))"]
                                            /* make the API call */
                                            if(user.getScore() < UserDefaults.standard.value(forKey: "highscore") as! Int) {
                                                let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/scores", parameters: params, httpMethod: "POST")
                                                request.start { (connection, result, error) -> Void in
                                                    if error == nil {
                                                        print("Successfully published score!")
                                                        user.setScore(sc: UserDefaults.standard.value(forKey: "highscore") as! Int)
                                                    } else {
                                                        print("Error Publishing Score: \(error)");
                                                    }
                                                }
                                            }
                                        }
                                        } as! FBSDKLoginManagerRequestTokenHandler)
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    self.Indicator.isHidden = true
                                    self.Indicator.stopAnimating()
                                    self.lblLog.text = ""
                                }
                            }
                            self.friends.append(user)
                            var allFriends = [String]()
                            
                            let friendsRequest = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "friends"]);
                            friendsRequest?.start { (connection, result1, error) -> Void in
                                if error == nil {
                                    var results1 = result1 as? AnyObject
                                    if (results1?.value(forKey: "friends") != nil) {
                                        let friendObjects = (results1?.value(forKey: "friends") as AnyObject).value(forKey: "data") as! [NSDictionary]
                                        for friendObject in friendObjects {
                                            let name = friendObject["name"] as! String
                                            allFriends.append(name)
                                        }
                                    }
                                } else {
                                    print("Error Getting Friends \(error)");
                                }
                                
                                let scoresRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "1132594690152165", parameters: ["fields": "scores"], httpMethod: "GET")
                                scoresRequest.start { (connection, result2, error) -> Void in
                                    if error == nil {
                                        var results2 = result2 as AnyObject
                                        let scoreObjects = (results2.value(forKey: "scores") as AnyObject).value(forKey: "data") as! [NSDictionary]
                                        for scoreObject in scoreObjects {
                                            for friend in allFriends {
                                                if(((scoreObject.value(forKey: "user")! as AnyObject).value(forKey: "name") as? String)! == friend){
                                                    let user = User()
                                                    user.setFirstName(name: friend.components(separatedBy: " ")[0])
                                                    user.setLastName(name: friend.components(separatedBy: " ")[friend.components(separatedBy: " ").count - 1])
                                                    user.setScore(sc: (scoreObject.value(forKey: "score") as? Int)!)
                                                    user.setId(fbid: ((scoreObject.value(forKey: "user")! as AnyObject).value(forKey: "id") as? String)!)
                                                    let userID = user.getId() as NSString
                                                    let facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=square")
                                                    if let data = NSData(contentsOf: facebookProfileUrl! as URL) {
                                                        user.setProfileImage(image: UIImage(data: data as Data)!)
                                                    }
                                                    self.friends.append(user)
                                                }
                                            }
                                            self.friends.sort { $0.getScore() > $1.getScore() }
                                            self.scoreTable.reloadData()
                                        }
                                        self.scoreTable.reloadData()
                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                        self.Indicator.isHidden = true
                                        self.Indicator.stopAnimating()
                                        self.lblLog.text = ""
                                    } else {
                                        print("Error Fetching Score: \(error)");
                                    }
                                }
                            }
                        } else {
                            print("Error1 \(error)");
                        }
                    }
                } else {
                    print("Error2 \(error)");
                }
            }
        } else {
            print("Facebook session expired")
            self.lblLog.text = ""
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ( friends.count > 20 ) ? 20 : friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.rankLbl.text = String(indexPath.row + 1)
        cell.nameLbl.text = (friends[indexPath.row].getCleanName())
        cell.scoreLbl.text = String(friends[indexPath.row].getScore())
        cell.profileImage.image = (friends[indexPath.row].getProfileImage())
        return cell
    }
}
