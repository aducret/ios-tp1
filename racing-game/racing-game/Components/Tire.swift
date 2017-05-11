//
//  PlayerNode.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/2/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit

public class Tire: SKSpriteNode {
    
    public var velocityRestriction: CGFloat = 0.0
    
    fileprivate static let MinAngle: CGFloat = -45
    fileprivate static let MaxAngle: CGFloat = 45
    
    fileprivate let fowardDirection = CGVector(dx: 0, dy: 1)
    fileprivate let lateralDirection = CGVector(dx: 1, dy: 0)
    
    fileprivate let maxForwardSpeed: CGFloat = 250
    fileprivate let maxBackwardSpeed: CGFloat = -40
    fileprivate let maxDriveForce: CGFloat = 300
    
    public init(size: CGSize) {
        let texture = SKTexture(imageNamed: "Tire")
        super.init(texture: texture, color: .clear, size: size)
        
        configurePhysicsBody(with: frame.size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateDrive(direction: Direction) {
        guard let physicsBody = physicsBody else { return }
        
        let desiredSpeed: CGFloat
        switch direction {
        case .up:
            desiredSpeed = maxForwardSpeed
        case .down:
            desiredSpeed = maxBackwardSpeed
        }
        
        let currentForwardNormal = getFowardDirection()
        let currentSpeed = getForwardVelocity().dot(currentForwardNormal)
        
        let force: CGFloat
        if currentSpeed < desiredSpeed {
            force = maxDriveForce * (1.0 - velocityRestriction) * 10
        } else if (currentSpeed > desiredSpeed) {
            force = -maxDriveForce * (1.0 - velocityRestriction)
        } else {
            return
        }

        physicsBody.applyForce(currentForwardNormal.scale(force))
    }
    
    public func updateTurn(turn: Turn, parentRotation: CGFloat) {
        guard let physicsBody = physicsBody else { return }
        
        let desiredTorque: CGFloat
        switch turn {
        case .left:
            desiredTorque = 1
        case .right:
            desiredTorque = -1
        }
        
        physicsBody.applyTorque(desiredTorque)
    }

    public func updateFriction() {
        guard let physicsBody = physicsBody else { return }
        
        let impulse = getLateralVelocity().scale(-physicsBody.mass)
        physicsBody.applyImpulse(impulse)

        let angularImpulse = -0.1 * physicsBody.angularDamping * physicsBody.angularVelocity
        physicsBody.applyAngularImpulse(angularImpulse)
        
        let forwardVelocity = getForwardVelocity()
        let forwardSpeed = forwardVelocity.module()
        let dragMagnitude = -2 * forwardSpeed
        let drag = forwardVelocity.scale(dragMagnitude)
        physicsBody.applyForce(drag)
    }
    
}

// MARK: - Private Methods
fileprivate extension Tire {

    fileprivate func configurePhysicsBody(with size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.mass = 5
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.Car
        physicsBody?.contactTestBitMask = PhysicsCategory.Grass
        physicsBody?.collisionBitMask = PhysicsCategory.Wall
    }
        
    fileprivate func getForwardVelocity() -> CGVector {
        guard let velocity = physicsBody?.velocity else { return CGVector(dx: 0, dy: 0) }
        
        let forwardDirection = getFowardDirection().normalized()
        let forwardSpeed = velocity.dot(forwardDirection)
        return forwardDirection.scale(forwardSpeed)
    }
    
    fileprivate func getLateralVelocity() -> CGVector {
        guard let velocity = physicsBody?.velocity else { return CGVector(dx: 0, dy: 0) }
        
        let lateralDirection = getLateralDirection().normalized()
        let lateralSpeed = velocity.dot(lateralDirection)
        return lateralDirection.scale(lateralSpeed)
    }
    
    fileprivate func getLateralDirection() -> CGVector {
        return lateralDirection.rotate(zRotation)
    }
    
   fileprivate func getFowardDirection() -> CGVector {
        return fowardDirection.rotate(zRotation)
    }
    
}
