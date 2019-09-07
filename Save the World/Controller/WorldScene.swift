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
    
    static func color(stage:WorldStage)->UIColor{
        switch(stage){
        case .brown:
            return UIColor(displayP3Red: 216/255.0, green: 197/255.0, blue: 150/255.0, alpha: 1.0)
        case .blue:
            return UIColor(displayP3Red: 107/255.0, green: 147/255.0, blue: 214/255.0, alpha: 1.0)
        case .greenBlue:
            return .green
        }
    }
}

class WorldScene: SKScene {
    var stickers:[Sticker]?
    var stage:WorldStage = .blue
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupWorld()
        setupStickers()
    }
    
    func setupWorld() {
        let world = SKShapeNode(circleOfRadius: frame.width / 2 - 50)
        world.fillColor = WorldStage.color(stage:stage)
        world.strokeColor = WorldStage.color(stage:stage)
        world.glowWidth = 5
        addChild(world)
        if(stage == .greenBlue){
            let continent = SKSpriteNode(texture: SKTexture(imageNamed: "geography"))
            world.addChild(continent)
        }
    }
    
    func setupStickers(){
        guard let stickers = self.stickers else{return}
        for sticker in stickers{
            let stickerNode = SKSpriteNode(texture: sticker.texture, size: CGSize(width: 50, height: 50))
            stickerNode.position = sticker.location
            addChild(stickerNode)
        }
    }
}
