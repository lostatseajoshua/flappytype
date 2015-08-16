//
//  initialViewController.m
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 4/25/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import "initialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SpriteKit/SpriteKit.h>
#import "WordsScene.h"
@interface initialViewController ()
//iPhone
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
//iPad
@property (weak, nonatomic) IBOutlet SKView *theView;
@property (weak, nonatomic) IBOutlet UILabel *iPadHeaderLabel;
@property (weak, nonatomic) IBOutlet UIButton *iPadPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadScoreButton;
@property (strong, nonatomic) WordsScene *wordScene;
@end

@implementation initialViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SKView *scene = (SKView *)self.theView;
    [scene presentScene: self.wordScene];
}

-(WordsScene *)wordScene
{
    if(!_wordScene) _wordScene = [WordsScene sceneWithSize:self.theView.bounds.size];
    return _wordScene;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)awakeFromNib
{
    self.canDisplayBannerAds = YES;
    //iPhone
    self.headerLabel.font = [UIFont fontWithName:@"04b19" size:45];
    self.playButton.titleLabel.font = [UIFont fontWithName:@"04b19" size:25];
    self.scoreButton.titleLabel.font = [UIFont fontWithName:@"04b19" size:25];
    //iPad
    self.iPadHeaderLabel.font = [UIFont fontWithName:@"04b19" size:100];
    self.iPadPlayButton.titleLabel.font = [UIFont fontWithName:@"04b19" size:40];
    self.iPadScoreButton.titleLabel.font = [UIFont fontWithName:@"04b19" size:40];
}

@end
