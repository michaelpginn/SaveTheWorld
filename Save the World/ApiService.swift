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
    
    /// Sends the score to the api for the current user
    class func postScore(){
        
    }
    
    /// Gets an array of the latest actions for the user feed, by querying for actions matching a user's friends
    class func getFeed()->[Action]{
        return []
    }
    
    /// Checks if a user matching a username exists before adding to friend list
    class func checkFriend(username:String)->Bool{
        return false
    }
    
    /// Gets non completed tasks for a user
    class func getTasks()->[Task]{
        return []
    }
    
    /// Signs up a user with a given username, returns success
    class func signUp(username:String)->Bool{
        return false
    }
}
