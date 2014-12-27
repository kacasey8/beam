//
//  ChallengeViewController.h
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <BuiltIO/BuiltIO.h>
#import "Global.h"

@interface ChallengeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *challengeInformation;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (strong, nonatomic) IBOutlet UILabel *completedDescription;
@property (weak, nonatomic) IBOutlet UIImageView *completedImageView;
@property (strong, nonatomic) NSMutableDictionary *challenge;
@property (strong, nonatomic) Global *globalKeyValueStore;

- (IBAction)logout:(id)sender;

- (void)activateView;
- (void)updateCompletedDailyChallengeWithProperties:(NSDictionary *)properties;

@end
