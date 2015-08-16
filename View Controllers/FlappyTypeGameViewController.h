//
//  FlappyTypeGameViewController.h
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 4/22/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "TextComparison.h"
#import <iAd/iAd.h>
#import "EndGameViewController.h"
#import <GameKit/GameKit.h>
#import "GameRulesViewController.h"
#import "SKScrollingNode.h"
#import "WordsScene.h"
#import "iPhoneGameScene.h"

static BOOL gameCenterEnabled;
@interface FlappyTypeGameViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
-(void)authenticateLocalPlayer;

@end
