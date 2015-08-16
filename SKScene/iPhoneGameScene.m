//
//  iPhoneGameScene.m
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 6/2/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import "iPhoneGameScene.h"

@interface iPhoneGameScene()
@property (strong,nonatomic) SKScrollingNode *background;
@end

@implementation iPhoneGameScene

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.background = [SKScrollingNode scrollingNodeWithImageNamed:@"mainBackground.png" inContainerWidth:self.view.bounds.size.width];
    [self.background setScrollingSpeed:.8];
    [self.background setAnchorPoint:CGPointZero];
    [self.background setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.view.frame]];
    [self addChild:self.background];
}
- (void)update:(NSTimeInterval)currentTime
{
    // ScrollingNodes
    [self.background update:currentTime];
}
@end
