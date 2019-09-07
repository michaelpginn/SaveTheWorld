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
    
    let db = Firestore.firestore()
    
    var username:String?
    var score: Int?
    
    let db = Firestore.firestore()
    
    override init(){
        username = UserDefaults.standard.string(forKey: "username")
        score = UserDefaults.standard.integer(forKey: "score")
    }
    
    /// Sends the score to the api for the current user
     func postScore(){
        guard let username = self.username else {return}
        db.collection("users").document(username).setData(["score": score])
    }
    
    
    /// Gets an array of the latest actions for the user feed, by querying for actions matching a user's friends
    func getFeed(completion: @escaping (QuerySnapshot?, Error?) -> Void){
        db.collection("actions").getDocuments(completion: completion)
    }
    
    func checkUsernameExists(username:String, completion:@escaping (Bool)->Void){
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error in getting doc: \(error)")
            }
            else{
                if let querySnapshot = querySnapshot {
                    completion(!querySnapshot.isEmpty)
                }
            }
        }
    }
    
    /// Gets non completed tasks for a user
    func getTasks(completion: @escaping (QuerySnapshot?, Error?) -> Void){
        db.collection("tasks")
        .order(by: "score")
        .limit(to: 10)
        .getDocuments(completion: completion)
    }

    /// Signs up a user with a given username, returns success
    func signUp(username:String, completion:@escaping (Bool)->Void){
        checkUsernameExists(username: username) { (exists) in
            if !exists{
                self.db.collection("users").document(username).setData(["username": username, "score":0])
            }
        }
    }
}
