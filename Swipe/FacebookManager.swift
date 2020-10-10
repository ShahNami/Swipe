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
        if (FBSDKAccessToken.current() != nil) {
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "friends"]);
            
            request?.start(completionHandler: { (connection, result, error) in
                if error == nil {
                    var results = result as? AnyObject
                    if (results?.value(forKey: "friends") != nil) {
                        let friendObjects = (results?.value(forKey: "friends") as AnyObject).value(forKey: "data") as! [NSDictionary]
                        self.friends.removeAll()
                        for friendObject in friendObjects {
                            self.friends.append(self.fetchUser(name: friendObject["name"] as! String))
                        }
                    }
                } else {
                    print("Error Getting Friends \(error)");
                }
            })
        }
    }

    
    func fetchUser(name: String) -> User {
        let user = User()
        if (FBSDKAccessToken.current() != nil) {
            let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: API_ID, parameters: ["fields": "scores"], httpMethod: "GET")
            request.start { (connection, result, error) -> Void in
                if error == nil {
                    var results = result as? AnyObject
                    let friendObjects = (results?.value(forKey: "scores") as AnyObject).value(forKey: "data") as! [NSDictionary]
                    for friendObject in friendObjects {
                        if(((friendObject.value(forKey: "user")! as AnyObject).value(forKey: "name") as? String)! == name){
                            user.setFirstName(name: name.components(separatedBy:" ")[0])
                            user.setLastName(name: name.components(separatedBy: " ")[name.components(separatedBy: " ").count - 1])
                            user.setScore(sc: (friendObject.value(forKey: "score") as? Int)!)
                            user.setId(fbid: ((friendObject.value(forKey: "user")! as AnyObject).value(forKey: "id") as? String)!)
                            self.fetchUserImage(user: user)
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
        if (FBSDKAccessToken.current() != nil) {
            let userID = user.getId() as NSString
            let facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=square")
            if let data = NSData(contentsOf: facebookProfileUrl! as URL) {
                user.setProfileImage(image: UIImage(data: data as Data)!)
            }
        }
    }
    
    func FetchMyProfile() {
        if (FBSDKAccessToken.current() != nil) {
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "name"]);
            request?.start { (connection, result, error) -> Void in
                if error == nil {
                    var results = result as? AnyObject
                    let name = results?.value(forKey: "name?") as! String
                    self.me = self.fetchUser(name: name)
                } else {
                    print("Error Getting Me \(error)");
                }
            }
        }
    }
    
    func fetchMyScoreAsInt() -> Int {
        var myScore = 0
        if (FBSDKAccessToken.current() != nil) {
            let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "scores"]);
            request?.start { (connection, result, error) -> Void in
                if error == nil {
                    var results = result as? AnyObject
                    let object = (results?.value(forKey: "scores") as AnyObject).value(forKey: "data") as! [NSDictionary]
                    for ob in object {
                        myScore = ob.value(forKey: "score") as! Int
                    }
                } else {
                    print("Error Getting Me \(error)");
                }
            }
        }
        return myScore
    }
}
