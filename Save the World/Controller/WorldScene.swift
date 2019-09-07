//
//  WorldScene.swift
//  Save the World
//
//  Created by Michael Ginn on 9/6/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit
import SpriteKit

enum WorldStage{
    case brown
    case blue
    case greenBlue
}

class WorldScene: SKScene {
    var stickers:[Sticker]?
    var stage:WorldStage?
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
    }
    
    func setupPlanet(){
        
    }
    
    func setupStickers(){
        
    }
}
