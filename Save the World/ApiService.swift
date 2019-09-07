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
    
    func postAction(action: Action){
        guard let username = self.username else {return}
        db.collection("actions").document(username + String(action.dateTime.timeIntervalSince1970)).setData(["dateTime": action.dateTime, "description": action.description, "taskId": action.taskId, "username": action.username])
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
    func getTasks(start: DocumentSnapshot? = nil, step: Int = 10, completion: @escaping ([Task]?, Error?, DocumentSnapshot?) -> Void){
        let tasksCollection = db.collection("tasks")
            .order(by: "points")
            .limit(to: step)
        
        if let start = start {
            tasksCollection.start(atDocument: start)
        }
        
        tasksCollection.getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                var tasks: [Task] = []
                for task in querySnapshot.documents {
                    let id:String = task.get("id") as! String ?? ""
                    let name:String = task.get("name") as? String ?? ""
                    let description:String = task.get("description") as? String ?? ""
                    let isEveryday:Bool = task.get("isEveryday") as? Bool ?? false
                    
                    tasks.append(Task(id: id, name: name, description: description, isEveryday: isEveryday))
                }
                print(tasks)
                completion(tasks, error, querySnapshot.documents.last)
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
