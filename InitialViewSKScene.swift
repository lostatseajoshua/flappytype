//
//  InitialViewSKScene.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/23/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import UIKit
import SpriteKit

class InitialViewSKScene: SKScene {
    
    var background: SKScrollingNode!
    
    private var lastupdateTime: NSTimeInterval?
    
    var imageName: String!
    var showBird: Bool = false
    lazy var flappyNodeTextures : [SKTexture] =  {
        let bird1Texture = SKTexture(imageNamed: bird1ImageName)
        let bird2Texture = SKTexture(imageNamed: bird2ImageName)
        let bird3Texture = SKTexture(imageNamed: bird3ImageName)
        
        return [bird2Texture,bird3Texture,bird2Texture,bird1Texture]
    }()
    
    init(size: CGSize, imageName: String, showBird: Bool) {
        super.init(size: size)
        self.imageName = imageName
        self.showBird = showBird
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        self.scaleMode = SKSceneScaleMode.AspectFill
        
        background = SKScrollingNode.scrollingNode(withImageNamed: self.imageName, inContainerWidth: self.frame.size.width)
        
        background.scrollingSpeed = 0.8
        background.anchorPoint = CGPointZero
        background.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.addChild(self.background)
        
        if showBird {
            let flappyNode = self.createFlappyNode()
            self.addChild(flappyNode)
        }
    }
    
    func createFlappyNode() -> SKSpriteNode {
        let flappyNode = SKSpriteNode(imageNamed: "bird_2")
        flappyNode.position = CGPointMake(0, self.frame.midY)
        flappyNode.runAction(SKAction.fadeInWithDuration(2))
        flappyNode.name = initalViewSKSceneFlappyNodeName
        
        let flyAction = SKAction.animateWithTextures(flappyNodeTextures, timePerFrame: 0.1)
        
        let flyUpAction = SKAction.sequence([
            SKAction.waitForDuration(0.2),
            SKAction.rotateToAngle(0.4, duration: 0.2),
            SKAction.moveByX(30, y: 30, duration: 0.2),
            SKAction.rotateToAngle(0, duration: 0.2),
            SKAction.moveByX(30, y: -30, duration: 0.2)
            ])
        
        flappyNode.runAction(SKAction.repeatActionForever(SKAction.group([flyUpAction,flyAction])))
        return flappyNode
    }
    
    override func didSimulatePhysics() {
        self.enumerateChildNodesWithName(initalViewSKSceneFlappyNodeName, usingBlock: {
            node, stop in
            if node.position.x > self.frame.maxX {
                node.removeFromParent()
                let flappyNode = self.createFlappyNode()
                self.addChild(flappyNode)
            }
        })
    }
    
    override func update(currentTime: NSTimeInterval) {
        background.update(currentTime)
    }
}
