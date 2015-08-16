//
//  GameRulesViewController.m
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 5/2/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import "GameRulesViewController.h"

@interface GameRulesViewController ()
@end

@implementation GameRulesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.canDisplayBannerAds = YES;
}
@end
