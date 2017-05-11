//
//  Wall.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/11/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit

public class Wall: SKSpriteNode {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuratePhysicsBody()
    }
    
}

// MARK: - Private Methods
fileprivate extension Wall {
    
    fileprivate func configuratePhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.Wall
        physicsBody?.contactTestBitMask = 0
        physicsBody?.collisionBitMask = 0
    }
    
}
