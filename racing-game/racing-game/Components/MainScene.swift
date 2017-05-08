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
import Foundation

public class MainScene: SKScene, SKPhysicsContactDelegate {
    
    public let tire = Tire(texture: nil, color: .brown, size: CGSize(width: 10, height: 20))
    public var direction: Direction? = .none
    
    fileprivate let mainCamera = SKCameraNode()
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)

        initializeScene(view)
        configureWorld()
        
//        self.camera = mainCamera
        
        addPlayer()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        tire.updateFriction()
        if let direction = direction {
            tire.updateTurn(direction: direction)
            tire.updateDrive(direction: direction)
        }
        direction = .none
    }
    
    public override func didFinishUpdate() {
        super.didFinishUpdate()
        updateCamera()
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
}

// MARK: - Private Methods
fileprivate extension MainScene {
    
    fileprivate func configureWorld() {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
    
    fileprivate func initializeScene(_ view: SKView) {
        size = view.frame.size
        backgroundColor = .black
    }
    
    fileprivate func addPlayer() {
        tire.position = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        addChild(tire)
    }
    
    fileprivate func updateCamera() {
        let carFrame = tire.calculateAccumulatedFrame()
        let cameraPositionX = carFrame.origin.x + carFrame.width / 2
        let cameraPositiony = carFrame.origin.y + carFrame.height / 2
        camera?.position = CGPoint(x: cameraPositionX, y: cameraPositiony)
    }
    
}
