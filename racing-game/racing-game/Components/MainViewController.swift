//
//  ViewController.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 9/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import SpriteKit

public enum Direction: UInt32 {
    
    case left = 0x1
    case right = 0x2
    case down = 0x4
    case up = 0x8
    
}

public class MainViewController: UIViewController {
    
    fileprivate var scene: MainScene!
    
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
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        scene = MainScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        view.insertSubview(skView, at: 0)
    }
    
}

