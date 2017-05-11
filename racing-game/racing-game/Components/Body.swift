//
//  Body.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/10/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit

public class Body: SKSpriteNode {
    
    public init(size: CGSize) {
        let texture = SKTexture(imageNamed: "car")
        super.init(texture: texture, color: .clear, size: size)
        
        configurePhysicsBody(with: frame.size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Methods
fileprivate extension Body {
    
    fileprivate func configurePhysicsBody(with size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.mass = 5
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.Car
        physicsBody?.contactTestBitMask = PhysicsCategory.Grass
        physicsBody?.collisionBitMask = PhysicsCategory.Wall
    }
    
}
