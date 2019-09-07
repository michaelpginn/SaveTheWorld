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
    
    /// Loads another 10 items from the api
    func loadMore(){
        api.getTasks(start: lastDocument) { (tasks, error, document) in
            if let tasks = tasks, let document = document{
                self.lastDocument = document
                self.tasks.append(contentsOf: tasks)
            }
        }
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
