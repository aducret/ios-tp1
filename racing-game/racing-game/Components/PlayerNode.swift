//
//  PlayerNode.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/2/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit

class PlayerNode: SKSpriteNode {
    
    var leftConstraint: SKConstraint!
    var middleConstraint: SKConstraint!
    var rightConstraint: SKConstraint!
    
    func moveInDirection(direction: ButtonDirection, toLane lane: LaneState) {
        disableAllConstraints()
        
        let changeInX = (direction == .Left) ? -70.0 : 70.0
        let rotation = (direction == .Left) ? Double.pi / 4.0 : -Double.pi / 4.0
        
        let duration = 0.5
        let moveAction = SKAction.moveBy(x: CGFloat(changeInX), y: 0.0, duration: duration)
        let rotateAction = SKAction.rotate(byAngle: CGFloat(rotation), duration: duration / 2.0)
        rotateAction.timingMode = .easeInEaseOut
        let rotateSequence = SKAction.sequence([rotateAction, rotateAction.reversed()])
        let moveGroup = SKAction.group([moveAction, rotateSequence])
        
        let completion = SKAction.run { () -> Void in
            switch lane {
            case is LeftLane:
                self.leftConstraint.enabled = true
            case is MiddleLane:
                self.middleConstraint.enabled = true
            case is RightLane:
                self.rightConstraint.enabled = true
            default:
                print("Warning - This should never happen: \(lane)")
                break
            }
        }
        
        let sequenceAction = SKAction.sequence([moveGroup, completion])
        run(sequenceAction)
    }
    
}

// MARK: - Private Methods
fileprivate extension PlayerNode {
    
    fileprivate func disableAllConstraints() {
        leftConstraint.enabled = false
        middleConstraint.enabled = false
        rightConstraint.enabled = false
    }
    
}

