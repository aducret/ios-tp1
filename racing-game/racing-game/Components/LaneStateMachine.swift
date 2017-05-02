//
//  LaneStateMachine.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/2/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import GameplayKit

class LaneStateMachine: GKStateMachine {
    
}

class LaneState: GKState {
    
    let playerNode: PlayerNode
    
    init(player: PlayerNode) {
        playerNode = player
    }
    
}

class LeftLane: LaneState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass == MiddleLane.self {
            return true
        }
        
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        playerNode.moveInDirection(direction: .Left, toLane: self)
    }
    
}

class MiddleLane: LaneState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass == LeftLane.self || stateClass == RightLane.self {
            return true
        }
        
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is LeftLane {
            playerNode.moveInDirection(direction: .Right, toLane: self)
        } else if previousState is RightLane {
            playerNode.moveInDirection(direction: .Left, toLane: self)
        }
    }
    
}

class RightLane: LaneState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass == MiddleLane.self {
            return true
        }
        
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        playerNode.moveInDirection(direction: .Right, toLane: self)
    }
    
}
