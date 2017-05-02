//
//  MainScene.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/2/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

class MainScene: SKScene, SKPhysicsContactDelegate {
    
    var player: PlayerNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        size = view.frame.size
        player = findChildNode(withIdentifier: .player)

        let center: CGFloat = 0
        let difference: CGFloat = 70.0
        player.leftConstraint = SKConstraint.positionX(SKRange(constantValue: center - difference))
        player.middleConstraint = SKConstraint.positionX(SKRange(constantValue: center))
        player.rightConstraint = SKConstraint.positionX(SKRange(constantValue: center + difference))
        
        player.leftConstraint.enabled = false
        player.rightConstraint.enabled = false
        
        player.constraints = [player.leftConstraint, player.middleConstraint, player.rightConstraint]
        
        physicsWorld.contactDelegate = self
        
        let timer = Timer(timeInterval: 3.0, target: self, selector: #selector(spawnObstacle(timer:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        let camera = SKCameraNode()
        self.camera = camera
        camera.position = CGPoint(x: center, y: player.position.y + 200)
        let moveForward = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1.0)
        camera.run(SKAction.repeatForever(moveForward))
        addChild(camera)
        
        player.xScale = 0.4; player.yScale = 0.4
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == player || contact.bodyB.node == player {
            player.isHidden = true
            player.removeAllActions()
            camera?.removeAllActions()
        }
    }
    
    func spawnObstacle(timer: Timer) {
        if player.isHidden {
            timer.invalidate()
            return
        }
        
        let spriteGenerator = GKShuffledDistribution(lowestValue: 1, highestValue: 2)
        let obstacle = SKSpriteNode(imageNamed: "Obstacle \(spriteGenerator.nextInt())")
        obstacle.xScale = 0.3
        obstacle.yScale = 0.3
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 15)
        physicsBody.contactTestBitMask = 0x00000001
        physicsBody.pinned = true
        physicsBody.allowsRotation = false
        obstacle.physicsBody = physicsBody
        
        let center: CGFloat = 0
        let difference: CGFloat = (70.0)
        var x: CGFloat = 0
        let laneGenerator = GKShuffledDistribution(lowestValue: 1, highestValue: 3)
        switch laneGenerator.nextInt() {
        case 1:
            x = center - difference
        case 2:
            x = center
        case 3:
            x = center + difference
        default:
            fatalError("Number outside of [1, 3] generated")
        }
        
        obstacle.position = CGPoint(x: x, y: (player.position.y + 800))
        addChild(obstacle)
    }
    
}
