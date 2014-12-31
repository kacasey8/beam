//
//  ChallengeViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/29/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeViewController.h"
#import "ChallengeTableViewController.h"

@interface ChallengeViewController ()

@property (strong, nonatomic) ChallengeTableViewController *tableViewController;

@end

@implementation ChallengeViewController

NSString *dateQueried;
bool dailyCompleted;
NSDateFormatter *dateFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)activateView {
    NSLog(@"activateView");
    [self.tableViewController queryCompletedDailyChallenge];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"destinationViewController:%@", [segue destinationViewController]);
    if ([segue.identifier isEqualToString:@"embedDailyChallenge"]) {
        self.tableViewController = (ChallengeTableViewController *) [segue destinationViewController];
        self.tableViewController.isChallengeDetail = NO;
        self.tableViewController.date = [NSDate date];
    }
}

#pragma mark - Actions

- (void)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Logout"
                          message: @"Are you sure you want to logout?"
                          delegate: nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Confirm", nil];
    alert.delegate = self;
    [alert show];
}

- (void)openHistory {
    [self performSegueWithIdentifier:@"showHistory" sender:self];
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }

}
@end
