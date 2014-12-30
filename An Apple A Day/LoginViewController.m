//
//  ViewController.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/23/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    _facebookButton.layer.borderColor = [[UIColor whiteColor] CGColor];
//    _facebookButton.layer.borderWidth = 1.0f;
//    _facebookButton.layer.cornerRadius = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookPressed:(id)sender {
    // Open a session showing the user the login UI
    // You must ALWAYS ask for public_profile permissions when opening a session
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                        allowLoginUI:YES
                                completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        // Retrieve the app delegate
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
        [appDelegate sessionStateChanged:session state:state error:error];
    }];
}
@end
