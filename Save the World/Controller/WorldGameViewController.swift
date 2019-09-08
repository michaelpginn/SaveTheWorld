//
//  WorldGameViewController.swift
//  Save the World
//
//  Created by Michael Ginn on 9/6/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit
import SpriteKit

class WorldGameViewController: UIViewController {
    @IBOutlet var gameView: SKView!
    
    var scoreManager = ScoreManager()
    var persistentStoreManager = PersistentStoreManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        gameView.ignoresSiblingOrder = true
        gameView.allowsTransparency = true
        gameView.presentScene(createScene())
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.levelUp), name: .LevelUp, object: nil)
    }
    
    var stickerNames = ["Rock", "Dolphin", "Mountain", "Tree", "Shrub"]
    
    @objc func levelUp(){
        let scene = createScene()
        if scoreManager.level > 3{
            let rand = Int.random(in: 0 ... 4)
            scene.newSticker = Sticker(id: stickerNames[rand])
        }
        gameView.presentScene(scene, transition: .crossFade(withDuration: 1.0))
    }
    
    private func createScene()->WorldScene{
        let scene = WorldScene()
        switch scoreManager.level {
        case 1:
            scene.stage = .brown
        case 2:
            scene.stage = .blue
        case 3:
            scene.stage = .greenBlue
        default:
            scene.stage = .greenBlue
        }
        
        scene.scaleMode = .resizeFill
        scene.stickers = loadStickers()
        scene.persistentStoreManager = self.persistentStoreManager
        return scene
    }
    
    func loadStickers()->[Sticker]{
        return persistentStoreManager.getStickers()
    }
}
