//
//  Car.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/10/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit

public class Car: SKNode {
    
    public let body: Body
    
    public let tire1 = Tire(texture: nil, color: .brown, size: CGSize(width: 10, height: 20))
    public let tire2 = Tire(texture: nil, color: .brown, size: CGSize(width: 10, height: 20))
    public let tire3 = Tire(texture: nil, color: .brown, size: CGSize(width: 10, height: 20))
    public let tire4 = Tire(texture: nil, color: .brown, size: CGSize(width: 10, height: 20))
    
    public init(color: UIColor) {
        body = Body(color: color)
        
        super.init()
        
        body.zPosition = 1
        addChild(body)
        
        tire1.position = CGPoint(x: -5, y: 60)
        addChild(tire1)
        
        tire2.position = CGPoint(x: 25, y: 60)
        addChild(tire2)
        
        tire3.position = CGPoint(x: -5, y: 5)
        addChild(tire3)
        
        tire4.position = CGPoint(x: 25, y: 5)
        addChild(tire4)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updatePhysics(direction: Direction? = .none, turn: Turn? = .none) {
        updateFrontalTirePhysics(tire: tire1, direction: direction, turn: turn)
        updateFrontalTirePhysics(tire: tire2, direction: direction, turn: turn)
        updateBackTirePhysics(tire: tire3, direction: direction)
        updateBackTirePhysics(tire: tire4, direction: direction)
    }
    
    public func configurateJoints(scene: SKScene) {
        var springJoint = SKPhysicsJointSpring.joint(withBodyA: body.physicsBody!, bodyB: tire1.physicsBody!, anchorA: tire1.position, anchorB: tire1.position)
        scene.physicsWorld.add(springJoint)
        
        springJoint = SKPhysicsJointSpring.joint(withBodyA: body.physicsBody!, bodyB: tire2.physicsBody!, anchorA: tire2.position, anchorB: tire2.position)
        scene.physicsWorld.add(springJoint)
        
        var fixedJoint = SKPhysicsJointFixed.joint(withBodyA: body.physicsBody!, bodyB: tire3.physicsBody!, anchor: tire3.position)
        scene.physicsWorld.add(fixedJoint)
        
        fixedJoint = SKPhysicsJointFixed.joint(withBodyA: body.physicsBody!, bodyB: tire4.physicsBody!, anchor: tire4.position)
        scene.physicsWorld.add(fixedJoint)
    }
    
}

// MARK: - Private Methods
fileprivate extension Car {
    
    fileprivate func updateFrontalTirePhysics(tire: Tire, direction: Direction?, turn: Turn?) {
        tire.updateFriction()
        
        if let turn = turn {
            tire.updateTurn(turn: turn, parentRotation: body.zRotation)
        }
        
        if let direction = direction {
            tire.updateDrive(direction: direction)
        } else {
            tire.updateDrive(direction: .up)
        }
    }
    
    fileprivate func updateBackTirePhysics(tire: Tire, direction: Direction?) {
        tire.updateFriction()
        
        if let direction = direction {
            tire.updateDrive(direction: direction)
        } else {
            tire.updateDrive(direction: .up)
        }
    }
    
}
