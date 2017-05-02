//
//  ViewController.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 9/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import SpriteKit

enum Direction: Int {
    case Left = 0, Right = 1
}

class MainViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.bounds)
        skView.ignoresSiblingOrder = true
        
        // TODO: Check if we are in debug mode
        if true {
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
        
        let scene = MainScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        view.insertSubview(skView, at: 0)
    }
    
    @IBAction func didPressButton(_ sender: AnyObject) {
    
    }
    
}

