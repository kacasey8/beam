//
//  CompleteChallengeViewController.m
//  An Apple A Day
//
//  Created by Alice Jia Qi Liu on 12/25/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "CompleteChallengeViewController.h"

@interface CompleteChallengeViewController ()

@end

@implementation CompleteChallengeViewController

- (id)init {
    self = [super initWithNibName:@"CompleteChallengeViewController" bundle:nil];
    if (self != nil) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)completeChallenge:(id)sender {
    BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
    [obj setReference:[_presenter.globalKeyValueStore getValueforKey:kBuiltUserUID]
               forKey:@"user"];
    [obj setReference:[_presenter.challenge objectForKey:@"uid"]
               forKey:@"challenge"];
    [obj saveOnSuccess:^{
        // object is created successfully
        NSLog(@"Built updated challenge completed");
        _presenter.usersChallengesDailyUID = obj.uid;
        [_presenter setUpCompletedForDailyChallenge];
        [self dismissViewControllerAnimated:YES completion:nil];
    } onError:^(NSError *error) {
        // there was an error in creating the object
        // error.userinfo contains more details regarding the same
        [_presenter setUpNotCompletedForDailyChallenge]; // it failed. revert local state.
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
