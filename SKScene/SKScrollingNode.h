//
//  SKScrollingNode.h
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 5/19/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScrollingNode : SKSpriteNode
@property (nonatomic) CGFloat scrollingSpeed;

+ (id) scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float) width;
- (void) update:(NSTimeInterval)currentTime;
@end
