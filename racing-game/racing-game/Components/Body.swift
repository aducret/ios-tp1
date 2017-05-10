//
//  Body.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/10/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit

public class Body: SKShapeNode {
    
    public init(color: UIColor) {
        super.init()
        path = createCarBodyPath()
        fillColor = color
        
        configurePhysicsBody(with: frame.size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Methods
fileprivate extension Body {
    
    fileprivate func configurePhysicsBody(with size: CGSize) {
        physicsBody = SKPhysicsBody(polygonFrom: createCarBodyPath())
        physicsBody?.mass = 5
        physicsBody?.affectedByGravity = false
    }
    
}

fileprivate func createCarBodyPath() -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 20, y: 0))
    path.addLine(to: CGPoint(x: 30, y: 15))
    path.addLine(to: CGPoint(x: 25, y: 40))
    path.addLine(to: CGPoint(x: 15, y: 70))
    path.addLine(to: CGPoint(x: 5, y: 70))
    path.addLine(to: CGPoint(x: -5, y: 40))
    path.addLine(to: CGPoint(x: -10, y: 15))
    path.addLine(to: CGPoint(x: 0, y: 0))
    path.closeSubpath()
    
    return path
}
