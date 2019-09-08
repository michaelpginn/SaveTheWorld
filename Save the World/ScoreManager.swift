//
//  ScoreManager.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class ScoreManager: NSObject {
    let persistenceStoreManager = PersistentStoreManager()
    lazy var api = ApiService()
    
    func addPoints(points:Int){
        let oldLevel = self.level
        //UPDATE SCORE
        persistenceStoreManager.score += points
        if(self.level != oldLevel){
            NotificationCenter.default.post(name: .LevelUp, object: nil)
            print("LEVEL UP")
        }
        api.postScore()
    }
    
    var level:Int{
        get{
            let points = persistenceStoreManager.score
            return ScoreManager.levelForScore(points)
        }
    }
    
    class func levelForScore(_ score:Int)->Int{
        switch(score){
        case 0..<5:
            return 1
        case 5..<15:
            return 2
        case 15..<25:
            return 3
        default:
            return 4 + ((score - 25) / 10)
        }
    }
}
