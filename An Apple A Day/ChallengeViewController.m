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
        self.tableViewController.isHomePage = YES;
        self.tableViewController.date = [NSDate date];
    }
}

#pragma mark - Actions

- (IBAction)logout:(id)sender {
    // Close the session and remove the access token from the cache
    // The session state handler (in the app delegate) will be called automatically
    [FBSession.activeSession closeAndClearTokenInformation];
}

@end
