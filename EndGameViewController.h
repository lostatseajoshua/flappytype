//
//  EndGameViewController.h
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 5/1/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
@interface EndGameViewController : UIViewController
@property int score;
@property int errors;
@property (strong,nonatomic) SLComposeViewController *mySLComposerSheet;
@end
