//
//  CoreDataManager.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Friendos created by Lance Judan on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit
import CoreData

typealias Friend = String

class PersistentStoreManager: NSObject {
    let defaults = UserDefaults.standard
    var username:String?{
        get{
            return defaults.string(forKey: "username")
        }
        set(s){
            defaults.set(s, forKey: "username")
        }
    }
    
    var score:Int{
        get{
            return defaults.integer(forKey: "score")
        }
        set(i){
            defaults.set(i, forKey: "score")
        }
    }
    
    var friendList:[Friend]{
        get{
            return (defaults.array(forKey: "friends") ?? []) as [Friend]
        }
        set(i){
            defaults.set(i, forKey: "friends")
        }
    }
    
    func getCompletedTasks()->[CompletedTask]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"CompletedTask") //get the list of records
        var fetchedResults:[CompletedTask]=[]
        do{
            fetchedResults = try context.fetch(fetchRequest) as? [CompletedTask] ?? []
        } catch _{
            print("Something went wrong getting words")
        }
        return fetchedResults
    }
    
    func completeTask(task:Task){
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"CompletedTask") //get the list of records
        let predicate = NSPredicate(format: "id==%@", task.id)
        fetchRequest.predicate = predicate
        var fetchedResults:[CompletedTask]=[]
        do{
            var managedObject:CompletedTask
            fetchedResults = try context.fetch(fetchRequest) as? [CompletedTask] ?? []
            if fetchedResults.count > 0{
                managedObject = fetchedResults.first!
                managedObject.timesCompleted += 1
                print(managedObject.timesCompleted)
                managedObject.dateCompleted = Date() as NSDate
            }else{
                managedObject = CompletedTask(context: context)
                managedObject.dateCompleted = Date() as NSDate
                managedObject.id = task.id
                managedObject.everyDay = task.isEveryday
                managedObject.timesCompleted = 1
            }
            try context.save()
        } catch _{
            print("Something went wrong saving")
        }
    }
}
