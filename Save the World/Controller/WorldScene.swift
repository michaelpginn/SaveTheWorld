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
    
    func color(stage:WorldStage){
        
    }
}

class WorldScene: SKScene {
    var stickers:[Sticker]?
    var stage:WorldStage?
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupWorld()
    }
    
    func setupWorld() {
        let world = SKShapeNode(circleOfRadius: 100)
        world.fillColor = .brown
        world.glowWidth = 0.3
        self.addChild(world)
    }
    
    func setupStickers(){
        
    }
}
