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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)activateView {
    if ([self shouldUseCache]) {
        NSLog(@"Querying server for challenge from cache");
        //[self queryCompletedDailyChallenge];
    } else {
        NSLog(@"Querying server for challenge");
       // [self queryCompletedDailyChallenge];
    }
}

- (BOOL) shouldUseCache {
    return [dateQueried isEqualToString:[dateFormatter stringFromDate:[NSDate date]]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"destinationViewController:%@", [segue destinationViewController]);
    if ([segue.identifier isEqualToString:@"embedDailyChallenge"]) {
        self.tableViewController = (ChallengeTableViewController *) [segue destinationViewController];
        self.tableViewController.isHomePage = YES;
    }
}

#pragma mark - Actions

- (IBAction)logout:(id)sender {
    // Close the session and remove the access token from the cache
    // The session state handler (in the app delegate) will be called automatically
    [FBSession.activeSession closeAndClearTokenInformation];
}

@end
