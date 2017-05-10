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
    
    fileprivate static let MinAngle: CGFloat = -45
    fileprivate static let MaxAngle: CGFloat = 45
    
    fileprivate let fowardDirection = CGVector(dx: 0, dy: 1)
    fileprivate let lateralDirection = CGVector(dx: 1, dy: 0)
    
    fileprivate let maxForwardSpeed: CGFloat = 100
    fileprivate let maxBackwardSpeed: CGFloat = -20
    fileprivate let maxDriveForce: CGFloat = 150
    
    public override init(texture: SKTexture? = nil, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        configurePhysicsBody(with: frame.size)
        configureAngleConstraint()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateDrive(direction: Directions) {
        guard let physicsBody = physicsBody else { return }
        
        let desiredSpeed: CGFloat
        switch direction {
        case .up:
            desiredSpeed = maxForwardSpeed
        case .down:
            desiredSpeed = maxBackwardSpeed
        default:
            return
        }
        
        let currentForwardNormal = getFowardDirection()
        let currentSpeed = getForwardVelocity().dot(currentForwardNormal)
        
        let force: CGFloat
        if currentSpeed < desiredSpeed {
            force = maxDriveForce
        } else if (currentSpeed > desiredSpeed) {
            force = -maxDriveForce
        } else {
            return
        }

        physicsBody.applyForce(currentForwardNormal.scale(force))
    }
    
    public func updateTurn(direction: Directions) {
        guard let physicsBody = physicsBody else { return }
        
        let desiredTorque: CGFloat
        switch direction {
        case .left:
            desiredTorque = 1
        case .right:
            desiredTorque = -1
        default:
            return
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
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
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
    
    fileprivate func configureAngleConstraint() {
        let range = SKRange(lowerLimit: Tire.MinAngle.degreesToRadians, upperLimit: Tire.MaxAngle.degreesToRadians)
        let rotationConstraint = SKConstraint.zRotation(range)
        constraints = [rotationConstraint]
    }
    
}
