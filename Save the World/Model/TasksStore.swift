//
//  TasksStore.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class TasksStore: NSObject {
    private var tasks: [Task] = []
    private var offset = 0
    var gotAll = false
    lazy private var api = ApiService()
    
    /// Loads another 10 items from the api
    func loadMore(){
        
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
