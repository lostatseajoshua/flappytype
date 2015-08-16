//
//  EndGameViewController.m
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 5/1/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import "EndGameViewController.h"

@interface EndGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UIButton *iPadTwitterButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadFacebookButton;
@property (strong, nonatomic) UIImage *badgeImage;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *iPadShareLabel;
@property (weak, nonatomic) IBOutlet UILabel *iPadTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@end

@implementation EndGameViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self updateView];
    if (self.score > 0) {
        [self performSelectorInBackground:@selector(saveDate) withObject:nil];
        NSLog(@"Saved score");
    }
}

-(void)updateView
{
    self.titleLabel.font = [UIFont fontWithName:@"04b19" size:50];
    self.iPadTitleLabel.font = [UIFont fontWithName:@"04b19" size:75];
    self.scoreLabel.font = [UIFont fontWithName:@"04b19" size:25];
    self.twitterButton.titleLabel.font = [UIFont fontWithName:@"04b19" size:25];
    self.facebookButton.titleLabel.font = [UIFont fontWithName:@"04b19" size:25];
    self.iPadTwitterButton.titleLabel.font = [UIFont fontWithName:@"04b19" size:50];
    self.iPadFacebookButton.titleLabel.font = [UIFont fontWithName:@"04b19" size:50];
    self.errorLabel.font = [UIFont fontWithName:@"04b19" size:25];
    self.shareLabel.font = [UIFont fontWithName:@"04b19" size:25];
    self.iPadShareLabel.font = [UIFont fontWithName:@"04b19" size:50];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.score];
    self.errorLabel.text = [NSString stringWithFormat:@"Errors: %d", self.errors];
    if(self.score <= 25){
        self.badgeImage = [UIImage imageNamed:@"redbadge.png"];
    }else if (self.score > 25 && self.score < 45){
        self.badgeImage = [UIImage imageNamed:@"purplebadge.png"];
    }else if (self.score >= 45 && self.score < 75){
        self.badgeImage = [UIImage imageNamed:@"patternbadge.png"];
    }else if (self.score >= 75 && self.score < 100){
        self.badgeImage = [UIImage imageNamed:@"pinkbadge.png"];
    }else if (self.score >=100){
        self.badgeImage = [UIImage imageNamed:@"blackbadge.png"];
    }
    
    self.badgeImageView.image = self.badgeImage;
}

-(void)saveDate
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newScore = [NSEntityDescription insertNewObjectForEntityForName:@"Scores" inManagedObjectContext:context];
    NSNumber *theScore = [[NSNumber alloc]initWithInt:self.score];
    [newScore setValue:theScore forKeyPath:@"score"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tweetMessage:(id)sender {
    
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) //check if Facebook Account is linked
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Tweet!" message:@"Please login to Twitter in your device settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
    self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self.mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Check out my score and badge I earned on Flappy Typing Test: %d! #flappytype", self.score]];
    [self.mySLComposerSheet addImage:self.badgeImage];
    
    [self presentViewController:self.mySLComposerSheet animated:YES completion:nil];
    //}
    
    [self.mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everything worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}
- (IBAction)facebookMessage:(id)sender {
    
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to post to Facebook!" message:@"Please login to Facebook in your device settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
    self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [self.mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Check out my score and badge I earned on Flappy Typing Test: %d! #flappytype", self.score]];
    [self.mySLComposerSheet addImage:self.badgeImage];
    
    [self presentViewController:self.mySLComposerSheet animated:YES completion:nil];
    //}
    
    [self.mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everything worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
