//
//  ScoresTableViewController.h
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 5/2/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <iAd/iAd.h>
@interface ScoresTableViewController : UITableViewController <UIAlertViewDelegate>
@property (strong,nonatomic) SLComposeViewController *mySLComposerSheet;
@end
