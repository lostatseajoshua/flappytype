//
//  SKScrollingNode.m
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 5/19/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import "SKScrollingNode.h"

@implementation SKScrollingNode : SKSpriteNode

+ (id) scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float) width
{
    UIImage *image = [UIImage imageNamed:name];
    
    SKScrollingNode * realNode = [SKScrollingNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(width,image.size.height)];
    realNode.scrollingSpeed = 1;
    
    float total = 0;
    while(total<(width + image.size.width)){
        SKSpriteNode * child = [SKSpriteNode spriteNodeWithImageNamed:name ];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0)];
        [realNode addChild:child];
        total+=child.size.width;
    }
    
    return realNode;
}

- (void) update:(NSTimeInterval)currentTime
{
    [self.children enumerateObjectsUsingBlock:^(SKNode *child, NSUInteger idx, BOOL *stop) {
        SKSpriteNode *childShape = (SKSpriteNode * )child;
        childShape.position = CGPointMake(child.position.x-self.scrollingSpeed, child.position.y);
        if (childShape.position.x <= -childShape.size.width){
            float delta = childShape.position.x+childShape.size.width;
            childShape.position = CGPointMake(childShape.size.width*(self.children.count-1)+delta, childShape.position.y);
        }
    }];
}

@end