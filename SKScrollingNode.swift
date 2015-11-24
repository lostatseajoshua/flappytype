//
//  SKScrollingNode.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/23/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import UIKit
import SpriteKit

class SKScrollingNode: SKSpriteNode {

    var scrollingSpeed: CGFloat = 1.0
    
    static func scrollingNode(withImageNamed name: String, inContainerWidth width: CGFloat) -> SKScrollingNode {
        let image = UIImage(named: name)!
        let realNode = SKScrollingNode(color: UIColor.clearColor(), size: CGSizeMake(width, image.size.height))
        realNode.scrollingSpeed = 1.0
        
        var total: CGFloat = 0.0
        while total < width + image.size.width {
            let child = SKSpriteNode(imageNamed: name)
            child.name = skScrollingChildNodeName
            child.anchorPoint = CGPointZero
            child.position = CGPointMake(total, 0)
            realNode.addChild(child)
            total += child.size.width
        }
        return realNode
    }
    
    func update(currentTime: NSTimeInterval) {
        self.enumerateChildNodesWithName(skScrollingChildNodeName, usingBlock: {
            child, stop in
            let childShape = child as! SKSpriteNode
            childShape.position = CGPointMake(child.position.x - self.scrollingSpeed, child.position.y)
            if childShape.position.x <= -childShape.size.width {
                let delta = childShape.position.x + childShape.size.width
                childShape.position = CGPointMake(childShape.size.width * CGFloat(self.children.count - 1) + delta, childShape.position.y)
            }
        })
    }
}
