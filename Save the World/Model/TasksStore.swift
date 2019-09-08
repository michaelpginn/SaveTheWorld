//
//  TasksStore.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit
import Firebase

class TasksStore: NSObject {
    private var tasks: [Task] = []
    private var offset = 0
    var gotAll = false
    lazy private var api = ApiService()
    var lastDocument : DocumentSnapshot?
    private var taskGroupsDict:[String:TaskGroup] = [:]
    
    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.filter), name: .TaskCompleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.firebaseLoaded), name: .FirebaseLoaded, object: nil)
        
    }
    
    @objc func firebaseLoaded(){
        api.getTaskGroups { (dict) in
            print("loaded task groups")
            self.taskGroupsDict = dict
            self.sortByTaskGroup()
        }
    }
    
    /// Loads another 10 items from the api
    func loadMore(){
        api.getTasks(start: lastDocument) { (tasks, error, document, gotAll) in
            self.gotAll = gotAll
            if(error == nil){
                if let tasks = tasks, let document = document{
                  
                    self.lastDocument = document
                    self.tasks.append(contentsOf: tasks)
                    self.filter()
                    self.sortByTaskGroup()
                    NotificationCenter.default.post(name: .TasksLoaded, object: nil)
                }
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    @objc func filter(){
        let completedTaskIds = PersistentStoreManager().getCompletedTasks().map { (task) -> String in
            if task.everyDay, let timeInterval = task.dateCompleted?.timeIntervalSince(Date()){
                print(timeInterval)
                if timeInterval > 86400{
                    return ""
                }
            }
            return task.id ?? ""
        }
        self.tasks = self.tasks.filter({ (task) -> Bool in
            return !completedTaskIds.contains(task.id)
        })
        
    }
    
    func sortByTaskGroup(){
        guard self.taskGroupsDict.keys.count == 3 && self.tasks.count > 0 else{return}
        var idsToEmphasize:[String]
        let hour = Calendar.current.component(.hour, from: Date())
        print(hour)
        switch hour {
        case 0..<11:
            idsToEmphasize = self.taskGroupsDict["Morning"] ?? []
        case 11..<16:
            idsToEmphasize = self.taskGroupsDict["Midday"] ?? []
        case 16...23:
            idsToEmphasize = self.taskGroupsDict["Evening"] ?? []
        default:
            idsToEmphasize = []
        }
        var newTasks:[Task] = []
        var otherTasks:[Task] = []
        for var task in tasks{
            if idsToEmphasize.contains(task.id){
                task.suggestionReason = "Suggested by time of day"
                newTasks.append(task)
            }else{
                otherTasks.append(task)
            }
        }
        newTasks.append(contentsOf: otherTasks)
        self.tasks = newTasks
    }
    
    subscript(index:Int)->Task{
        get{
            return tasks[index]
        }
    }
    
    var count:Int{
        get{
            return tasks.count
        }
    }
}
