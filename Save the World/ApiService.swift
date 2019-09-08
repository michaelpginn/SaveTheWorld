//
//  ApiService.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit
import Firebase

typealias TaskGroup = [String]

class ApiService: NSObject {
    
    lazy var db = Firestore.firestore()
    let persistentStoreManager = PersistentStoreManager()
    
    /// Sends the score to the api for the current user
    func postScore(){
        guard let username = persistentStoreManager.username else {return}
        db.collection("users").document(username).setData(["score": persistentStoreManager.score], merge: true)
        
    }
    
    func postAction(action: Action){
        guard let username = persistentStoreManager.username else {return}
        db.collection("actions").document(username + String(action.dateTime.timeIntervalSince1970)).setData(["dateTime": action.dateTime, "description": action.description, "taskId": action.taskId, "username": action.username, "title": action.title])
    }
    
    
    /// Gets an array of the latest actions for the user feed, by querying for actions matching a user's friends
    func getFeed(friendList: [Friend], completion: @escaping ([Action]?, Error?) -> Void){
        var friendList = friendList;
        friendList.append(persistentStoreManager.username!)
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
    
    func getScore(username: String, completion: @escaping (Int?, Error?)->Void) {
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                if !querySnapshot.isEmpty {
                    let score = querySnapshot.documents.first?.get("score") as? Int
                    completion(score, error)
                }
            }
        }
        
    }
    
    /// Gets non completed tasks for a user
    func getTasks(start: DocumentSnapshot? = nil, step: Int = 10, completion: @escaping ([Task]?, Error?, DocumentSnapshot?, Bool) -> Void){
        
        //load already completed tasks
        let tasksCollection:Query
        
        if let start = start {
            tasksCollection = db.collection("tasks")
                .order(by: "points")
                .start(afterDocument: start)
                .limit(to: step)
        }else{
            tasksCollection = db.collection("tasks")
                .order(by: "points")
                .limit(to: step)
        }
        
        tasksCollection.getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                let tasks: [Task] = querySnapshot.documents.compactMap({ (snapshot) -> Task? in
                    let id:String = snapshot.get("id") as? String ?? ""
                    let name:String = snapshot.get("name") as? String ?? ""
                    let description:String = snapshot.get("description") as? String ?? ""
                    let isEveryday:Bool = snapshot.get("isEveryday") as? Bool ?? false
                    let points = snapshot.get("points") as? Int ?? 0
                    return Task(id: id, name: name, description: description, isEveryday: isEveryday, points:points, suggestionReason: nil)
                })
                
                completion(tasks, error, querySnapshot.documents.last, tasks.count == 0)
            }
            else {
                completion(nil, error, nil, false)
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
    
    func getTaskGroups(completion: @escaping ([String:TaskGroup])->Void){
        db.collection("taskGroups").getDocuments { (snapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            }else if let snapshot = snapshot{
                var groupDict:[String:TaskGroup] = [:]
                for doc in snapshot.documents{
                    if let ids = doc.get("taskIds") as? [String]{
                        groupDict[doc.documentID] = ids
                    }
                }
                completion(groupDict)
            }
        }
    }
}
