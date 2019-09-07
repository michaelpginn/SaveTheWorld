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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        gameView.ignoresSiblingOrder = true
        gameView.allowsTransparency = true
        let scene = WorldScene()
        scene.stage = .greenBlue
        scene.scaleMode = .resizeFill
        gameView.presentScene(scene)
    }
    
}
