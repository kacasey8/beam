//
//  ChallengeDetailTableViewController.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/27/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BuiltIO/BuiltIO.h>
#import "Challenge.h"
#import "Global.h"

@interface ChallengeDetailTableViewController : UITableViewController

@property (strong, nonatomic) Global *globalKeyValueStore;
@property (assign) Challenge *challenge;

@end
