//
//  FacebookManager.swift
//  Swipe
//
//  Created by Nami Shah on 26/04/16.
//  Copyright © 2016 Nami Shah. All rights reserved.
//

import Foundation

class FacebookManager {
    let API_ID = "1132594690152165"
    var me = User()
    var friends = [User]()
    
    func fetchFriendList() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "friends"]);
            request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    if (result.valueForKey("friends") != nil) {
                        let friendObjects = result.valueForKey("friends")?.valueForKey("data") as! [NSDictionary]
                        self.friends.removeAll()
                        for friendObject in friendObjects {
                            self.friends.append(self.fetchUser(friendObject["name"] as! String))
                        }
                    }
                } else {
                    print("Error Getting Friends \(error)");
                }
            }
        }
    }

    
    func fetchUser(name: String) -> User {
        let user = User()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: API_ID, parameters: ["fields": "scores"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    let friendObjects = result.valueForKey("scores")?.valueForKey("data") as! [NSDictionary]
                    for friendObject in friendObjects {
                        if((friendObject.valueForKey("user")!.valueForKey("name") as? String)! == name){
                            user.setFirstName(name.componentsSeparatedByString(" ")[0])
                            user.setLastName(name.componentsSeparatedByString(" ")[name.componentsSeparatedByString(" ").count - 1])
                            user.setScore((friendObject.valueForKey("score") as? Int)!)
                            user.setId((friendObject.valueForKey("user")!.valueForKey("id") as? String)!)
                            self.fetchUserImage(user)
                        }
                    }
                } else {
                    print("Error Fetching Score: \(error)");
                }
            }
        }
        return user
    }
    
    
    func fetchUserImage(user: User){
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let userID = user.getId() as NSString
            let facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=square")
            if let data = NSData(contentsOfURL: facebookProfileUrl!) {
                user.setProfileImage(UIImage(data: data)!)
            }
        }
    }
    
    func FetchMyProfile() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "name"]);
            request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    let name = result.valueForKey("name") as! String
                    self.me = self.fetchUser(name)
                } else {
                    print("Error Getting Me \(error)");
                }
            }
        }
    }
    
    func fetchMyScoreAsInt() -> Int {
        var myScore = 0
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "scores"]);
            request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    let object = result.valueForKey("scores")?.valueForKey("data") as! [NSDictionary]
                    for ob in object {
                        myScore = ob.valueForKey("score") as! Int
                    }
                } else {
                    print("Error Getting Me \(error)");
                }
            }
        }
        return myScore
    }

    

    
}