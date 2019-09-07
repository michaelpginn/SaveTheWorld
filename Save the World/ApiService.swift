//
//  ApiService.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit
import Firebase

class ApiService: NSObject {
    var ref: DatabaseReference = Database.database().reference()
    var username:String?
    
    override init(){
        username = UserDefaults.standard.string(forKey: "username")
    }
    
    /// Sends the score to the api for the current user
     func postScore(){
        
    }
    
    /// Gets an array of the latest actions for the user feed, by querying for actions matching a user's friends
     func getFeed()->[Action]{
        return []
    }
    
    /// Checks if a user matching a username exists before adding to friend list
     func checkFriend(username:String)->Bool{
        return false
    }
    
    /// Gets non completed tasks for a user
     func getTasks()->[Task]{
        return []
    }
    
    /// Signs up a user with a given username, returns success
     func signUp(username:String)->Bool{
        
        return false
    }
}
