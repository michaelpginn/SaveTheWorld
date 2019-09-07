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

class PersistentStoreManager: NSObject {
    let defaults = UserDefaults.standard
    typealias Friendo = String
    
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
    
    var friendoList:[Friendo]{
        get{
            return (defaults.array(forKey: "friends") ?? []) as [Friendo]
        }
        set(i){
            defaults.set(i, forKey: "friends")
        }
    }
    
    func getCompletedTasks(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.manag
//        
//        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"CompletedTask") //get the list of records
        //var fetchedResults:[CompletedTask]? = nil
//        do{
//            fetchedResults = try managedContext.fetch(fetchRequest) as? [CompletedTask]
//        } catch _{
//            print("Something went wrong getting words")
//        }
//        for task in fetchedResults{
//            
//        }
    }
}
