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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        gameView.ignoresSiblingOrder = true
        gameView.allowsTransparency = true
        gameView.presentScene(createScene())
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.levelUp), name: .LevelUp, object: nil)
    }
    
    @objc func levelUp(){

        gameView.presentScene(createScene(), transition: .crossFade(withDuration: 1.0))
    }
    
    private func createScene()->WorldScene{
        let scene = WorldScene()
        switch scoreManager.level {
        case 1:
            scene.stage = .brown
        case 2:
            scene.stage = .blue
        default:
            scene.stage = .greenBlue
        }
        
        scene.scaleMode = .resizeFill
        return scene
    }
    
}
