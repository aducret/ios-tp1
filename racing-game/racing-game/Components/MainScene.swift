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
    
    fileprivate let car = Car(color: .red)
    
    fileprivate var direction: Direction? = .none
    fileprivate var turn: Turn? = .none
    
    fileprivate let leftButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Left"), size: CGSize(width: 40, height: 40))
    fileprivate let rightButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Right"), size: CGSize(width: 40, height: 40))
    fileprivate let upButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Up"), size: CGSize(width: 40, height: 40))
    fileprivate let downButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Down"), size: CGSize(width: 40, height: 40))
    fileprivate let time = SKLabelNode(fontNamed: "Apple Symbols")
    
    fileprivate let startTime = CFAbsoluteTimeGetCurrent()
    fileprivate var endTime = CFAbsoluteTimeGetCurrent()
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initializeScene(view)
        configureWorld()
        
        addPlayer()
        addCamera()
        addControls()
    }
    
    var a = 0
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if (a <= 10) {
            a += 1
            return
        }
        
        car.updatePhysics(direction: direction, turn: turn)
    }
    
    public override func didFinishUpdate() {
        super.didFinishUpdate()
        updateCamera()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches
            .map { $0.location(in: self) }
            .map { nodes(at: $0) }
            .forEach {
                $0.forEach {
                    if let directionPressed = Direction(rawValue: $0.name ?? "") {
                        direction = directionPressed
                    }
                    
                    if let turnPressed = Turn(rawValue: $0.name ?? "") {
                        turn = turnPressed
                    }
                }
            }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        direction = .none
        turn = .none
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Car != 0) && (secondBody.categoryBitMask & PhysicsCategory.Grass != 0)) {
            if let car = firstBody.node as? Car, let _ = secondBody.node as? Grass {
                car.velocityRestriction = 0.5
            }
        }
    }
    
    public  func didEnd(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Car != 0) && (secondBody.categoryBitMask & PhysicsCategory.Grass != 0)) {
            if let car = firstBody.node as? Car {
                car.velocityRestriction = 0.0
            }
        }
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
        car.position = CGPoint(x: 0, y: 0)
        addChild(car)
        car.configurateJoints(scene: self)
    }
    
    fileprivate func updateCamera() {
        let carFrame = car.calculateAccumulatedFrame()
        let cameraPositionX = carFrame.origin.x + carFrame.width / 2
        let cameraPositiony = carFrame.origin.y + carFrame.height / 2
        camera?.position = CGPoint(x: cameraPositionX, y: cameraPositiony)
        
        endTime = CFAbsoluteTimeGetCurrent()
        time.text = String(format: "%.2fs", endTime - startTime)
    }
    
    fileprivate func addCamera() {
        let mainCamera = SKCameraNode()
        camera = mainCamera
        addChild(mainCamera)
    }
    
    fileprivate func addControls() {
        guard let camera = camera else { return }
        
        // This is just for debug.
//        upButton.position = CGPoint(x: 0, y: -size.height / 2 + upButton.size.height / 2 + 35)
//        upButton.name = "up"
//        upButton.zPosition = 100
//        camera.addChild(upButton)
        
        downButton.position = CGPoint(x: 0, y: -size.height / 2 + downButton.size.height / 2)
        downButton.name = "down"
        downButton.zPosition = 100
        camera.addChild(downButton)
        
        rightButton.position = CGPoint(x: size.width / 2 - 25, y: -size.height / 2 + rightButton.size.height / 2)
        rightButton.name = "right"
        rightButton.zPosition = 100
        camera.addChild(rightButton)
        
        leftButton.position = CGPoint(x: -size.width / 2 + 25, y: -size.height / 2 + leftButton.size.height / 2)
        leftButton.name = "left"
        leftButton.zPosition = 100
        camera.addChild(leftButton)
        
        time.text = "0.00s"
        time.zPosition = 100
        time.position = CGPoint(x: 0, y: size.height / 2 - time.frame.height)
        camera.addChild(time)
    }
    
}
