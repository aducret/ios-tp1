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
    
    fileprivate let body: Body
    fileprivate let tire1 = Tire(size: CGSize(width: 10, height: 20))
    fileprivate let tire2 = Tire(size: CGSize(width: 10, height: 20))
    fileprivate let tire3 = Tire(size: CGSize(width: 10, height: 20))
    fileprivate let tire4 = Tire(size: CGSize(width: 10, height: 20))
    
    public init(color: UIColor) {
        body = Body(size: CGSize(width: 40, height: 70))
        
        super.init()

        addChilds()
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
        var pinJoint = SKPhysicsJointPin.joint(withBodyA: body.physicsBody!, bodyB: tire1.physicsBody!, anchor: tire1.position)
        pinJoint.shouldEnableLimits = true
        pinJoint.lowerAngleLimit = CGFloat(-45.degreesToRadians)
        pinJoint.upperAngleLimit = CGFloat(45.degreesToRadians)
        pinJoint.frictionTorque = 0.2
        scene.physicsWorld.add(pinJoint)
        
        pinJoint = SKPhysicsJointPin.joint(withBodyA: body.physicsBody!, bodyB: tire2.physicsBody!, anchor: tire2.position)
        pinJoint.shouldEnableLimits = true
        pinJoint.lowerAngleLimit = CGFloat(-45.degreesToRadians)
        pinJoint.upperAngleLimit = CGFloat(45.degreesToRadians)
        pinJoint.frictionTorque = 0.2
        scene.physicsWorld.add(pinJoint)
        
        var fixedJoint = SKPhysicsJointFixed.joint(withBodyA: body.physicsBody!, bodyB: tire3.physicsBody!, anchor: tire3.position)
        scene.physicsWorld.add(fixedJoint)
        
        fixedJoint = SKPhysicsJointFixed.joint(withBodyA: body.physicsBody!, bodyB: tire4.physicsBody!, anchor: tire4.position)
        scene.physicsWorld.add(fixedJoint)
    }
    
}

// MARK: - Private Methods
fileprivate extension Car {
    
    fileprivate func addChilds() {
        body.zPosition = 3
        body.position = CGPoint(x: 10, y: 35)
        addChild(body)
        
        tire1.position = CGPoint(x: -5, y: 60)
        tire1.zPosition = 2
        addChild(tire1)
        
        tire2.position = CGPoint(x: 25, y: 60)
        tire2.zPosition = 2
        addChild(tire2)
        
        tire3.position = CGPoint(x: -5, y: 5)
        tire3.zPosition = 2
        addChild(tire3)
        
        tire4.position = CGPoint(x: 25, y: 5)
        tire4.zPosition = 2
        addChild(tire4)
    }
    
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
