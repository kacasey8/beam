//
//  ViewController.h
//  An Apple A Day
//
//  Created by Kevin Casey on 12/23/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController <FBLoginViewDelegate>
- (IBAction)facebookPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

@end

