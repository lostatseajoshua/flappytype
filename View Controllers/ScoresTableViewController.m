//
//  ScoresTableViewController.m
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 5/2/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import "ScoresTableViewController.h"

@interface ScoresTableViewController ()
@property (strong,nonatomic) NSMutableArray *scores;
@property int score;
@end

@implementation ScoresTableViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.canDisplayBannerAds = YES;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Scores"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"score" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error.
    }
    self.scores = [[NSArray arrayWithArray:fetchedObjects] mutableCopy];
    
    for (int i = 0; i < self.scores.count; i++) {
        NSLog(@"%@",self.scores[i]);
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.scores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSManagedObject *number = [self.scores objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"Score: %@", [number valueForKey:@"score"]]];
    
    NSLog(@"%ld",(long)indexPath.row);
    NSNumber *score = [number valueForKey:@"score"];
    NSLog(@"%f",[score floatValue]);
    if([score floatValue] <=25) cell.imageView.image = [UIImage imageNamed:@"redbadge.png"];
    if([score floatValue] >=26 && [score floatValue] <=45) cell.imageView.image = [UIImage imageNamed:@"purplebadge.png"];
    if([score floatValue] >=46 && [score floatValue] <=75) cell.imageView.image = [UIImage imageNamed:@"patternbadge.png"];
    if([score floatValue] >=76 && [score floatValue] <=99) cell.imageView.image = [UIImage imageNamed:@"pinkbadge.png"];
    if([score floatValue] >=100) cell.imageView.image = [UIImage imageNamed:@"blackbadge.png"];
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [self managedObjectContext];
        [context deleteObject:[self.scores objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self.scores removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self shareScore];
    NSManagedObject *number = [self.scores objectAtIndex:indexPath.row];
    NSNumber *aScore = [number valueForKey:@"score"];
    self.score = [aScore floatValue];

}

-(void)shareScore
{
    UIAlertView *shareView = [[UIAlertView alloc]initWithTitle:@"Share score!" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Twitter",@"Facebook", nil];
    [shareView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self tweetMessage];
    }else if (buttonIndex == 2){
        [self facebookMessage];
    }
}

- (void)tweetMessage {
    
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) //check if Facebook Account is linked
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Tweet!" message:@"Please login to Twitter in your device settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
    self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self.mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Check out my score that I earned on Flappy Typing Test: %d! #flappytype", self.score]];
    
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
- (void)facebookMessage {
    
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to post to Facebook!" message:@"Please login to Facebook in your device settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
    self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [self.mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Check out my score that I earned on Flappy Typing Test: %d!", self.score]];
    
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

@end
