//
//  FinishLine.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/11/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit

public class FinishLine: SKSpriteNode {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configuratePhysicsBody()
        zPosition = 1
    }
    
}

// MARK: - Private Methods
fileprivate extension FinishLine {
    
    fileprivate func configuratePhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.FinishLine
        physicsBody?.contactTestBitMask = PhysicsCategory.Body
        physicsBody?.collisionBitMask = 0
    }
    
}
