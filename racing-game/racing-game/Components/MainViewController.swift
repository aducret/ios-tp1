//
//  ViewController.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 9/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import SpriteKit

public enum Direction: Int {
    case left = 0
    case right = 1
    case down = 2
    case up = 3
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
    
    @IBAction func didPressButton(_ sender: AnyObject) {
        guard let tag = sender.tag else { return }
        guard let direction = Direction(rawValue: tag) else { return }
        
        scene.direction = direction
    }
    
}

