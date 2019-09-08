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
        db.collection("actions").document(username + String(action.dateTime.timeIntervalSince1970)).setData(["dateTime": action.dateTime, "description": action.description, "taskId": action.taskId, "username": action.username, "title": action.title])
    }
    
    
    /// Gets an array of the latest actions for the user feed, by querying for actions matching a user's friends
    func getFeed(friendList: [Friend], completion: @escaping ([Action]?, Error?) -> Void){
        var friendList = friendList;
        friendList.append(username!)
        db.collection("actions")
            .order(by: "dateTime", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot{
                    var actions: [Action] = []
                    for action in querySnapshot.documents {
                        let username = action.get("username")
                        let title = action.get("title") ?? "Task"
                        let description = action.get("description")
                        let taskId = action.get("taskId")
                        let timeStamp: Timestamp = action.get("dateTime") as! Timestamp
                        
                        actions.append(Action(username: username as! String, title: title as! String, description: description as! String, taskId: taskId as! String, dateTime: timeStamp.dateValue()))
                    }
                    completion(actions, error)
                }
        }
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
                    let points = task.get("points") as? Int ?? 0
                    tasks.append(Task(id: id, name: name, description: description, isEveryday: isEveryday, points:points))
                }
                
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
