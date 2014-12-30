//
//  ChallengeTableViewController.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/28/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"

@interface ChallengeTableViewController : UITableViewController

@property BOOL isChallengeDetail; //used to determine if update button is visible
@property (strong, nonatomic) Challenge *challenge;
@property (strong, nonatomic) NSDate *date;

- (void)updateCompletedDailyChallenge;
- (void)queryCompletedDailyChallenge;

@end
