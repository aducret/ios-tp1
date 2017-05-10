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
    
    fileprivate var direction: UInt32 = 0
    fileprivate var directions: Directions? = .none
    
    fileprivate var leftButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Left"), size: CGSize(width: 40, height: 40))
    fileprivate var rightButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Right"), size: CGSize(width: 40, height: 40))
    fileprivate var upButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Up"), size: CGSize(width: 40, height: 40))
    fileprivate var downButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow-Down"), size: CGSize(width: 40, height: 40))
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)

        initializeScene(view)
        configureWorld()
        
        addPlayer()
        addCamera()
        addControls()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        tire.updateFriction()
        if let direction = directions {
            tire.updateTurn(direction: direction)
            tire.updateDrive(direction: direction)
        }
    }
    
    public override func didFinishUpdate() {
        super.didFinishUpdate()
//        updateCamera()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches
            .map { $0.location(in: self) }
            .forEach {
                // We subtract one to touchedNodes.count because the camera is always touched and we don't contemplate this case.
                // We check if the touched node is only one direction button.
                let touchedNodes = nodes(at: $0)
                guard touchedNodes.count - 1 == 1 else { return }
                guard let direction = Directions(rawValue: touchedNodes[0].name ?? "") else { return }
                
                directions = direction
            }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        directions = .none
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
        tire.position = CGPoint(x: 0, y: 0)
        addChild(tire)
    }
    
    fileprivate func updateCamera() {
        let carFrame = tire.calculateAccumulatedFrame()
        let cameraPositionX = carFrame.origin.x + carFrame.width / 2
        let cameraPositiony = carFrame.origin.y + carFrame.height / 2
        camera?.position = CGPoint(x: cameraPositionX, y: cameraPositiony)
    }
    
    fileprivate func addCamera() {
        let mainCamera = SKCameraNode()
        camera = mainCamera
        addChild(mainCamera)
    }
    
    fileprivate func addControls() {
        guard let camera = camera else { return }
        
        upButton.position = CGPoint(x: 0, y: -size.height / 2 + upButton.size.height / 2 + 35)
        upButton.name = "up"
        camera.addChild(upButton)
        
        downButton.position = CGPoint(x: 0, y: -size.height / 2 + downButton.size.height / 2)
        downButton.name = "down"
        camera.addChild(downButton)
        
        rightButton.position = CGPoint(x: rightButton.size.width / 2 + 25, y: -size.height / 2 + rightButton.size.height / 2)
        rightButton.name = "right"
        camera.addChild(rightButton)
        
        leftButton.position = CGPoint(x: -leftButton.size.width / 2 - 25, y: -size.height / 2 + leftButton.size.height / 2)
        leftButton.name = "left"
        camera.addChild(leftButton)
    }
    
}
