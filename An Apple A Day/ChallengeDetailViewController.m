//
//  ChallengeDetailViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/29/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeDetailViewController.h"

@interface ChallengeDetailViewController ()

@end

@implementation ChallengeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.challenge.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedChallengeDetail"]) {
        self.tableViewController = (ChallengeTableViewController *) [segue destinationViewController];
        self.tableViewController.isChallengeDetail = YES;
        self.tableViewController.challenge = self.challenge;
    }
}

@end
