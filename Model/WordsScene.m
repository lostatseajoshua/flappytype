//
//  WordsScene.m
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 5/16/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import "WordsScene.h"
@interface WordsScene()
@property (strong,nonatomic) SKScrollingNode *background;
@end

@implementation WordsScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
    }
    
    return self;
}


-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.background = [SKScrollingNode scrollingNodeWithImageNamed:@"CloudBackGroundiPad.png" inContainerWidth:self.view.bounds.size.width];
    }else{
       self.background = [SKScrollingNode scrollingNodeWithImageNamed:@"flappyCloudBackground.png" inContainerWidth:self.view.bounds.size.width];
    }
    
    [self.background setScrollingSpeed:.8];
    [self.background setAnchorPoint:CGPointZero];
    [self.background setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.view.frame]];
    [self addChild:self.background];
    
    SKSpriteNode *flappy = [self newFlappyNode];
    [self addChild:flappy];
}

-(SKSpriteNode *)newFlappyNode
{
    SKSpriteNode *flappyNode = [[SKSpriteNode alloc]initWithImageNamed:@"bird_2.png"];
    flappyNode.position = CGPointMake(CGRectGetMidX(self.view.frame),CGRectGetMidY(self.view.frame));
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        flappyNode.position = CGPointMake(0, CGRectGetMidY(self.frame));
    }
    [flappyNode runAction:[SKAction fadeInWithDuration:2]];
    flappyNode.name = @"flappy";
    SKAction *fly = [SKAction animateWithTextures:@[
                                                    [SKTexture textureWithImageNamed:@"bird_2.png"],
                                                    [SKTexture textureWithImageNamed:@"bird_3.png"],
                                                    [SKTexture textureWithImageNamed:@"bird_2.png"],
                                                    [SKTexture textureWithImageNamed:@"bird_1.png"],
                                                    [SKTexture textureWithImageNamed:@"bird_2.png"],
                                                    [SKTexture textureWithImageNamed:@"bird_3.png"],
                                                    [SKTexture textureWithImageNamed:@"bird_2.png"],
                                                    [SKTexture textureWithImageNamed:@"bird_1.png"]
                                                    ]
                                        timePerFrame:.1];
    
    SKAction *flyUp = [SKAction sequence:@[
                                           [SKAction waitForDuration:.2],
                                           [SKAction rotateToAngle:.40 duration:.2],
                                           [SKAction moveByX:30 y:30 duration:.2],
                                           [SKAction rotateToAngle:0 duration:.2],
                                           [SKAction moveByX:30 y:-30 duration:.2]
                                           ]];
                       
    SKAction *group = [SKAction group:@[flyUp,fly]];
    
    
    [flappyNode runAction:[SKAction repeatActionForever:group]];
    
    return flappyNode;
}


-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"flappy" usingBlock:^(SKNode *node, BOOL *stop){
        if (node.position.x > CGRectGetMaxX(self.view.frame)) {
            [node removeFromParent];
            SKSpriteNode *flappy = [self newFlappyNode];
            [self addChild:flappy];
        }
    }];
}

- (void)update:(NSTimeInterval)currentTime
{
    // ScrollingNodes
    [self.background update:currentTime];
}

@end
