//
//  ApiService.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ApiService: NSObject {
    var ref: DatabaseReference = Database.database().reference()
    
    var username:String?
    var score: Int?
    
    override init(){
        username = UserDefaults.standard.string(forKey: "username")
        score = UserDefaults.standard.integer(forKey: "score")
    }
    
    /// Sends the score to the api for the current user
     func postScore(){
        guard let username = self.username else {return}
        ref.child("users").child(username).setValue(["score": score])
    }
    
    /// Gets an array of the latest actions for the user feed, by querying for actions matching a user's friends
     func getFeed()->[Action]{
        return []
    }
    
    func checkUsernameExists(username:String, completion:@escaping (Bool)->Void){
        ref.child("users").observeSingleEvent(of: .value, with:{ snapshot in
            if snapshot.hasChild(username){
                completion(false)
            }
        })
        completion(true)
    }
    
    /// Gets non completed tasks for a user
    func getTasks(completedTasks:[Task])->[Task]{
        return []
    }
    
    /// Signs up a user with a given username, returns success
    func signUp(username:String, completion:@escaping (Bool)->Void){
        checkUsernameExists(username: username) { (success) in
            if success{ self.ref.child("users").child(username).setValue(["username": username, "score":0])
            }
        }
    }
}
