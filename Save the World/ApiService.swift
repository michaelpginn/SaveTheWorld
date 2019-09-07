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
    func getTasks(start: DocumentSnapshot?, step: Int = 10, completion: @escaping ([Task]?, Error?, DocumentSnapshot?) -> Void){
        var thisFuckingTaskMan = db.collection("tasks")
            .order(by: "score")
            .limit(to: step)
        
        if let start = start {
            thisFuckingTaskMan.start(atDocument: start)
        }
        
        thisFuckingTaskMan.getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                var tasks: [Task] = []
                var lastDocument: DocumentSnapshot? = nil
                for task in querySnapshot.documents {
                    lastDocument = task
                    var id:String = task.get("id") as! String
                    var name:String = task.get("name") as! String
                    var description:String = task.get("description") as! String
                    var isEveryday:Bool = (task.get("isEveryday") != nil)
                    
                    tasks.append(Task(id: id, name: name, description: description, isEveryday: isEveryday))
                }
                completion(tasks, error, lastDocument)
            }
            else {
                completion(nil, error, nil)
            }
        }
    }
    
    /// Signs up a user with a given username, returns success
    func signUp(username:String, completion: @escaping (Bool)->Void){
        checkUsernameExists(username: username) { (exists) in
            if !exists{
                self.db.collection("users").document(username).setData(["username": username, "score":0])
                completion(true)
            }
            else {
                completion(false)            }
        }
    }
}
