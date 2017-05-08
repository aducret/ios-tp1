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
    
    fileprivate let fowardDirection: CGVector = CGVector(dx: 0, dy: 1)
    fileprivate let lateralDirection: CGVector = CGVector(dx: 1, dy: 0)
    
    fileprivate let maxForwardSpeed: CGFloat = 100
    fileprivate let maxBackwardSpeed: CGFloat = -20
    fileprivate let maxDriveForce: CGFloat = 150
    
    public override init(texture: SKTexture? = nil, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
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
        default:
            return
        }
        
        let currentForwardNormal = getFowardDirection()
        let currentSpeed = getForwardVelocity().dot(currentForwardNormal)
        var force: CGFloat = 0.0
        
        if (desiredSpeed > currentSpeed) {
            force = maxDriveForce
        } else if (desiredSpeed < currentSpeed) {
            force = -maxDriveForce
        } else {
            return
        }
        
        let dx = currentForwardNormal.dx * force
        let dy = currentForwardNormal.dy * force
        physicsBody.applyForce(CGVector(dx: dx, dy: dy))
    }
    
    public func updateTurn(direction: Direction) {
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
        let forwardSpeed = getLateralDirection().module()
        let dragMagnitude = -2 * forwardSpeed
        let drag = forwardVelocity.scale(dragMagnitude)
        physicsBody.applyForce(drag)
    }
    
}

// MARK: - Private Methods
fileprivate extension Tire {

    fileprivate func configurePhysicsBody(with size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.mass = 20
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
    }
        
    fileprivate func getForwardVelocity() -> CGVector {
        guard let velocity = physicsBody?.velocity else { return CGVector(dx: 0, dy: 0) }
        
        let normal = getFowardDirection().normalized()
        let dx = normal.dx * velocity.dot(normal)
        let dy = normal.dy * velocity.dot(normal)
        return CGVector(dx: dx, dy: dy)
    }
    
    fileprivate func getLateralVelocity() -> CGVector {
        guard let velocity = physicsBody?.velocity else { return CGVector(dx: 0, dy: 0) }
        
        let normal = getLateralDirection().normalized()
        let dx = normal.dx * velocity.dot(normal)
        let dy = normal.dy * velocity.dot(normal)
        return CGVector(dx: dx, dy: dy)
    }
    
    fileprivate func getLateralDirection() -> CGVector {
        return lateralDirection.rotate(zRotation)
    }
    
   fileprivate func getFowardDirection() -> CGVector {
        return fowardDirection.rotate(zRotation)
    }
    
}
