//
//  FlappyTypeGameViewController.m
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 4/22/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import "FlappyTypeGameViewController.h"

@interface FlappyTypeGameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *typingTextField;
@property (weak, nonatomic) IBOutlet UIImageView *flappyImageView;
@property (strong, nonatomic) TextComparison *textCompare;
@property (weak, nonatomic) IBOutlet UIProgressView *progressTimer;
@property float time;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButton;
@property int level;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@property BOOL gameStarted;
@property BOOL gameCenterinProgress;
@property UILabel *wordLabel;
@end

@implementation FlappyTypeGameViewController


#pragma mark ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.typingTextField.delegate = self;
    self.typingTextField.placeholder = @"Press Done or Spacebar to enter in text";
    [self birdFly];
    _leaderboardIdentifier = @"Flappy_Type_Leadboard";
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self makeScene];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textCompare numberRandomizer];
    
    if (gameCenterEnabled == NO) {
        [self authenticateLocalPlayer];
    }
    NSLog(@"%lu",(unsigned long)self.textCompare.letterToType.count);
    NSLog(@"%lu",(unsigned long)self.textCompare.wordsToType.count);
    NSLog(@"%lu",(unsigned long)self.textCompare.phraseToType.count);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.gameStarted = NO;
}
////////////////////////

- (IBAction)backButton:(UIBarButtonItem *)sender {
    
        if (self.gameCenterinProgress) {

        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
}


#pragma mark lazy instantation

-(TextComparison *)textCompare
{
    if (!_textCompare) {
        _textCompare = [[TextComparison alloc]init];
    }
    return _textCompare;
}


////////////

-(UIToolbar *)keyboardToolbar
{
    UIToolbar *keyboardToolbar = [[UIToolbar alloc]init];
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [keyboardToolbar sizeToFit];
    self.wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 600, 40)];
    [self.view addSubview:self.wordLabel];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc]initWithCustomView:self.wordLabel];
    self.wordLabel.textColor = [UIColor whiteColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.wordLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:35]];
    }else{
        [self.wordLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25]];
    }
    self.wordLabel.textAlignment = NSTextAlignmentCenter;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *itemsArray = @[space,labelItem,space];
    [keyboardToolbar setItems:itemsArray];
    return keyboardToolbar;
}

-(void)makeScene
{
    SKView *view = (SKView *)self.view;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        SKScene *scene = [iPhoneGameScene sceneWithSize:self.view.bounds.size];
        [view presentScene:scene];
    }else{
        SKScene *scene = [WordsScene sceneWithSize:self.view.bounds.size];
        [view presentScene:scene];

    }
}


#pragma mark TEXTFIELD DELEGATE METHODS

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.typingTextField.inputAccessoryView = [self keyboardToolbar];
    self.wordLabel.text = self.textCompare.letterToType[self.textCompare.numberForArray];
    [self gameTimer];
    self.level = 1;
    self.typingTextField.placeholder = @"";
    self.gameStarted = YES;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    static BOOL theBool;
    if (self.gameStarted == YES) {
        theBool = NO;
    }else if (self.gameStarted == NO){
        theBool = YES;
    }
    return theBool;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //get the last character inputted into the text field to use to compare
    NSString *lastCharacter = [string substringWithRange:NSMakeRange([string length]-1, 1)];
    
    //while the score is under 50, the space bar will be used to check the textfield
        
    if([lastCharacter isEqualToString:@"\n"] || [lastCharacter isEqualToString:@" "]){
        
            if(self.textCompare.score < 25){
                //CORRECT
                if ([self.textCompare compareLetters:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                    self.wordLabel.text = self.textCompare.letterToType[self.textCompare.numberForArray];
                    [self textCorrect];
                //ERROR
                    }else{
                        self.wordLabel.text = self.textCompare.letterToType[self.textCompare.numberForArray];
                        [self textError];
                    }
            
            }else if (self.textCompare.score > 25 && self.textCompare.score <49){

                if ([self.textCompare compareWords:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                    self.wordLabel.text = self.textCompare.wordsToType[self.textCompare.numberForArray];
                    [self textCorrect];
                    }else{
                       
                        [self clearTextField];
                            if (self.textCompare.score <= 25) {
                                self.wordLabel.text = self.textCompare.letterToType[self.textCompare.numberForArray];
                            }else{
                                self.wordLabel.text = self.textCompare.wordsToType[self.textCompare.numberForArray];
                            }
                        [self textError];
                    }
            
            }else if(self.textCompare.score == 25){
            
                if ([self.textCompare compareLetters:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                self.wordLabel.text = self.textCompare.letterToType[self.textCompare.numberForArray];
                    if (self.textCompare.score == 26) self.wordLabel.text = self.textCompare.wordsToType[self.textCompare.numberForArray];
                    [self textCorrect];
                    [self playPointSound];
                    self.level = 2;
                    self.time = 1;
                }else{
                    self.wordLabel.text = self.textCompare.letterToType[self.textCompare.numberForArray];
                    [self textError];
                    self.level = 1;
                }
            }else if (self.textCompare.score == 49){
                
                if ([self.textCompare compareWords:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                    //CORRECT
                    self.wordLabel.text = self.textCompare.wordsToType[self.textCompare.numberForArray];
                    [self textCorrect];
                    //IF SCORE IS 50 THEN GO TO PHRASE TO TYPE
                    if (self.textCompare.score == 50) {
                        self.wordLabel.text = self.textCompare.phraseToType[self.textCompare.numberForArray];
                        [self playPointSound];
                        self.level = 3;
                        self.time = 1;
                    }
                }else{
                    //WRONG GOES DOWN TO WORDS TO TYPE
                    self.wordLabel.text = self.textCompare.wordsToType[self.textCompare.numberForArray];
                    [self textError];
                    self.level = 2;
                }
            }else if (self.textCompare.score >= 50){
                if ([self.textCompare comparePhrase:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                    self.wordLabel.text = self.textCompare.phraseToType[self.textCompare.numberForArray];
                    [self textCorrect];
                }else{
                    if (self.textCompare.score < 50) {
                        self.wordLabel.text = self.textCompare.wordsToType[self.textCompare.numberForArray];
                    }else{
                        self.wordLabel.text = self.textCompare.phraseToType[self.textCompare.numberForArray];
                    }
                    [self textError];
                }
        }
}
    
    self.title = [NSString stringWithFormat:@"Score: %d",self.textCompare.score];
    self.navigationController.navigationItem.prompt = [NSString stringWithFormat:@"Error: %d", self.textCompare.error];
    if(self.textCompare.error == 10) {
        if (self.textCompare.score >= 25) {
                self.gameStarted = NO;
                [self.typingTextField endEditing:YES];
                [self.timer invalidate];
                UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"Too many Errors!\nGame Over!"
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"Okay", nil];
                [gameOverAlert show];
                [self reportScore];
            }else{
            self.gameStarted = NO;
            [self.typingTextField endEditing:YES];
            [self.timer invalidate];
            UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"Too many Errors!\nGame Over!"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Okay", nil];
            [gameOverAlert show];
        }
    }
    return YES;
}

//////////////////////

-(void)clearTextField
{
    NSString *string = @"";
    //self.typingTextField.text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.typingTextField.text =  string;

}

-(void)shakeAnimation:(UIView*) view {
    const int reset = 5;
    const int maxShakes = 10;
    
    //pass these as variables instead of statics or class variables if shaking two controls simultaneously
    static int shakes = 0;
    static int translate = reset;
    
    [UIView animateWithDuration:0.09-(shakes*.01) // reduce duration every shake from .09 to .04
                          delay:0.01f//edge wait delay
                        options:(enum UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{view.transform = CGAffineTransformMakeTranslation(translate, 0);}
                     completion:^(BOOL finished){
                         if(shakes < maxShakes){
                             shakes++;
                             
                             //throttle down movement
                             if (translate>0)
                                 translate--;
                             
                             //change direction
                             translate*=-1;
                             [self shakeAnimation:view];
                         } else {
                             view.transform = CGAffineTransformIdentity;
                             shakes = 0;//ready for next time
                             translate = reset;//ready for next time
                             return;
                         }
                     }];
}
-(void)textCorrect
{
    self.typingTextField.backgroundColor = [UIColor greenColor];
    [self performSelector:@selector(changeColor) withObject:nil afterDelay:.5];
    //[self playWingSound];
    if(self.time <= 1 && !self.time == 0.0f){
        if(self.level == 1)self.time = self.time + .04;
        if (self.level == 2) self.time = self.time + .06;
        if(self.level == 3) self.time = self.time + .08;
    }
    [self.flappyImageView startAnimating];
    [self clearTextField];
}
-(void)textError
{
    [self shakeAnimation:self.typingTextField];
    self.typingTextField.backgroundColor = [UIColor redColor];
    [self performSelector:@selector(changeColor) withObject:nil afterDelay:.5];
    [self playDieSound];
    [self.flappyImageView stopAnimating];
    self.flappyImageView.image = [UIImage imageNamed:@"flappyBirdWingDownBlue.png"];
    [self clearTextField];
}
-(void)changeColor
{
    self.typingTextField.backgroundColor = [UIColor whiteColor];
}

#pragma mark BUTTON SOUNDS

-(void)playPointSound
{
    NSString *effectTitle = @"sfx_point";
    
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:effectTitle ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
}
-(void)playWingSound
{
    NSString *effectTitle = @"sfx_wing";
    
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:effectTitle ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
}
-(void)playDieSound
{
    NSString *effectTitle = @"sfx_die";
    
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:effectTitle ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
}
/////////////

-(void)birdFly
{
    NSArray *imageArray = @[[UIImage imageNamed:@"flappyBirdWingMiddleBlue"],[UIImage imageNamed:@"flappyBirdWingDownBlue"],[UIImage imageNamed:@"flappyBirdWingMiddleBlue"],[UIImage imageNamed:@"flappyBirdWingUpBlue"]];
    
    NSArray *purpleImageArray = @[[UIImage imageNamed:@"purpleFlappyBirdWingMiddle"],[UIImage imageNamed:@"purpleFlappyBirdWingDown"],[UIImage imageNamed:@"purpleFlappyBirdWingMiddle"],[UIImage imageNamed:@"purpleFlappyBirdWingUp"]];
    NSArray *greenImageArray = @[[UIImage imageNamed:@"greenFlappyBirdWingMiddle"],[UIImage imageNamed:@"greenFlappyBirdWingDown"],[UIImage imageNamed:@"greenFlappyBirdWingMiddle"],[UIImage imageNamed:@"greenFlappyBirdWingUp"]];
    NSArray *yellowImageArray = @[[UIImage imageNamed:@"yellowFlappyBirdWingMiddle"],[UIImage imageNamed:@"yellowFlappyBirdWingDown"],[UIImage imageNamed:@"yellowFlappyBirdWingMiddle"],[UIImage imageNamed:@"yellowFlappyBirdWingUp"]];
    NSArray *orangeImageArray = @[[UIImage imageNamed:@"orangeflappyBirdWingMiddle"],[UIImage imageNamed:@"orangeflappyBirdWingDown"],[UIImage imageNamed:@"orangeflappyBirdWingMiddle"],[UIImage imageNamed:@"orangeflappyBirdWingUp"]];
    
    NSArray *arrayOfImageArrays = @[imageArray,orangeImageArray,purpleImageArray,greenImageArray,yellowImageArray];
     
    self.flappyImageView.animationImages = arrayOfImageArrays[arc4random_uniform(4)];
    
    self.flappyImageView.animationDuration = 1;
    [self.flappyImageView startAnimating];
}

-(void)gameTimer
{
    self.progressTimer.progress = 1;
    self.time = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.2f
                                         target: self
                                       selector: @selector(updateTimer)
                                       userInfo: nil
                                        repeats: YES];
}
-(void) updateTimer
{
    if(self.time <= 0.0f)
    {
        //Invalidate timer when time reaches 0
        [self.timer invalidate];
        self.gameStarted = NO;
        [self.typingTextField endEditing:YES];
        if (gameCenterEnabled == YES) {
            NSLog(@"reporting score");
            [self reportScore];
        }
        UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Time's Up!\nGame Over!"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Okay", nil];
        [gameOverAlert show];

    }
    else
    {
        self.time -= 0.01;
        self.progressTimer.progress = self.time;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"endGame"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        EndGameViewController *endGameViewController = (EndGameViewController *)navigationController.topViewController;
        endGameViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
        endGameViewController.score = self.textCompare.score;
        endGameViewController.errors = self.textCompare.error;
    }
}

#pragma mark GAMECENTER

-(void)authenticateLocalPlayer{
    self.gameCenterinProgress = YES;
    NSLog(@"validating");
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self.timer invalidate];
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                gameCenterEnabled = YES;
                NSLog(@"authenticated");
                // Get the default leaderboard identifier.
                self.gameCenterinProgress = NO;
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = @"Flappy_Type_Leadboard";
                    }
                }];
            }
            
            else{
                gameCenterEnabled = NO;
                self.gameCenterinProgress = NO;
            }
        }
    };
}
-(void)reportScore{
    // Create a GKScore object to assign the score and report it as a NSArray object.
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = self.textCompare.score;
    NSLog(@"reporting score to %@",_leaderboardIdentifier);
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"endGame" sender:self];

    }
}


@end
