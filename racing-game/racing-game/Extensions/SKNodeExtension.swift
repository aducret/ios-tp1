//
//  SKNodeExtension.swift
//  racing-game
//
//  Created by Argentino Ducret on 5/2/17.
//  Copyright © 2017 ITBA. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func findChildNode<T>(withIdentifier identifier: NodeIdentifier) -> T {
        return childNode(withName: identifier.rawValue) as! T
    }

}
