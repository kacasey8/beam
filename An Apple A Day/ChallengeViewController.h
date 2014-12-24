//
//  ChallengeViewController.h
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ChallengeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *challengeInformation;
@property (strong, nonatomic) IBOutlet UILabel *challengeCompleted;
- (IBAction)logout:(id)sender;

@end
