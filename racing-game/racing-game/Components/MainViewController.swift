//
//  ViewController.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 9/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import SpriteKit

public enum Turn: String {
    
    case left = "left"
    case right = "right"
    
}

public enum Direction: String {
    
    case down = "down"
    case up = "up"
    
}

public struct PhysicsCategory {
    
    static let Tire: UInt32 = 1
    static let Grass: UInt32 = 2
    static let Wall: UInt32 = 4
    static let FinishLine: UInt32 = 8
    static let Body: UInt32 = 16
    
}

public class MainViewController: UIViewController {
    
    fileprivate var scene: MenuScene!
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.bounds)
        skView.ignoresSiblingOrder = true
        // This is just for debug
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        scene = MenuScene(fileNamed: "MenuScene")
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        view.insertSubview(skView, at: 0)
    }
    
}

