//
//  CalendarTableViewController.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *completedChallenges;

- (void)updateCompletedChallenges;

@end
