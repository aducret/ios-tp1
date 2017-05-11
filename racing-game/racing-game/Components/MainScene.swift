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
    
    fileprivate var laps: Double = 0.0
    
    fileprivate let car = Car(color: .red)
    
    fileprivate var direction: Direction? = .none
    fileprivate var turn: Turn? = .none
    
    fileprivate let leftButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Left"), size: CGSize(width: 40, height: 40))
    fileprivate let rightButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Right"), size: CGSize(width: 40, height: 40))
    fileprivate let upButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Up"), size: CGSize(width: 40, height: 40))
    fileprivate let downButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Down"), size: CGSize(width: 40, height: 40))
    fileprivate let timeLabel = SKLabelNode(fontNamed: "Apple Symbols")
    fileprivate let lapsLabel = SKLabelNode(fontNamed: "Apple Symbols")
    
    fileprivate let startTime = CFAbsoluteTimeGetCurrent()
    fileprivate var endTime = CFAbsoluteTimeGetCurrent()
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initializeScene(view)
        configureWorld()
        
        addPlayer()
        addCamera()
        addControls()
        
        children
            .filter { $0.name == "Wall" }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.frame.size)
                $0.physicsBody?.isDynamic = false
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Wall
                $0.physicsBody?.contactTestBitMask = 0
                $0.physicsBody?.collisionBitMask = 0
            }
        
        children
            .filter { $0.name == "Grass" }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.frame.size)
                $0.physicsBody?.isDynamic = false
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Grass
                $0.physicsBody?.contactTestBitMask = PhysicsCategory.Tire
                $0.physicsBody?.collisionBitMask = 0
            }
        
        children
            .filter { $0.name == "FinishLine" }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.frame.size)
                $0.physicsBody?.isDynamic = false
                $0.physicsBody?.categoryBitMask = PhysicsCategory.FinishLine
                $0.physicsBody?.contactTestBitMask = PhysicsCategory.Body
                $0.physicsBody?.collisionBitMask = 0
            }
    }
    
    // Hack to avoid weird behavior.
    var a = 0
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if (a <= 10) {
            a += 1
            return
        }
        
        car.updatePhysics(direction: direction, turn: turn)
        
        if laps == 5 {
            view?.isPaused = true
        }
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
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Tire != 0) && (secondBody.categoryBitMask & PhysicsCategory.Grass != 0)) {
            if let tire = firstBody.node as? Tire {
                tire.velocityRestriction = 0.9
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
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Tire != 0) && (secondBody.categoryBitMask & PhysicsCategory.Grass != 0)) {
            if let tire = firstBody.node as? Tire {
                tire.velocityRestriction = 0
            }
        }
        
        if ((secondBody.categoryBitMask & PhysicsCategory.Body != 0) && (firstBody.categoryBitMask & PhysicsCategory.FinishLine != 0)) {
            laps += 0.5
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
        timeLabel.text = String(format: "%.2fs", endTime - startTime)
        
        lapsLabel.text = String(format: "Lap: %.0f", laps)
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
        
        timeLabel.text = "0.00s"
        timeLabel.zPosition = 100
        timeLabel.position = CGPoint(x: 0, y: size.height / 2 - timeLabel.frame.height)
        camera.addChild(timeLabel)
        
        lapsLabel.text = String(format: "Lap: %d", laps)
        lapsLabel.zPosition = 100
        lapsLabel.fontSize = 17
        lapsLabel.position = CGPoint(x: size.width / 2 - timeLabel.frame.width + 20, y: size.height / 2 - timeLabel.frame.height)
        camera.addChild(lapsLabel)
    }
    
}
