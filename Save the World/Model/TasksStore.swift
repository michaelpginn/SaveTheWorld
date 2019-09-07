//
//  TasksStore.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class TasksStore: NSObject {
    var tasks: [Task] = []
    var offset = 0
    var gotAll = false
    var api = ApiService()
    
    func getMore(){
        
    }
}
