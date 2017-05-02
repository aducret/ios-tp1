//
//  ViewController.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 9/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import SpriteKit

enum ButtonDirection: Int {
    case Left = 0, Right = 1
}

class MainViewController: UIViewController {

    var stateMachine: LaneStateMachine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.frame)
        let scene = MainScene(fileNamed: SceneIdentifier.main.rawValue)!
        skView.presentScene(scene)
        view.insertSubview(skView, at: 0)
        
        let left = LeftLane(player: scene.player)
        let middle = MiddleLane(player: scene.player)
        let right = RightLane(player: scene.player)
        
        stateMachine = LaneStateMachine(states: [left, middle, right])
        stateMachine.enter(MiddleLane.self)
    }
    
    @IBAction func didPressButton(_ sender: AnyObject) {
        switch sender.tag {
            
        case ButtonDirection.Left.rawValue:
            switch stateMachine.currentState {
            case is RightLane:
                stateMachine.enter(MiddleLane.self)
            case is MiddleLane:
                stateMachine.enter(LeftLane.self)
            default:
                break
            }
            
        case ButtonDirection.Right.rawValue:
            switch stateMachine.currentState {
            case is LeftLane:
                stateMachine.enter(MiddleLane.self)
            case is MiddleLane:
                stateMachine.enter(RightLane.self)
            default:
                break
            }
            
        default:
            break
        }
    }
    
}

