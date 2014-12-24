//
//  ChallengeViewController.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeViewController.h"
#import <BuiltIO/BuiltIO.h>

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController

NSDictionary *challenge;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self getUserInfo];
    [self getDailyChallenge];
}

- (void)getUserInfo
{
    BuiltUser *user = [BuiltUser user];
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    
    [user loginWithFacebookAccessToken:fbAccessToken
                             onSuccess:^{
                                 // user has logged in successfully
                                 // user.authtoken contains the session authtoken
                                 NSLog(@"%@", user);
                             } onError:^(NSError *error) {
                                 // login failed
                                 // error.userinfo contains more details regarding the same
                                 NSLog(@"Facebook To Built Failed!!!");
                                 NSLog(@"%@", error.userInfo);
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Daily Challenge

- (void)setUpInformationForChallenge
{
    _challengeInformation.text = [challenge objectForKey:@"information"];
}

- (void)getDailyChallenge
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    BuiltQuery *test1 = [BuiltQuery queryWithClassUID:@"challenge"];
    [test1     whereKey:@"date"
               lessThan:[dateFormatter stringFromDate:[self endOfDay:[NSDate date]]]];
    BuiltQuery *test2 = [BuiltQuery queryWithClassUID:@"challenge"];
    [test2     whereKey:@"date"
            greaterThan:[dateFormatter stringFromDate:[self beginningOfDay:[NSDate date]]]];
    
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"challenge"];
    [query andWithSubqueries:@[test1,test2]];
    // this is kind of stupid. According to the docs you can put both less than
    // and greater than on a single query, but doesn't seem to work.
    // I've constructed both individually for now and 'and' them together
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"date", @"information", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSArray *results = [result getResult];
        if ([result count] == 0) {
            NSLog(@"NO DAILY CHALLENGE!");
        } else {
            challenge = [results objectAtIndex:0];
            [self setUpInformationForChallenge];
        }
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
}

- (NSDate *)beginningOfDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:date];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfDay:(NSDate *)givenDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    
    NSDate *date = [calendar dateByAddingComponents:components
                                             toDate:[self beginningOfDay:givenDate]
                                            options:0];
    
    date = [date dateByAddingTimeInterval:-1];
    
    return date;
}

#pragma mark - Actions

- (IBAction)logout:(id)sender {
    // Close the session and remove the access token from the cache
    // The session state handler (in the app delegate) will be called automatically
    [FBSession.activeSession closeAndClearTokenInformation];
}
@end
