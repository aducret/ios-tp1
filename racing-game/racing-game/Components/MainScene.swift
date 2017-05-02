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
    
    var player = PlayerNode(imageNamed: "Car")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        initializeScene(view)
        configureWorld()
        
        player.position = CGPoint(x: 0, y: 0)
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        player.xScale = 0.3
        player.yScale = 0.3
        
        addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        player.physicsBody!.velocity = CGVector(dx: 0, dy: 5)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
}

// MARK: - Private Methods
fileprivate extension MainScene {
    
    func configureWorld() {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
    
    func initializeScene(_ view: SKView) {
        size = view.frame.size
        backgroundColor = .white
    }
    
}
