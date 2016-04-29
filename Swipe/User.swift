//
//  User.swift
//  Swipe
//
//  Created by Nami Shah on 26/04/16.
//  Copyright © 2016 Nami Shah. All rights reserved.
//


class User {
    var id = ""
    var firstName = ""
    var lastName = ""
    var score = 0
    var profile = UIImage(named: "highscore.png")
    
    
    func newUser(id: String, firstName: String, lastName: String, score: Int, profile: UIImage) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.score = score
        self.profile = profile
    }
    
    func getId() -> String {
        return id
    }
    
    func getFirstName() -> String {
        return firstName
    }
    
    func getLastName() -> String {
        return lastName
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getProfileImage() -> UIImage {
        return profile!
    }
    
    func setFirstName(name: String) {
        firstName = name
    }
    
    func setLastName(name: String) {
        lastName = name
    }
    
    func setScore(sc: Int) {
        score = sc
    }
    
    func setProfileImage(image: UIImage) {
        profile = image
    }
    
    func setId(fbid: String) {
        id = fbid
    }
    
    func getCleanName() -> String {
        return getFirstName() + " " + getLastName()
    }
    
    func toString() -> String {
        return "Facebook ID: \(getId())\nFirst Name: \(getFirstName())\nLast Name: \(getLastName())\nScore: \(getScore())"
    }
    
}
 