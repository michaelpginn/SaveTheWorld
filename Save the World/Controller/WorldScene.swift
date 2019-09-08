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
            return UIColor(displayP3Red: 107/255.0, green: 147/255.0, blue: 214/255.0, alpha: 1.0)
        }
    }
}

class WorldScene: SKScene {
    var stickers:[Sticker]?
    var stage:WorldStage = .blue
    var newSticker:Sticker?
    var newStickerNode:SKSpriteNode?
    var persistentStoreManager:PersistentStoreManager!
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupWorld()
        setupStickers()
    }
    
    func setupWorld() {
        let worldSize:CGFloat = frame.width / 2 - 50
        let world = SKShapeNode(circleOfRadius: worldSize)
        world.zPosition = -1
        world.fillColor = WorldStage.color(stage:stage)
        world.strokeColor = WorldStage.color(stage:stage)
        world.glowWidth = 5
        world.position = CGPoint(x: 0, y: 100)
        addChild(world)
        if(stage == .greenBlue){
            let continent = SKSpriteNode(texture: SKTexture(imageNamed: "geography"))
            continent.zPosition = 0
            continent.scale(to: CGSize(width: worldSize * 2, height: worldSize * 2))
            world.addChild(continent)
        }
    }
    
    func setupStickers(){
        if let stickers = self.stickers {
        for sticker in stickers{
            let stickerNode = SKSpriteNode(texture: sticker.texture, size: CGSize(width: 40, height: 40))
            stickerNode.position = sticker.location ?? CGPoint(x:0, y:0)
            addChild(stickerNode)
        }
        }
        if let newStick = newSticker{
            self.newStickerNode  = SKSpriteNode(texture: newStick.texture, size: CGSize(width: 40, height: 40))
            newStickerNode!.position = CGPoint(x: -120, y: -100)
            newStickerNode?.zPosition = CGFloat(self.stickers?.count ?? 2)
            addChild(newStickerNode!)
            let textNode = SKLabelNode(text: "You have a new sticker!\nTap to place it.")
            textNode.position = CGPoint(x: 40, y: -120)
            textNode.color = .white
            textNode.fontSize = 17
            textNode.numberOfLines = 2
            textNode.preferredMaxLayoutWidth = 500
            textNode.fontName = "Courier"
            textNode.name = "instructions"
            addChild(textNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let nStick = newStickerNode{
            guard let touch = touches.first else{return}
            let loc = touch.location(in: self)
            let moveAction = SKAction.move(to: loc, duration: 0.2)
            nStick.run(moveAction)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let nStick = newStickerNode{
            guard let touch = touches.first else{return}
            let loc = touch.location(in: self)
            let moveAction = SKAction.move(to: loc, duration: 0.1)
            nStick.run(moveAction)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let nStick = newStickerNode, var nS = self.newSticker{
            //SAVE to sticks
            nS.location = nStick.position
            self.persistentStoreManager.saveSticker(nS)
            self.stickers?.append(nS)
            self.newStickerNode = nil
            self.childNode(withName: "instructions")?.removeFromParent()
        }
    }
}
