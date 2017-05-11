//
//  Grass.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/11/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit

public class Grass: SKSpriteNode {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuratePhysicsBody()
    }
    
}

// MARK: - Private Methods
fileprivate extension Grass {
    
    fileprivate func configuratePhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = PhysicsCategory.Grass
        physicsBody?.contactTestBitMask = PhysicsCategory.Car
        physicsBody?.collisionBitMask = 0
    }
    
}
