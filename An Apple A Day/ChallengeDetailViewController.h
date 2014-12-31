//
//  ChallengeDetailViewController.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/29/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeTableViewController.h"

@interface ChallengeDetailViewController : UIViewController

@property (strong, nonatomic) Challenge *challenge; //used to pass it down to ChallengeTableViewController
@property (strong, nonatomic) ChallengeTableViewController *tableViewController;
@property (strong, nonatomic) IBOutlet UIView *navBar;

@end
