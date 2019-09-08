//
//  Sticker.swift
//  Save the World
//
//  Created by Michael Ginn on 9/6/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit
import SpriteKit

struct Sticker {
    var id:String
    var texture: SKTexture?
    var location: CGPoint?
    
    init(id:String){
        self.id = id
        self.texture = SKTexture(imageNamed: id)
    }
}
