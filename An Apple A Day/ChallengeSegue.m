//
//  ChallengeSegue.m
//  An Apple A Day
//
//  Created by Alice Jia Qi Liu on 12/25/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeSegue.h"

@implementation ChallengeSegue

- (void)perform {
    UIViewController *source = (UIViewController *)self.sourceViewController;
    [source.presentingViewController dismissViewControllerAnimated:YES completion:^(void){NSLog(@"HI");}];
}



@end
